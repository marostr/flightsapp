class FlightsController < ApplicationController
  expose(:flights) { current_user.flights }
  expose(:flight)

  def index
  end

  def show
  end
end
