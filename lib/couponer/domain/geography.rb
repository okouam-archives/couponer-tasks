module Couponer
  module Domain
    class Geography

      def self.create(link, name)
        case name
          when 'Groupon'
            identify(link[31..-1])
          when 'KGB'
            identify(link[26..-1])
          when 'Living Social'
            identify('national/')
          when 'Mighty Deals'
            identify(link[35..-1])
          when 'Wowcher'
            identify(link[31..-1])
          else
            raise "Unknown merchant #{name}"
        end
      end

      def self.identify(fragment)
        length = fragment.index('/') - 1
        TermTaxonomy.create(fragment[0..length], 'geography')
      end

    end
  end
end

