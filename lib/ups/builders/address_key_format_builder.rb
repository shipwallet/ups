require 'ox'

module UPS
  module Builders
    class AddressKeyFormatBuilder < BuilderBase
      include Ox

      attr_accessor :opts

      def initialize(opts = {})
        self.opts = opts
      end

      # Returns an XML representation of address_line
      #
      # @return [Ox::Element] XML representation of address_line address part
      def address_line
        element_with_value('AddressLine', opts[:address_line][0..34]) unless opts[:address_line].nil?
      end

      # Returns an XML representation of city
      #
      # @return [Ox::Element] XML representation of the city address part
      def city
        element_with_value('City', opts[:city][0..29]) unless opts[:city].nil?
      end

      # Returns an XML representation of postcode_primary_low
      #
      # @return [Ox::Element] XML representation of the postcode_primary_low address part
      def postcode_primary_low
        element_with_value('PostcodePrimaryLow', opts[:postcode_primary_low][0..9]) unless opts[:postcode_primary_low].nil?
      end

      # Returns an XML representation of country
      #
      # @return [Ox::Element] XML representation of the country address part
      def country
          element_with_value('CountryCode', opts[:country][0..1]) unless opts[:country].nil?
      end

      def single_line_address
        element_with_value('SingleLineAddress', opts[:single_line_address]) unless opts[:single_line_address].nil?
      end

      # Returns an XML representation of a AddressKeyFormat
      #
      # @return [Ox::Element] XML representation of the current object
      def to_xml
        Element.new('AddressKeyFormat').tap do |address|
          address << address_line unless address_line.nil?
          address << city unless city.nil?
          address << postcode_primary_low unless postcode_primary_low.nil?
          address << single_line_address unless single_line_address.nil?
          address << country unless country.nil?
        end
      end
    end
  end
end
