require_relative '../core/TwitterRequest'

class SearchGeo < TwitterRequest

  def request_name
    "GeoSearch"
  end

  def twitter_endpoint
    "/geo/search"
  end

  def url
    'https://api.twitter.com/1.1/geo/search.json'
  end

  def success(response)
    log.info("SUCCESS")
    georesults = JSON.parse(response.body)['result']['places']
    log.info("#{georesults.size} location(s) received.")
    yield georesults
  end

end
