require 'yarr/message/command_dispatcher'
module Yarr
  module Message
    RSpec.describe CommandDispatcher do
      subject do
        klass = described_class
        Class.new { include klass }.new
      end

      it 'handles commands it doesn\'t understand' do
        subject.dispatch('xxx')

        expect(subject.error?).to eql true
        expect(subject.error_message).to eql 'I did not understand command xxx.'
      end

      it 'handles "ri"' do
        subject.dispatch('ri')

        expect(subject.error?).to eql false
        expect(subject.dispatch_method).to eql :ri
        expect(subject.target).to eql ''
      end

      it 'handles "ri aa"' do
        subject.dispatch('ri aa')

        expect(subject.error?).to eql false
        expect(subject.dispatch_method).to eql :ri
        expect(subject.target).to eql 'aa'
      end

      it 'handles "what_is"' do
        subject.dispatch('what_is')

        expect(subject.error?).to eql false
        expect(subject.dispatch_method).to eql :what_is
        expect(subject.target).to eql ''
      end

      it 'handles "what_is aa"' do
        subject.dispatch('what_is aa')

        expect(subject.error?).to eql false
        expect(subject.dispatch_method).to eql :what_is
        expect(subject.target).to eql 'aa'
      end

      it 'handles "list"' do
        subject.dispatch('list')

        expect(subject.error?).to eql false
        expect(subject.dispatch_method).to eql :list
        expect(subject.target).to eql ''
      end

      it 'handles "list aa"' do
        subject.dispatch('list aa')

        expect(subject.error?).to eql false
        expect(subject.dispatch_method).to eql :list
        expect(subject.target).to eql 'aa'
      end
    end
  end
end
