# frozen_string_literal: true

require 'yarr/command/base'
require 'yarr/query'
require 'yarr/command/concern/ast_digger'
require 'yarr/command/concern/authorize'
require 'yarr/command/concern/user'

module Yarr
  module Command
    # Adds a new factoid if there isn't one already with the same name
    class AddFact < Base
      extend Concern::ASTDigger
      prepend Concern::Authorize
      include Concern::User

      authorize_for role: :op

      digger :name
      digger :content

      # @param ast [AST] parsed ast
      # @return [True|False] can this command handle the AST?
      def self.match?(ast)
        ast[:command] == 'fact' && ast[:sub_command] == 'add'
      end

      # Runs the command
      def handle
        DB.transaction { Query::Fact.by_name(name).save_content(content) }
      end
    end
  end
end
