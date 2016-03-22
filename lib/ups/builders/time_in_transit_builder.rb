require 'time'

module UPS
  module Builders
    class TimeInTransitBuilder < BuilderBase
      include Ox

      attr_accessor :transit_from_root, :transit_to_root

      def initialize
        super 'TimeInTransitRequest'

        self.document.nodes.insert 2,Instruct.new('xml version=\'1.0\'')
        add_request('TimeInTransit', '')

        self.transit_from_root = Element.new('TransitFrom')
        root << self.transit_from_root

        self.transit_to_root = Element.new('TransitTo')
        root << self.transit_to_root
      end

      def add_transit_from_address(opts = {})
        self.transit_from_root.nodes.clear
        self.transit_from_root << AddressArtifactFormatBuilder.new(opts).to_xml
      end

      def add_transit_to_address(opts = {})
        self.transit_to_root.nodes.clear
        self.transit_to_root << AddressArtifactFormatBuilder.new(opts).to_xml
      end

      def add_pickup_date(date)
        root << element_with_value('PickupDate', date.strftime('%Y%m%d'))
      end

      def add_shipment_weight(weight, unit)
        root << Element.new('ShipmentWeight').tap do |elem|
          elem << element_with_value('Weight', weight)
          elem << Element.new('UnitOfMeasurement').tap do |unit_elem|
            unit_elem << element_with_value('Code', unit)
          end
        end
      end

      def add_total_packages_in_shipment(number_of_packages)
        root << element_with_value('TotalPackagesInShipment', number_of_packages)
      end

      def add_invoice_line_total(line_total, currency_code)
        root << Element.new('InvoiceLineTotal').tap do |elem|
          elem << element_with_value('CurrencyCode', currency_code)
          elem << element_with_value('MonetaryValue', line_total)
        end
      end
    end
  end
end
