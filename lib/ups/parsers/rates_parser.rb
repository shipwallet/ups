module UPS
  module Parsers
    class RatesParser < ParserBase
      attr_accessor :rated_shipments

      def initialize
        super
        self.rated_shipments = []
        @current_rate = {}
      end

      def start_element(name)
        super
      end

      def end_element(name)
        super
        return unless name == :RatedShipment
        rated_shipments << @current_rate.tap do |c|
          if c.key? :negotiated_rate
            c[:total] = c[:negotiated_rate]
            c.delete :negotiated_rate
          end
        end
        @current_rate = {}
      end

      def value(value)
        super
        if switch_active?(:RatedShipment, :Service, :Code)
          parse_service_code value
        elsif switch_active?(:RatedShipment, :TotalCharges, :MonetaryValue)
          parse_total_charges value
        elsif switch_active?(:RatedShipment, :TotalCharges, :CurrencyCode)
          parse_total_charges_currency_code value
        elsif switch_active?(:RatedShipment, :NegotiatedRates, :MonetaryValue)
          parse_negotiated_rate value
        elsif switch_active?(:RatedShipment, :GuaranteedDaysToDelivery)
          parse_guaranteed_days_to_delivery value
        elsif switch_active?(:RatedShipment, :ScheduledDeliveryTime)
          parse_scheduled_delivery_time value
        end
      end

      def parse_negotiated_rate(value)
        @current_rate[:negotiated_rate] = value.as_s
      end

      def parse_service_code(value)
        @current_rate[:service_code] = value.as_s
        @current_rate[:service_name] = UPS::SERVICES[value.as_s]
      end

      def parse_total_charges(value)
        @current_rate[:total] = value.as_s
      end

      def parse_total_charges_currency_code(value)
        @current_rate[:total_currency_code] = value.as_s
      end

      def parse_guaranteed_days_to_delivery(value)
        @current_rate[:guaranteed_days_to_delivery] = value.as_s
      end

      def parse_scheduled_delivery_time(value)
        @current_rate[:scheduled_delivery_time] = value.as_s
      end
    end
  end
end
