require_relative '../core/TwitterRequest'

class TrendsClosest < TwitterRequest

  def initialize(args)
    super args
    @count = 0

  end

  def request_name
    "ClosestTrends"
  end

  def twitter_endpoint
    "/trends/closest"
  end

  def url
    'https://api.twitter.com/1.1/trends/closest.json'
  end

  def success(response)
    log.info("SUCCESS")
    locations = [JSON.parse(response.body)[0]['woeid'], JSON.parse(response.body)[0]['name']]
    @count += 1
    log.info("#{@count} location(s) received.")
    yield locations
  end

  def error(response)
    if response.code == 404
      puts "No closest WOEID for trending topic information corresponding to
      this latitude and longitude."
      return
    end
    super
  end

end


