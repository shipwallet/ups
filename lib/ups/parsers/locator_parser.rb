module UPS
  module Parsers
    class LocatorParser < ParserBase

      attr_accessor :locations

      def initialize
        super
        self.locations = []
        @current_location = location_hash
      end

      def start_element(name)
        super
      end

      def end_element(name)
        super
        return unless name == :DropLocation
        self.locations << @current_location
        @current_location = location_hash
      end

      def value(value)
        super
        if switch_active?(:LocationID)
          @current_location[:location_id] = value.as_s
        elsif switch_active?(:Geocode, :Latitude)
          @current_location[:geo_code][:latitude] = value.as_s
        elsif switch_active?(:Geocode, :Longitude)
          @current_location[:geo_code][:longitude] = value.as_s
        elsif switch_active?(:AddressKeyFormat, :ConsigneeName)
          @current_location[:address_key_format][:consignee_name] = value.as_s
        elsif switch_active?(:AddressKeyFormat, :AddressLine)
          @current_location[:address_key_format][:address_line] = value.as_s
        elsif switch_active?(:AddressKeyFormat, :PostcodePrimaryLow)
          @current_location[:address_key_format][:postcode_primary_low] = value.as_s
        elsif switch_active?(:AddressKeyFormat, :CountryCode)
          @current_location[:address_key_format][:country_code] = value.as_s
        elsif switch_active?(:StandardHoursOfOperation)
          @current_location[:standard_hours_of_operation] = value.as_s
        elsif switch_active?(:NonStandardHoursOfOperation)
          @current_location[:non_standard_hours_of_operation] = value.as_s
        elsif switch_active?(:PoliticalDivision1)
          @current_location[:address_key_format][:political_division_1] = value.as_s
        elsif switch_active?(:PoliticalDivision2)
          @current_location[:address_key_format][:political_division_2] = value.as_s
        elsif switch_active?(:PoliticalDivision3)
          @current_location[:address_key_format][:political_division_3] = value.as_s
        end
      end

      private

      def location_hash
        {geo_code: {}, address_key_format: {}}
      end
    end
  end
end
