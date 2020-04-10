require 'yarr/command'
require 'yarr/input_parser'
require 'yarr/message/truncator'
require 'yarr/no_irc'

# Responds to rdoc documentation queries with links and more.
module Yarr
  # Handles the incoming message string and returns a response string.
  class Bot
    include Message::Truncator

    # The YARR IRC bot
    # @param irc_provider [Cinch::Bot] IRC functionality provider.
    def initialize(irc_provider = NoIRC)
      @parser = InputParser.new
      @irc = irc_provider
    end

    # Replies to a message
    # @example
    #
    #   bot = Yarr::Bot.new
    #   bot.reply_to 'ri Array' # => "https://ruby-doc.org/core-2.5.1/Array.html"
    #   bot.reply_to 'ast ast' # => "{:command=>\"ast\", :method_name=>\"ast\"}"
    #
    # @param message [String] incoming message (without IRC command prefix)
    # @param user [Cinch::Bot|Yarr::NoIRC::User] message sender
    # @return [String] response string
    def reply_to(message, user = NoIRC::User.new)
      reply_to_or_raise(message, user)
    rescue Error => error
      error.message
    end

    private

    def reply_to_or_raise(message, user)
      ast, stuff = parse_input(message)
      response = Command.for_ast(ast, @irc, user).handle
      post_process(response, stuff)
    end

    def parse_input(message)
      ast = @parser.parse(message.chomp)
      stuff = ast[:stuff] || ''
      [ast, stuff]
    end

    def post_process(response, stuff)
      if stuff.empty?
        response
      else
        user = @irc.user_list.find(stuff)
        if user then user.nick + ': ' << response
        else response << ', ' << truncate(stuff)
        end
      end
    end
  end
end
