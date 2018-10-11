require_relative '../spec_helper'
require 'yarr/message'
require 'yarr/database' # TODO : test double

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

    RSpec.describe Parser do
      it 'raises errror on empty target' do
        expect { subject.parse('') }.to raise_error Parslet::ParseFailed
      end

      it 'raises error on invalid target' do
        expect { subject.parse('@@') }.to raise_error Parslet::ParseFailed
      end

      it 'parses "Class" as class name' do
        expect(subject.parse('Class')).to eq({class_name: 'Class' })
      end

      it 'allows for % meta chars in a class name' do
        expect(subject.parse('Cl%ss')).to eq({class_name: 'Cl%ss' })
      end

      it 'allows for upper case inside a class name' do
        expect(subject.parse('CL%ss')).to eq({class_name: 'CL%ss' })
      end

      it 'parses method as method name' do
        expect(subject.parse('method')).to eq({method_name: 'method' })
      end

      it 'allows for % meta chars in a class name' do
        expect(subject.parse('me%hod')).to eq({method_name: 'me%hod' })
      end

      it 'raises error for upper case inside a method name' do
        expect { subject.parse('mEtHoD') }.to raise_error Parslet::ParseFailed
      end

      it 'parses % as a method' do
        expect(subject.parse('%')).to eq({method_name: '%' })
      end

      it 'parses "Array#size" as instance method' do
        expect(subject.parse('Array#size')).to eq({ instance_method:
                                                   { class_name: 'Array',
                                                     method_name: 'size' }})
      end

      it 'parses "File.size" as class method' do
        expect(subject.parse('File.size')).to eq({ class_method:
                                                   { class_name: 'File',
                                                     method_name: 'size' }})
      end

      it 'needs more examples'
    end
=begin
  RSpec.describe Message do
    describe '#reply_to' do
      it 'handles commands it doesn\'t understand' do
        expected_reply = 'I did not understand command xxx.'
        expect(subject.reply_to('xxx')).to eql expected_reply
      end

      it 'replies to "ri"'

      it 'replies to "ri aa"' do
        expect(subject.reply_to('ri aa')).not_to match(/did not understand/)
      end

      it 'dispatches to #ri' do
        subject.reply_to('ri aa')
        expect(handle_ri).to have_been_called
      end

      it 'replies to list'
      it 'dispatches to #list'
    end

    describe '.ri' do
      context 'when message is in the form of Class#method' do
        it 'gives the url'

        context 'when it\'s not found' do
          it 'reports that'
        end
      end

      context 'when message is in the form of Class.method' do
        it 'gives the url'

        context 'when it\'s not found' do
          it 'reports that'
        end
      end

      context 'when message is in the form of Class' do
        it 'gives the url'

        context 'when it\'s not found' do
          it 'reports that'
        end
      end

      context 'when there is multiple name matches' do
        it 'mentions that in the reply'
      end
    end

    describe '.list' do
      it 'lists the info about the asked subject'
    end
  end
=end
  end
end
