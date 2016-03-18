module UPS
  module Builders
    class TrackingBuilder < BuilderBase
      def initialize
        super 'TrackRequest'

        self.document.nodes.insert 2,Instruct.new('xml version=\'1.0\'')
        add_request('Track', '1')

      end

      def add_tracking_number(tracking_number)
        self.root << element_with_value('TrackingNumber', tracking_number)
      end
    end
  end
end
