require_relative '../core/TwitterRequest'

class AvailableTrends < TwitterRequest

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
    locations = JSON.parse(response.body)
    log.info("#{locations.size} location(s) received.")
    yield locations
  end

end
