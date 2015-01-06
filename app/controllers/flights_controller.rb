class FlightsController < ApplicationController
  expose(:flights) { current_user.flights }
  expose(:flight)
  autocomplete(:airport, :name, full: true)

  def create
    flight = Flight.new
    flight.user = current_user
    departure_date = "#{params[:flight]['departure_date(1i)']}-#{params[:flight]['departure_date(2i)']}-#{params[:flight]['departure_date(3i)']}"
    fetcher = Wizzair::Fetcher.new(flight, params[:flight][:departure_airport][:name], params[:flight][:arrival_airport][:name], departure_date).fetcher
    fetcher.call!
    if flight.save
      redirect_to flight, notice: "Flight successfully created."
    else
      render 'new'
    end
  end

  def refresh
    fetcher = Wizzair::Fetcher.new(flight).fetcher
    fetcher.call!
    if flight.save
      redirect_to flight, notice: "Flight successfully updated."
    else
      redirect_to flight, warning: "Error."
    end
  end
end
