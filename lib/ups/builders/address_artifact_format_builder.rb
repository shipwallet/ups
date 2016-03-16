require 'ox'

module UPS
  module Builders
    class AddressArtifactFormatBuilder < BuilderBase
      include Ox

      attr_accessor :opts

      def initialize(opts = {})
        self.opts = opts
      end

      def political_division_2
        element_with_value('PoliticalDivision2', opts[:political_division_2]) unless opts[:political_division_2].nil?
      end

      def political_division_1
        element_with_value('PoliticalDivision1', opts[:political_division_1]) unless opts[:political_division_1].nil?
      end

      def country_code
        element_with_value('CountryCode', opts[:country_code]) unless opts[:country_code].nil?
      end

      def postcode_primary_low
        element_with_value('PostcodePrimaryLow', opts[:postcode_primary_low]) unless opts[:postcode_primary_low].nil?
      end

      def residential_address_indicator
        Element.new('ResidentialAddressIndicator')
      end

      def to_xml
        Element.new('AddressArtifactFormat').tap do |address|
          address << political_division_2 unless political_division_2.nil?
          address << political_division_1 unless political_division_1.nil?
          address << country_code unless country_code.nil?
          address << postcode_primary_low unless postcode_primary_low.nil?
          address << residential_address_indicator if opts[:residential_address_indicator] == true
        end
      end
    end
  end
end
