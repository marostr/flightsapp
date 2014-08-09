module Flights
  class Wizzair
    attr_accessor :response

    def initialize(flight, origin = nil, destination = nil, date = nil)
      @flight = flight
      if @flight.new_record?
        @origin = origin
        @destination = destination
        @date = date
      else
        @origin = @flight.departure_airport.name
        @destination = @flight.arrival_airport.name
        @date = @flight.departure_date.strftime("%F")
      end

      create_params
      create_get_headers
      create_post_headers
      setup_curl
    end

    def commence!
      curl_get_cookies
      curl_post_data
      parse_html
      find_or_create_airports! if @flight.new_record?
      set_price!
      set_flight!
    end

    private

    def set_flight!
      if @flight.new_record?
        @flight.departure_airport = @origin
        @flight.arrival_airport = @destination
      else
        @flight.touch
      end
      @flight.departure_date = @response.departure_date
      @flight.arrival_date = @response.arrival_date
      @flight.prices << @price
    end

    def set_price!
      if price = @flight.prices.last
        if price.normal.eql?(@response.normal_price) && price.discount.eql?(@response.discount_price)
          price.touch
        else
          price = nil
        end
      end

      @price = price || Price.create(normal: @response.normal_price, discount: @response.discount_price, currency: @response.currency)
    end

    def find_or_create_airports!
      @origin = Airport.where(name: @origin.upcase).first_or_create
      @destination = Airport.where(name: @destination.upcase).first_or_create
    end

    def create_params
      ### SET POST PARAMS ###
      data_hash = {"ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$OriginStation"=> @origin,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$DestinationStation"=> @destination,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$DepartureDate"=> @date,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$PaxCountADT"=>1,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$PaxCountCHD"=>0,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$PaxCountINFANT"=>0,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$ButtonSubmit"=>"Szukaj",
        "__EVENTTARGET" => "ControlGroupRibbonAnonHomeView_AvailabilitySearchInputRibbonAnonHomeView_ButtonSubmit",
        "cookiePolicyDismissed" => true,
        "__VIEWSTATE" => "/wEPDwUBMGQYAQUeX19Db250cm9sc1JlcXVpcmVQb3N0QmFja0tleV9fFgEFWkNvbnRyb2xHcm91cFJpYmJvbkFub25Ib21lVmlldyRBdmFpbGFiaWxpdHlTZWFyY2hJbnB1dFJpYmJvbkFub25Ib21lVmlldyRTdHVkZXRTZW5pb3JHcm91cLcMW6Bfdi6XQ3jIOh46M/Uyyf+xnV2YpSj4opm7Zf8k" }

      ### CONVERT HASH TO POST FIELDS ###
      @data = data_hash.inject([]){ |new, old| new << Curl::PostField.content(old[0], old[1]) }
    end

    def create_get_headers
      ### HEADERS FOR `GET` REQUEST ###
      @get_headers = { "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Encoding"=>"gzip,deflate,sdch",
        "Accept-Language"=>"pl,en;q=0.8",
        "Connection"=>"keep-alive",
        "DNT"=>1,
        "Referer" => "http://wizzair.com/pl-PL/Search",
        "User-Agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
        "Host"=>"wizzair.com"}
    end

    def create_post_headers
      ### HEADERS FOR `POST` REQUEST ###
      @post_headers = {
       "Cache-Control" => "max-age=0",
       "Content-Type" => "application/x-www-form-urlencoded",
       "Origin" => "http://wizzair.com" }
      @post_headers.merge!(@get_headers)
    end

    def setup_curl
      ### CURL SETUP ###
      @c = Curl::Easy.new
      @c.enable_cookies = true
      @c.follow_location = true
      @c.encoding = 'utf-8'
      @c.url = "http://wizzair.com/pl-PL/Search"
    end

    def curl_get_cookies
      ### CURL `GET` TO GET COOKIES ###
      ### COOOOKIES?! WHO HAVE COOOOKIES?! ####
      @c.headers = @get_headers
      @c.get
    end

    def curl_post_data
      ### CURL `POST` ###
      @c.headers = @post_headers
      @c.post(@data)
    end

    def parse_html
      ### NOKOGIRI BJACZ ###
      page = ::Nokogiri::HTML(@c.body)

      ### PARSE HTML ###
      content = page.css('.flight-day-container')

      flight = content.first
      dates = flight.search('.flight-date').first.attributes
      departure = dates['data-flight-departure'].value.split("T").join(" ")
      arrival = dates['data-flight-arrival'].value.split("T").join(" ")
      dprice = flight.search('.price')[1].child.content
      price = flight.search('.price')[3].child.content
      currency = price.split(" ")[1]
      @response = Flights::WizzResponse.new(departure, arrival, dprice.to_f, price.to_f, currency)
    end
  end
end
