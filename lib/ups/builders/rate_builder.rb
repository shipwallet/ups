require 'ox'

module UPS
  module Builders
    # The {RateBuilder} class builds UPS XML Rate Objects.
    #
    # @author Paul Trippett
    # @since 0.1.0
    class RateBuilder < BuilderBase
      include Ox

      # Initializes a new {RateBuilder} object
      #
      def initialize
        super 'RatingServiceSelectionRequest'

        add_request('Rate', 'Rate')
      end

      def add_shipment_indication_type(opts = {})
        shipment_root << Ox::Element.new(:ShipmentIndicationType).tap do |e|
          e << element_with_value('Code', opts[:code])
        end
      end

      def add_service(opts = {})
        shipment_root << Ox::Element.new(:Service).tap do |e|
          e << element_with_value('Code', opts[:code])
        end
      end
    end
  end
end
