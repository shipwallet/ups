module UPS
  module Builders
    class GeocodeBuilder < BuilderBase
      include Ox

      attr_accessor :opts

      def initialize(opts = {})
        self.opts = opts
      end

      def latitude
        element_with_value('Latitude', opts[:latitude]) unless opts[:latitude].nil?
      end

      def longitude
        element_with_value('Longitude', opts[:longitude]) unless opts[:longitude].nil?
      end

      def to_xml
        Element.new('Geocode').tap do |elem|
          elem << latitude unless latitude.nil?
          elem << longitude unless longitude.nil?
        end
      end
    end
  end
end
