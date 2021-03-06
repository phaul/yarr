# frozen_string_literal: true

require 'spec_helper'
require 'yarr/command'

module Yarr
  RSpec.describe Command do
    let(:dispatcher) { subject }

    context 'with ri command' do
      it 'handles method names' do
        handler = dispatcher.for_ast(command: 'ri', method_name: 'aa')

        expect(handler).to be_a Command::RiMethodName
      end

      it 'handles class names' do
        handler = dispatcher.for_ast(command: 'ri', class_name: 'Aa')

        expect(handler).to be_a Command::RiClassName
      end

      it 'handles instance methods' do
        handler = dispatcher.for_ast(command: 'ri', instance_method: 'Aa')

        expect(handler).to be_a Command::RiInstanceMethod
      end

      it 'handles class methods' do
        handler = dispatcher.for_ast(command: 'ri', class_method: 'Aa')

        expect(handler).to be_a Command::RiClassMethod
      end
    end

    context 'with list command' do
      it 'handles method names' do
        handler = dispatcher.for_ast(command: 'list', method_name: 'aa')

        expect(handler).to be_a Command::ListMethodName
      end

      it 'handles class names' do
        handler = dispatcher.for_ast(command: 'list', class_name: 'Aa')

        expect(handler).to be_a Command::ListClassName
      end

      it 'handles instance methods' do
        handler = dispatcher.for_ast(command: 'list', instance_method: 'Aa')

        expect(handler).to be_a Command::ListInstanceMethod
      end

      it 'handles class methods' do
        handler = dispatcher.for_ast(command: 'list', class_method: 'Aa')

        expect(handler).to be_a Command::ListClassMethod
      end
    end

    context 'with fake command' do
      it 'handles class methods' do
        handler = dispatcher.for_ast(command: 'fake', class_method: 'Aa')

        expect(handler).to be_a Command::Fake
      end

      context 'with invalid content' do
        it 'rejects it' do
          handler = dispatcher.for_ast(command: 'fake')

          expect(handler).not_to be_a Command::Fake
        end
      end
    end

    context 'with renick command' do
      it 'is a Rencik' do
        handler = dispatcher.for_ast(command: 'renick')

        expect(handler).to be_a Command::Renick
      end
    end

    context 'with evaluate command' do
      it 'is an Evaulate' do
        handler = dispatcher.for_ast(evaluate: 13)

        expect(handler).to be_a Command::Evaluate
      end
    end

    context 'with url evaluate command' do
      it 'is a URLEvaluate' do
        handler = dispatcher.for_ast(url_evaluate: 'http://x.org')

        expect(handler).to be_a Command::URLEvaluate
      end
    end

    context 'with fact command' do
      it 'is a Fact' do
        handler = dispatcher.for_ast(command: 'fact')

        expect(handler).to be_a Command::Fact
      end
    end

    context 'with no matching real command' do
      it 'defaults to Base' do
        handler = dispatcher.for_ast(command: 'xxx')

        expect(handler).to be_a Command::Base
      end
    end

    context 'without a user or irc given' do
      it 'creates a handler with NoIRC and NoIRC::User' do
        handler = dispatcher.for_ast(command: 'xxx')

        expect(handler).to match(an_object_having_attributes(irc: NoIRC, user: an_instance_of(NoIRC::User)))
      end
    end
  end
end
