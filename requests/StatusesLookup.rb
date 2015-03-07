require_relative '../core/TwitterRequest'

class StatusesLookup < TwitterRequest

  def initialize(args)
    super args
  end

  def request_name
    "StatusesLookup"
  end

  def twitter_endpoint
    "/statuses/lookup"
  end

  def url
    'https://api.twitter.com/1.1/statuses/lookup.json'
  end

  def success(response)
    log.info("SUCCESS")
    html = JSON.parse(response.body)['html']
    log.info("html received.")
    yield html
  end

  def error(response)
    if response.code == 404
      puts "No tweets found at specified id or url"
      return
    end
    super
  end

end

