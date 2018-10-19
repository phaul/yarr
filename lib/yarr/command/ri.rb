require 'yarr/command/base'
require 'yarr/query'

module Yarr
  module Command
    # Base class for all ri commands
    class Ri < Base
      private

      def response(result)
        count = result.count
        case count
        when 0 then "Found no entry that matches #{target}"
        when 1 then "https://ruby-doc.org/#{result.first.url}"
        else "I found #{count} entries matching #{target}. #{advice}"
        end
      end

      def target
        raise NotImplementedError
      end

      def advice
        raise NotImplementedError
      end
    end

    # Base class for ri commands handling calls.
    class RiCall < Ri
      private

      def query
        Query::Method.where(name: method,
                            flavour: flavour,
                            klass: Query::Klass.where(name: klass))
      end

      def target
        "class #{klass} #{flavour} method #{method}"
      end

      def advice
        ''
      end

      def flavour
        raise NotImplementedError
      end
    end

    # Handles 'ri Array#size' like commands
    class RiInstanceMethod < RiCall
      private def flavour
        'instance'
      end
    end

    # Handles 'ri Array.size' like commands
    class RiClassMethod < RiCall
      private def flavour
        'class'
      end
    end

    # Handles 'ri size' like commands
    class RiMethodName < Ri
      private

      def query
        Query::Method.where(name: method)
      end

      def target
        "method #{method}"
      end

      def advice
        "Use &list #{method} if you would like to see a list"
      end
    end

    # Handles 'ri File' like commands
    class RiClassName < Ri
      private

      def query
        Query::Klass.where(name: klass)
      end

      # TODO
      # :reek:FeatureEnvy I cannot find a good way to fix this.

      def response(result)
        core = result.find(&:core?)
        if result.count > 1 && core
          "https://ruby-doc.org/#{core.url}"
        else
          super
        end
      end
    end
  end
end
