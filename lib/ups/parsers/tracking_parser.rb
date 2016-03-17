module UPS
  module Parsers
    class TrackingParser < ParserBase
      attr_accessor :activities

      def initialize
        super

        self.activities = []
      end

      def start_element(name)
        super
        @current_activity = tracking_hash if name == :Activity
      end

      def end_element(name)
        super
        return unless name == :Activity
        self.activities << @current_activity
        @current_activity = nil
      end

      def value(value)
        super
        if switch_active?(:ActivityLocation, :Address, :City)
          @current_activity[:activity_location][:address][:city] = value.as_s
        elsif switch_active?(:ActivityLocation, :Address, :StateProvinceCode)
          @current_activity[:activity_location][:address][:state_province_code] = value.as_s
        elsif switch_active?(:ActivityLocation, :Address, :CountryCode)
          @current_activity[:activity_location][:address][:country_code] = value.as_s
        elsif switch_active?(:ActivityLocation, :Code)
          @current_activity[:activity_location][:code] = value.as_s
        elsif switch_active?(:ActivityLocation, :Description)
          @current_activity[:activity_location][:description] = value.as_s
        elsif switch_active?(:Activity, :Status, :StatusType, :Code)
          @current_activity[:status][:type][:code] = value.as_s
        elsif switch_active?(:Activity, :Status, :StatusType, :Description)
          @current_activity[:status][:type][:description] = value.as_s
        elsif switch_active?(:Activity, :Status, :StatusCode, :Code)
          @current_activity[:status][:code][:code] = value.as_s
        elsif switch_active?(:Activity, :Status, :StatusCode, :Description)
          @current_activity[:status][:code][:description] = value.as_s
        elsif switch_active?(:Activity, :Date)
          @current_activity[:date] = value.as_s
        elsif switch_active?(:Activity, :Time)
          @current_activity[:time] = value.as_s
        end
      end

      def tracking_hash
        {
          activity_location: {
            address: {}
          },
          status: {
            type: {},
            code: {}
          }
        }
      end
    end
  end
end
