module UPS
  module Builders
    class LocatorBuilder < BuilderBase

      attr_accessor :location_search_criteria_root, :translate_root, :unit_of_measurement_root

      # Initializes a new {LocatorBuilder} object
      #
      def initialize()
        super 'LocatorRequest'

        self.document.nodes.insert 2,Instruct.new('xml version=\'1.0\'')
        add_request('Locator', '1')

        self.translate_root = Element.new('Translate')
        root << self.translate_root

        self.unit_of_measurement_root = Element.new('UnitOfMeasurement')
        root << self.unit_of_measurement_root

        self.location_search_criteria_root = Element.new('LocationSearchCriteria')
        root << self.location_search_criteria_root
      end

      # Adds an OriginAddress section to the XML document being built
      #
      # @param [Hash] opts The Address Parts
      # @option opts [String] :address_line_1 Address Line 1
      # @option opts [String] :city City
      # @option opts [String] :state State
      # @option opts [String] :postal_code Zip or Postal Code
      # @option opts [String] :country Country
      # @raise [InvalidAttributeError] If the passed :state is nil or an empty string and the :country is IE
      # @return [void]
      def add_origin_address(opts = {})
        root << Element.new('OriginAddress').tap do |elem|
          elem << AddressKeyFormatBuilder.new(opts).to_xml
        end
      end

      # Adds an SearchOption item to the XML document beeing built
      #
      # @param type [String] The option type code
      # @param codes [Array] An array of option codes
      # @raise [InvalidAttributeError] If type or any of the values in codes does not implement to_str
      # @return [void]
      def add_search_option(type: , codes: )
        fail InvalidAttributeError, type unless type.respond_to?(:to_str)
        fail InvalidAttributeError, codes unless codes.map{|c| c.respond_to?(:to_str)}.reduce(:&)

        self.location_search_criteria_root << Element.new('SearchOption').tap do |option|
          option << Element.new('OptionType').tap{|t| puts "adding #{type}"; t << element_with_value("Code",type)}
          codes.each do |code|
            option << Element.new('OptionCode').tap{|c| c << element_with_value('Code',code)}
          end
        end
      end

      # Adds a LanguageCode section to the Translate node of the XML document beeing built
      #
      # @param code [String] the language code
      # @return [void]
      def add_translate_language_code(code)
        self.translate_root << element_with_value('LanguageCode', code)
      end

      # Adds a Code section to the UnitOfMeasurement node of the XML document beeing built
      #
      # @param unit [String] the unit code
      # @return [void]
      def add_unit_of_measurement(unit)
        self.unit_of_measurement_root << element_with_value('Code', unit)
      end
    end
  end
end
