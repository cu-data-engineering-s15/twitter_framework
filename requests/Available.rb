require_relative '../core/TwitterRequest'

class Available < TwitterRequest

  def initialize(args)
    super args
  end

  def request_name
    "AvailableTrends"
  end

  def twitter_endpoint
    "/trends/available"
  end

  def url
    'https://api.twitter.com/1.1/trends/available.json'
  end

  def success(response)
    log.info("SUCCESS")
    trendss = JSON.parse(response.body)
    log.info("Trends data received")
    yield trendss
  end

  def error(response)
    if response.code == 404
      puts "No trending topic information for this Where On Earth ID."
      return
    end
    super
  end

end