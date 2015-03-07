require_relative '../core/TwitterRequest'

class StatusesLookup < TwitterRequest

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
    tweets = JSON.parse(response.body)
    log.info("#{tweets.size} tweet(s) received.")
    yield tweets
  end

end

