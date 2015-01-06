module Wizzair
  module Fetchers
    class NewFlight < Base

      attr_accessor :flight, :origin, :destination, :date

      def initialize(flight, origin, destination, date)
        @flight = flight
        @origin = origin
        @destination = destination
        @date = date
        super
        find_or_create_airports!
      end

      private

      def find_or_create_airports!
        @origin = Airport.where(name: @origin.upcase).first_or_create
        @destination = Airport.where(name: @destination.upcase).first_or_create
      end

      def set_flight!
        @flight.departure_airport = @origin
        @flight.arrival_airport = @destination
        super
      end

    end
  end
end
