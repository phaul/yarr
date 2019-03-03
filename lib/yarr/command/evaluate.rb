require 'yarr/evaluator_service'
require 'yarr/configuration'
require 'yarr/command/concern/ast_digger'
require 'yarr/message/truncator'

module Yarr
  module Command
    # evaluates the user's message using an online evaluation service like
    # carc.in
    class Evaluate < Base
      extend Concern::ASTDigger
      digger(:mode) { |mode| @config[:modes][mode || :default] }
      digger(:lang) { |lang| lang || :default }
      digger(:code) { |code| preprocess(code.dup) }

      def self.match?(ast)
        ast.key? :evaluate
      end

      # @param web_service [#post] A web client that can post
      # @param config [Configuration] Configuration loaded
      def initialize(ast,
                     web_service = EvaluatorService.new,
                     config = Yarr.config)
        super(ast)

        @service = web_service
        @config = config.evaluator
      end

      def handle
        response = @service.request(
          EvaluatorService::Request.new(code, service_lang))
        respond_with(response)
      end

      private

      def filter(code)
        mode[:filter].each { |from, to| code.gsub!(from, to) }
        code
      end

      def preprocess(code)
        code = filter(code)
        format(template, code.lstrip)
      end

      def template
        format = mode[:format]
        case format
        when Hash then format[lang]
        else format
        end
      end

      def respond_with(response)
        url = response.url
        case mode[:output]
        when :truncate
          Message::Truncator.truncate(
            response.output,
            omission: '... check link for more',
            suffix: " (#{url})"
          )
        when :link
          "I have #{mode[:verb]} your code, the result is at #{url}"
        else
          raise 'output mode is neither :truncate nor :link. config file error'
        end
      end

      def service_lang
        @config[:languages][lang]
      end
    end
  end
end
