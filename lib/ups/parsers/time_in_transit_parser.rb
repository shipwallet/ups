module UPS
  module Parsers
    class TimeInTransitParser < ParserBase
      attr_accessor :service_summaries

      def initialize
        super
        self.service_summaries = []
        @current_service_summary = {}
      end

      def end_element(name)
          super
          return unless name == :ServiceSummary
          self.service_summaries << @current_service_summary
          @current_service_summary = {}
      end

      def value(value)
        super
        if switch_active?(:ServiceSummary, :Service, :Code)
          @current_service_summary[:ServiceCode] = value.as_s
        elsif switch_active?(:ServiceSummary, :Service, :Description)
          @current_service_summary[:ServiceDescription] = value.as_s
        elsif switch_active?(:EstimatedArrival, :BusinessTransitDays)
          @current_service_summary[:BusinessTransitDays] = value.as_s
        elsif switch_active?(:EstimatedArrival, :TotalTransitDays)
          @current_service_summary[:TotalTransitDays] = value.as_s
        elsif switch_active?(:EstimatedArrival, :Date)
          @current_service_summary[:EstimatedArrivalDate] = value.as_s
        elsif switch_active?(:EstimatedArrival, :DayOfWeek)
          @current_service_summary[:EstimatedArrivalDayOfWeek] = value.as_s
        end
      end
    end
  end
end
