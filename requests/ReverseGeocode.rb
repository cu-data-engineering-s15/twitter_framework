require_relative '../core/TwitterRequest'
 
class ReverseGeocode < TwitterRequest

  def request_name
    "ReverseGeocode"
  end

  def twitter_endpoint
    "/geo/reverse_geocode"
  end

  def url
    'https://api.twitter.com/1.1/geo/reverse_geocode.json'
  end

  def success(response)
    log.info("SUCCESS")
    geodata = JSON.parse(response.body)['result']['places']
    log.info("#{geodata.size} location(s) received.")
    yield geodata
  end

end
