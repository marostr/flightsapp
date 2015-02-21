module Wizzair
  module Fetchers
    class Price

      attr_accessor :params

      delegate :get_headers, :post_headers, :post_params, to: :params

      def initialize(departure_airport, destination_airport, date)
        @params = Wizzair::Params.new(departure_airport, destination_airport, date)
      end

      def call
        setup_curl
        curl_get_cookies
        curl_post_data
        parse_html
      end

      private

      def setup_curl
        ### CURL SETUP ###
        @curl = Curl::Easy.new
        @curl.enable_cookies = true
        @curl.follow_location = true
        @curl.encoding = 'utf-8'
        @curl.url = "https://wizzair.com/pl-PL/Search"
      end

      def curl_get_cookies
        ### CURL `GET` TO GET COOKIES ###
        #################################
        ##### COME TO THE DARK SIDE #####
        ######## WE HAVE COOKIES ########
        #################################
        @curl.headers = get_headers
        @curl.get
        page = ::Nokogiri::HTML(@curl.body)
      end

      def curl_post_data
        ### CURL `POST` ###
        @curl.headers = post_headers
        @curl.post(post_params)
      end

      def parse_html
        results = Wizzair::Parser.new(@curl.body).results
        Wizzair::Response.new(results)
        binding.pry
      end

    end
  end
end
