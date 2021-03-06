# frozen_string_literal: true

require 'spec_helper'
require 'yarr/command/renick'

module Yarr
  module Command
    RSpec.describe Renick do
      let(:ast) { AST.new(command: 'renick') }
      let(:irc) { spy('irc') }
      let(:command) { described_class.new(ast: ast, irc: irc) }

      describe '#handle' do
        it 'invokes #nick= on the irc provider' do
          command.handle
          expect(irc).to have_received(:nick=).with(Yarr::CONFIG.nick)
        end
      end
    end
  end
end
