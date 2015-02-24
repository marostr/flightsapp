class PriceObserver < ActiveRecord::Observer
  observe :price

  def before_create(price)
    @price = price
    create_notification if price_changed?
  end

  private

  def price_changed?
    @flight = @price.flight
    return if @flight.prices.count == 0
    @flight.current_price.normal != @price.normal
  end

  def create_notification
    Notification.create(body: 'Price has changed', flight: @flight)
  end

end
