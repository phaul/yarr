# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Yarr::Command::Fact do
  let(:fact) { create(:fact) }
  let(:ast) { Yarr::AST.new(command: command, name: name) }
  let(:name) { fact.name }
  let(:command) { 'fact' }

  describe '#match?' do
    it 'matches the command fact' do
      expect(described_class).to be_able_to_handle ast
    end
  end

  describe '#handle' do
    subject { described_class.new(ast: ast).handle }

    let(:handling) do
      subject
      fact.reload
    end

    it { is_expected.to eq fact.content }

    context 'when no factoid is found' do
      let(:name) { 'non-existent' }

      it { is_expected.to eq "I don't know anything about non-existent." }
    end

    it 'increments the count of the factoid' do
      expect { handling }.to change(fact, :count).from(0).to(1)
    end
  end
end
