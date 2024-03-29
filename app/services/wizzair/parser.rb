module Wizzair
  class Parser

    attr_accessor :html_body

    def initialize(body)
      @html_body = ::Nokogiri::HTML(body)
    end

    def results
      begin
        {
          departure_airport: departure_airport,
          departure_date: departure_date,
          destination_airport: destination_airport,
          arrival_date: arrival_date,
          price: price,
          discount_price: discount_price,
          currency: currency
        }
      rescue
        {
          error: 'Flight not found'
        }
      end
    end

    private

    def flight
      @flight ||= html_body.css('.flight-day-container').first
    end

    def dates
      @dates ||= flight.search('.flight-date').first.attributes
    end

    def departure_airport
      @departure_airport ||= html_body.css('.city-from').first[:value]
    end

    def departure_date
      @departure_date ||= dates['data-flight-departure'].value.split("T").join(" ")
    end

    def destination_airport
      @destination_airport ||= html_body.css('.city-to').first[:value]
    end

    def arrival_date
      @arrival_date ||= dates['data-flight-arrival'].value.split("T").join(" ")
    end

    def full_price
      @full_price ||= flight.search('.price')[3].child.content.delete("'\xC2\xA0'")
    end

    def price
      @price ||= full_price.split(' ').first
    end

    def discount_price
      @discount_price ||= flight.search('.price')[1].child.content
    end

    def currency
      @currency ||= full_price.split(' ').last
    end

  end
end
