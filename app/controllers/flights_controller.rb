class FlightsController < ApplicationController
  expose(:flights) { current_user.flights }
  expose(:flight)
  autocomplete(:airport, :name, full: true)

  def create
    flight = Flight.new
    flight.user = current_user
    fetcher = Wizzair::Fetchers::NewFlight.new(flight, departure_airport_name, arrival_airport_name, departure_date)
    fetcher.call!
    if flight.save
      redirect_to flight, notice: "Flight successfully created."
    else
      render 'new'
    end
  end

  def refresh
    fetcher = Wizzair::Fetcher::UpdateFlight.new(flight)
    fetcher.call!
    if flight.save
      redirect_to flight, notice: "Flight successfully updated."
    else
      redirect_to flight, warning: "Error."
    end
  end

  private

  def departure_airport_name
    flight_params[:departure_airport][:name]
  end

  def arrival_airport_name
    flight_params[:arrival_airport][:name]
  end

  def departure_date
    "#{flight_params['departure_date(1i)']}-#{flight_params['departure_date(2i)']}-#{flight_params['departure_date(3i)']}"
  end

  def flight_params
    params[:flight]
  end
end
