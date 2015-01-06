module Wizzair
  module Fetchers
    class UpdateFlight < Base

      attr_accessor :flight, :origin, :destination, :date

      def initialize(flight)
        @flight = flight
        @origin = flight.departure_airport.name
        @destination = flight.arrival_airport.name
        @date = flight.departure_date.strftime('%F')
        super
      end

      def call!
        super
      end

      private

      def set_flight!
        @flight.touch
        super
      end

    end
  end
end
