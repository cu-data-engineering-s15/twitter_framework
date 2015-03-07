require_relative '../core/TwitterRequest'

class ShowStatusId < TwitterRequest

  def request_name
    "ShowStatusId"
  end

  def twitter_endpoint
    "/statuses/show/:id"
  end

  def url
    'https://api.twitter.com/1.1/statuses/show.json'
  end

  def success(response)
    log.info("SUCCESS")
    tweet = JSON.parse(response.body)
    yield tweet
  end

end
