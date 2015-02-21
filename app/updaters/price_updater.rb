class PriceUpdater

  attr_accessor :flight, :price, :currency, :last_price

  def initialize(flight, price, currency)
    @flight = flight
    @price = price
    @currency = currency
    @last_price = flight.prices.last
  end

  def call!
    if last_price.present?
      update_price
    else
      create_price
    end
  end

  private

  def create_price
    Price.create(normal: price, currency: currency, flight: flight)
  end

  def update_price(last_price)
    if last_price.normal.eql?(price)
      price.touch
    else
      create_price
    end
  end
end
