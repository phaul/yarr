require 'spec_helper'
require 'yarr/command/list'
require 'helpers/not_implemented_helper'

module Yarr
  module Command
    RSpec.describe 'list command' do
      let(:ast) { { class_name: '%', method_name: '%' } }

      describe List do
        subject { described_class.new(ast) }

        does_not_implement :query
        does_not_implement :target
      end

      describe ListCall do
        subject { described_class.new(ast) }

        does_not_implement :flavour
      end

      describe ListInstanceMethod do
        describe '#handle' do
          subject { described_class.new(ast).handle }

          it { is_expected.to eq  'Array#size, Array#abbrev' }
        end
      end

      describe ListClassMethod do
        describe '#handle' do
          subject do
            described_class.new(class_name: 'Arr%', method_name: 'n%').handle
          end

          it { is_expected.to eq  'Array.new' }

          context 'when nothing is found' do
            subject do
              described_class.new(class_name: 'NonExistent').handle
            end

            it { is_expected.to match(/\AI haven't found any/) }
          end
        end
      end

      describe ListClassName do
        describe '#handle' do
          subject { described_class.new(class_name: 'Array').handle }

          it { is_expected.to eq  'Array, Array (abbrev)' }

          context 'when nothing is found' do
            subject do
              described_class.new(class_name: 'NonExistent').handle
            end

            it { is_expected.to match(/\AI haven't found any/) }
          end
        end
      end

      describe ListMethodName do
        describe '#handle' do
          subject do
            described_class.new(method_name: 'si%').handle
          end

          it { is_expected.to eq  'Array#size' }

          context 'when nothing is found' do
            subject do
              described_class.new(method_name: 'non_existent').handle
            end

            it { is_expected.to match(/\AI haven't found any/) }
          end
        end
      end
    end
  end
end
