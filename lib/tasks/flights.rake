require 'open-uri'

namespace :flights do
  desc "SEED WIZZ AIRPORTS FROM WEB"
  task seed_wizz_airports: :environment do
    map = Nokogiri::XML(open('https://cdn.wizzair.com/en-GB/Map.ashx'))
    create_airports(map)
    map.at_css('list').children.each do |city|
      next unless city.at_css('iata')
      name = city.at_css('iata').content.strip
      full_name = city.at_css('name').content.strip
      airport = Airport.find_or_create_by(name: name, full_name: full_name, airline: Airline.first)
      connections = city.css('connected').css('city')
      connections.each do |connection|
        name = connection.at_css('iata').content.strip
        a = Airport.find_or_create_by(name: name, airline: Airline.first)
        a.connected_airports << airport
        airport.connected_airports << a
      end
    end
  end

  private

  def create_airports(map)
    map.at_css('list').children.each do |city|
      next unless city.at_css('iata')
      name = city.at_css('iata').content.strip
      full_name = city.at_css('name').content.strip
      Airport.find_or_create_by(name: name, full_name: full_name, airline: Airline.first)
    end
  end
end
