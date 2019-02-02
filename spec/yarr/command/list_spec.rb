require 'spec_helper'
require 'yarr/command/list'

module Yarr
  module Command
    RSpec.describe 'list command' do
      let(:ast) { Yarr::AST.new(class_name: '%', method_name: '%') }

      describe ListInstanceMethod do
        describe '#handle' do
          subject { described_class.new(ast).handle }

          it { is_expected.to eq 'Array#size, Array#abbrev' }
        end

        describe '#target' do
          subject { described_class.new(ast).send :target }

          it { is_expected.to eq 'instance method % on %' }
        end
      end

      describe ListClassMethod do
        describe '#handle' do
          let(:ast) { Yarr::AST.new(class_name: 'Arr%', method_name: 'n%') }
          subject { described_class.new(ast).handle }

          it { is_expected.to eq 'Array.new' }
        end
      end

      describe ListClassName do
        describe '#handle' do
          let(:ast) { Yarr::AST.new(class_name: 'Array') }
          subject { described_class.new(ast).handle }

          it { is_expected.to eq 'Array, Array (abbrev)' }
        end

        describe '#target' do
          subject { described_class.new(ast).send :target }

          it { is_expected.to eq 'class %' }
        end
      end

      describe ListMethodName do

        describe '#handle' do
          let(:ast) { Yarr::AST.new(method_name: 'si%') }
          subject { described_class.new(ast).handle }

          it { is_expected.to eq 'Array#size' }
        end

        describe '#target' do
          subject { described_class.new(ast).send :target }

          it { is_expected.to eq 'method %' }
        end
      end
    end
  end
end
