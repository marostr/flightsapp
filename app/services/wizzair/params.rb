module Wizzair
  class Params

    attr_reader :departure, :destination, :date

    def initialize(departure, destination, date)
      @departure = departure
      @destination = destination
      @date = date
    end

    def post_params
      ### SET POST PARAMS ###
      data_hash ||= {"ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$OriginStation"=> departure,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$DestinationStation"=> destination,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$DepartureDate"=> date,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$PaxCountADT"=>1,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$PaxCountCHD"=>0,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$PaxCountINFANT"=>0,
        "ControlGroupRibbonAnonHomeView$AvailabilitySearchInputRibbonAnonHomeView$ButtonSubmit"=>"Szukaj",
        "__EVENTTARGET" => "ControlGroupRibbonAnonHomeView_AvailabilitySearchInputRibbonAnonHomeView_ButtonSubmit",
        "cookiePolicyDismissed" => true,
        'pageToken' => '',
        "__VIEWSTATE" => "/wEPDwUBMGQYAQUeX19Db250cm9sc1JlcXVpcmVQb3N0QmFja0tleV9fFgEFWkNvbnRyb2xHcm91cFJpYmJvbkFub25Ib21lVmlldyRBdmFpbGFiaWxpdHlTZWFyY2hJbnB1dFJpYmJvbkFub25Ib21lVmlldyRTdHVkZXRTZW5pb3JHcm91cLcMW6Bfdi6XQ3jIOh46M/Uyyf+xnV2YpSj4opm7Zf8k" }

      ### CONVERT HASH TO POST FIELDS ###
      @data ||= data_hash.inject([]){ |new, old| new << Curl::PostField.content(old[0], old[1]) }
    end

    def get_headers
      ### HEADERS FOR `GET` REQUEST ###
      @get_headers ||= { "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Encoding"=>"gzip,deflate,sdch",
        "Accept-Language"=>"pl,en;q=0.8",
        "Connection"=>"keep-alive",
        "DNT"=>1,
        "Referer" => "https://wizzair.com/pl-PL/Search",
        "User-Agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36",
        "Host"=>"wizzair.com"}
    end

    def post_headers
      ### HEADERS FOR `POST` REQUEST ###
      @post_headers ||= {
       "Cache-Control" => "max-age=0",
       "Content-Type" => "application/x-www-form-urlencoded",
       "Origin" => "https://wizzair.com" }
      @post_headers.merge!(get_headers)
    end
  end
end
