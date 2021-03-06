module UPS
  autoload :SERVICES,              'ups/services'
  autoload :PACKAGING,             'ups/packaging'

  autoload :Version,               'ups/version'
  autoload :Connection,            'ups/connection'
  autoload :Exceptions,            'ups/exceptions'

  autoload :Data,                  'ups/data'
  module Data
    autoload :US_STATES,           'ups/data/us_states'
    autoload :CANADIAN_STATES,     'ups/data/canadian_states'
    autoload :IE_COUNTIES,         'ups/data/ie_counties'
    autoload :IE_COUNTY_PREFIXES,  'ups/data/ie_county_prefixes'
  end

  module Parsers
    autoload :ParserBase,             'ups/parsers/parser_base'
    autoload :RatesParser,            'ups/parsers/rates_parser'
    autoload :ShipConfirmParser,      'ups/parsers/ship_confirm_parser'
    autoload :ShipAcceptParser,       'ups/parsers/ship_accept_parser'
    autoload :LocatorParser,          'ups/parsers/locator_parser'
    autoload :TimeInTransitParser,    'ups/parsers/time_in_transit_parser'
    autoload :TrackingParser,         'ups/parsers/tracking_parser'
  end

  module Builders
    autoload :BuilderBase,                  'ups/builders/builder_base'
    autoload :RateBuilder,                  'ups/builders/rate_builder'
    autoload :AddressBuilder,               'ups/builders/address_builder'
    autoload :ShipConfirmBuilder,           'ups/builders/ship_confirm_builder'
    autoload :ShipAcceptBuilder,            'ups/builders/ship_accept_builder'
    autoload :OrganisationBuilder,          'ups/builders/organisation_builder'
    autoload :ShipperBuilder,               'ups/builders/shipper_builder'
    autoload :LocatorBuilder,               'ups/builders/locator_builder'
    autoload :AddressKeyFormatBuilder,      'ups/builders/address_key_format_builder'
    autoload :AddressArtifactFormatBuilder, 'ups/builders/address_artifact_format_builder'
    autoload :TimeInTransitBuilder,         'ups/builders/time_in_transit_builder'
    autoload :TrackingBuilder,              'ups/builders/tracking_builder'
    autoload :GeocodeBuilder,               'ups/builders/geocode_builder'
  end
end
