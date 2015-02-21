module Wizzair
  class Response
    attr_accessor :results

    def initialize(results)
      @results = results
    end

    def body
      results
    end

    def success?
      results[:error].present?
    end

    def failure?
      !success?
    end
  end
end
