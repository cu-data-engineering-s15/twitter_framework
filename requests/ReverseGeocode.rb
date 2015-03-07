require_relative '../core/TwitterRequest'
 
class ReverseGeocode < TwitterRequest

  def initialize(args)
    super args
  end

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
    geodata = JSON.parse(response.body)
    log.info("geodata received.")
    yield geodata
  end

  def error(response)
    if response.code == 404
      puts "No location found at specified co-ordinates "
      return
    end
    super
  end

end
