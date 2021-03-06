# frozen_string_literal: true

require 'spec_helper'
require 'yarr/command/evaluate'
require 'yarr/evaluator/request'
require 'yarr/evaluator/mode'
require 'json'

RSpec.describe Yarr::Command::Evaluate do
  let(:web_service) { instance_double(Yarr::Evaluator::Service) }

  let(:configuration) do
    double 'configuration',
           evaluator: {
             url: 'http://fake.com',
             languages: { '22': '2.2.2' },
             modes: {
               default: Yarr::Evaluator::Mode.new(filter: {}, format: '%s', output: :truncate),
               ast: Yarr::Evaluator::Mode.new(
                 filter: { '\\' => '\\\\', '`' => '\\\`' },
                 format: { default: 'new ast of(%%q`%s`)', '22': 'ast of(%%q`%s`)' },
                 output: :link,
                 verb: 'cooked',
                 escape: true
               )
             }
           }
  end

  let(:command) do
    described_class.new(ast: ast, web_service: web_service, configuration: configuration)
  end

  describe '#handle' do
    context 'with 1 + 1' do
      let(:ast) { Yarr::AST.new(evaluate: { code: '1 + 1' }) }

      it 'sends the right request to web_service' do
        expect(web_service).to receive(:request).with(Yarr::Evaluator::Request.new('1 + 1'))
        allow(web_service).to receive(:request).and_return(evaluator_response_double(stdout: '2'))

        command.handle
      end

      it 'returns the right result' do
        allow(web_service).to receive(:request).and_return(evaluator_response_double(stdout: '2'))

        expect(command.handle).to eq '# => 2 (http://fake.com/evaluated)'
      end
    end

    context 'with mode ast and lang 22' do
      let(:ast) do
        Yarr::AST.new(evaluate: { mode: 'ast', lang: '22', code: '`1 + 1`' })
      end

      it 'sends the right request to web_service' do
        expect(web_service).to receive(:request).with(Yarr::Evaluator::Request.new('ast of(%q`\\`1 + 1\\``)', '2.2.2'))

        allow(web_service).to receive(:request).and_return(evaluator_response_double(stdout: '2'))
        command.handle
      end

      it 'returns the right result' do
        allow(web_service).to receive(:request).and_return(evaluator_response_double(stdout: '2'))
        expect(command.handle).to eq 'I have cooked your code, the result is at http://fake.com/evaluated'
      end
    end

    context 'with default lang' do
      let(:ast) do
        Yarr::AST.new(evaluate: { mode: 'ast', code: '`1 + 1`' })
      end

      it 'sends the right request to web_service' do
        text = 'new ast of(%q`\\`1 + 1\\``)'
        expect(web_service).to receive(:request).with(Yarr::Evaluator::Request.new(text))
        allow(web_service).to receive(:request).and_return(evaluator_response_double(stdout: '2'))

        command.handle
      end
    end
  end
end
