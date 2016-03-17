require 'uri'
require 'typhoeus'
require 'digest/md5'
require 'ox'

module UPS
  # The {Connection} class acts as the main entry point to performing rate and
  # ship operations against the UPS API.
  #
  # @author Paul Trippett
  # @abstract
  # @since 0.1.0
  # @attr [String] url The base url to use either TEST_URL or LIVE_URL
  class Connection
    attr_accessor :url

    TEST_URL = 'https://wwwcie.ups.com'
    LIVE_URL = 'https://onlinetools.ups.com'

    RATE_PATH = '/ups.app/xml/Rate'
    SHIP_CONFIRM_PATH = '/ups.app/xml/ShipConfirm'
    SHIP_ACCEPT_PATH = '/ups.app/xml/ShipAccept'
    ADDRESS_PATH = '/ups.app/xml/XAV'
    LOCATOR_PATH = '/ups.app/xml/Locator'
    TIME_IN_TRANSIT_PATH = '/ups.app/xml/TimeInTransit'
    TRACKING_PATH = '/ups.app/xml/Track'

    DEFAULT_PARAMS = {
      test_mode: false
    }

    # Initializes a new {Connection} object
    #
    # @param [Hash] params The initialization options
    # @option params [Boolean] :test_mode If TEST_URL should be used for
    #   requests to the UPS URL
    def initialize(params = {})
      params = DEFAULT_PARAMS.merge(params)
      self.url = (params[:test_mode]) ? TEST_URL : LIVE_URL
    end

    # Makes a request to fetch Rates for a shipment.
    #
    # A pre-configured {Builders::RateBuilder} object can be passed as the first
    # option or a block yielded to configure a new {Builders::RateBuilder}
    # object.
    #
    # @param [Builders::RateBuilder] rate_builder A pre-configured
    #   {Builders::RateBuilder} object to use
    # @yield [rate_builder] A RateBuilder object for configuring
    #   the shipment information sent
    def rates(rate_builder = nil)
      if rate_builder.nil? && block_given?
        rate_builder = UPS::Builders::RateBuilder.new
        yield rate_builder
      end

      puts rate_builder.to_xml


      response = get_response_stream RATE_PATH, rate_builder.to_xml
      UPS::Parsers::RatesParser.new.tap do |parser|
        Ox.sax_parse(parser, response)
      end
    end

    # Makes a request to ship a package
    #
    # A pre-configured {Builders::ShipConfirmBuilder} object can be passed as
    # the first option or a block yielded to configure a new
    # {Builders::ShipConfirmBuilder} object.
    #
    # @param [Builders::ShipConfirmBuilder] confirm_builder A pre-configured
    #   {Builders::ShipConfirmBuilder} object to use
    # @yield [ship_confirm_builder] A ShipConfirmBuilder object for configuring
    #   the shipment information sent
    def ship(confirm_builder = nil)
      if confirm_builder.nil? && block_given?
        confirm_builder = Builders::ShipConfirmBuilder.new
        yield confirm_builder
      end

      confirm_response = make_confirm_request(confirm_builder)
      return confirm_response unless confirm_response.success?

      accept_builder = build_accept_request_from_confirm(confirm_builder,
                                                         confirm_response)
      make_accept_request accept_builder
    end

    # Makes a request to locate UPS locations
    #
    # A pre-configured {Builders::LocatorBuilder} object can be passed as
    # the first option or a block yielded to configure a new
    # {Builders::LocatorBuilder} object.
    #
    # @param [Builders::LocatorBuilder] locator_builder A pre-configured
    #   {Builders::LocatorBuilder} object to use
    # @yield [locator_builder] A LocatorBuilder object for configuring
    #   the location information sent
    def locator(locator_builder = nil)
      if locator_builder.nil? && block_given?
        locator_builder = Builders::LocatorBuilder.new
        yield locator_builder
      end

#      puts locator_builder.to_xml

      response = get_response_stream LOCATOR_PATH, locator_builder.to_xml
      UPS::Parsers::LocatorParser.new.tap do |parser|
        Ox.sax_parse(parser, response)
      end
    end

    # Makes a request for delivery times
    #
    # A pre-configured {Builders::TimeInTransitBuilder} object can be passed as
    # the first option or a block yielded to configure a new
    # {Builders::TimeInTransitBuilder} object.
    #
    # @param [Builders::TimeInTransitBuilder] time_in_transit_builder A pre-configured
    #   {Builders::TimeInTransitBuilder} object to use
    # @yield [time_in_transit_builder] A TimeInTransitBuilder object for configuring
    #   the transit information sent
    def time_in_transit(time_in_transit_builder = nil)
      if time_in_transit_builder.nil? && block_given?
        time_in_transit_builder = Builders::TimeInTransitBuilder.new
        yield time_in_transit_builder
      end

      puts time_in_transit_builder.to_xml

      response = get_response_stream TIME_IN_TRANSIT_PATH, time_in_transit_builder.to_xml
      UPS::Parsers::TimeInTransitParser.new.tap do |parser|
        Ox::sax_parse(parser, response)
      end
    end

    # Makes a request for tracking data
    #
    # A pre-configured {Builders::TrackingBuilder} object can be passed as
    # the first option or a block yielded to configure a new
    # {Builders::TrackingBuilder} object.
    #
    # @param [Builders::TrackingBuilder] tracking_builder A pre-configured
    #   {Builders::TrackingBuilder} object to use
    # @yield [time_in_transit_builder] A TrackingBuilder object for configuring
    #   the tracking information sent
    def tracking(tracking_builder = nil)
      if tracking_builder.nil? && block_given?
        tracking_builder = Builders::TrackingBuilder.new
        yield tracking_builder
      end

      puts tracking_builder.to_xml

      response = get_response_stream TRACKING_PATH, tracking_builder.to_xml
      UPS::Parsers::TrackingParser.new.tap do |parser|
        Ox::sax_parse(parser, response)
      end
    end

    private

    def build_url(path)
      "#{url}#{path}"
    end

    def get_response_stream(path, body)
      response = Typhoeus.post(build_url(path), body: body)
      puts response.body
      StringIO.new(response.body)
    end

    def make_confirm_request(confirm_builder)
      make_ship_request confirm_builder,
                        SHIP_CONFIRM_PATH,
                        Parsers::ShipConfirmParser.new
    end

    def make_accept_request(accept_builder)
      make_ship_request accept_builder,
                        SHIP_ACCEPT_PATH,
                        Parsers::ShipAcceptParser.new
    end

    def make_ship_request(builder, path, ship_parser)
      response = get_response_stream path, builder.to_xml
      ship_parser.tap do |parser|
        Ox.sax_parse(parser, response)
      end
    end

    def build_accept_request_from_confirm(confirm_builder, confirm_response)
      UPS::Builders::ShipAcceptBuilder.new.tap do |builder|
        builder.add_access_request confirm_builder.license_number,
                                   confirm_builder.user_id,
                                   confirm_builder.password
        builder.add_shipment_digest confirm_response.shipment_digest
      end
    end
  end
end
