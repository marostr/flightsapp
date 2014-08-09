module Flights
  class WizzResponse
    attr_accessor :departure_date, :arrival_date, :discount_price, :normal_price, :currency

    def initialize(departure_date, arrival_date, dprice, price, currency)
      @departure_date = departure_date
      @arrival_date = arrival_date
      @discount_price = dprice
      @normal_price = price
      @currency = currency
    end
  end
end
