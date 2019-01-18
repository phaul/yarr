require 'json'
require 'typhoeus'
require 'yarr/configuration'
require 'yarr/message/truncator'

module Yarr
  # evaluates the user's message using an online evaluation service like carc.in
  class Evaluator
    include Message::Truncator

    # @param override [String] the input fragment between & and >>
    # @param web_service [#post] A web client that can post
    # @param config [Configuration] Configuration loaded
    def initialize(override, web_service = Typhoeus, config = Yarr.config)
      @service = web_service

     /\A(?<o_mode>[[:alpha:]]+)?(?<o_lang>\d{2})?/ =~ override
      config = config.evaluator

      o_lang ||= :default
      @lang = config[:languages][o_lang]
      @mode = config[:modes][o_mode || :default]
      @format = format(@mode[:format], o_lang)
      @url = config[:url]

      unless @mode && @lang && @format
        raise StandardError, 'Couldn\'t match lang/mode'
      end
    end

    # @param code [String] user code to evaluate
    def evaluate(code)
      code = massage_code code

      response = request_evaluation_of(code)

      respond_with(response)
    end

    private

    def request_evaluation_of(code)
      payload = {run_request: {language: 'ruby', version: @lang, code: code}}
      headers = {'Content-Type': 'application/json; charset=utf-8'}
      response = @service.post(@url, {
        body: payload.to_json,
        headers: headers
      }).response_body

      JSON.parse(response)
    end

    def respond_with(response)
      url = response['run_request']['run']['html_url']
      output = response['run_request']['run']['stdout']

      case @mode[:output]
      when :truncate
        output.prepend('# => ')
        max_length = Message::Truncator::MAX_LENGTH - url.length - 3
        output = truncate(output,
                          omission: "... check link for more",
                          max_length: max_length)
        output << " (#{url})"
      when :link
        "I have #{@mode[:verb]} your code, the result is at #{url}"
      else
        raise RuntimeError,
          'output mode is neither :truncate nor :link. config file error'
      end
    end

    def format(format, o_lang)
      case format
      when Hash then format[o_lang]
      when String then format
      else
        raise RuntimeError,
          'format is not a hash nor a string. config file error'
      end
    end

    def massage_code(code)
      if @mode[:escape]
        code.gsub!("\\", "\\\\")
        code.gsub!('`', '\\\`')
      end

      sprintf @format, code.lstrip
    end
  end
end
