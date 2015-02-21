class FlightsController < ApplicationController
  expose(:flights) { current_user.flights }
  expose(:flight)
  autocomplete(:airport, :name, full: true)

  def create
    flight_factory = FlightFactory.new(current_user, departure_airport, destination_airport, date)
    flight = flight_factory.create
    if flight.save
      redirect_to flight, notice: 'Flight successfully created'
    else
      redirect_to flights_path, alert: 'Error'
    end
  end

  def refresh
    updater = FlightUpdater.new(flight)
    updater.call!
    if flight.save
      redirect_to flight, notice: 'Flight successfully updated'
    else
      redirect_to flight, warning: 'Error'
    end
  end

  private

  def departure_airport
    flight_params[:departure_airport][:name]
  end

  def destination_airport
    flight_params[:arrival_airport][:name]
  end

  def date
    "#{flight_params['departure_date(1i)']}-#{flight_params['departure_date(2i)']}-#{flight_params['departure_date(3i)']}"
  end

  def flight_params
    params[:flight]
  end
end
