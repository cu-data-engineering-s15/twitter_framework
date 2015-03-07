require_relative '../core/TwitterRequest'

class StatusRetweetId < TwitterRequest

  def initialize(args)
    super args
    params[:count] = 100
  end

  def request_name
    "StatusesRetweetsId"
  end

  def twitter_endpoint
    "/statuses/retweets/:id"
  end

  def url
    "https://api.twitter.com/1.1/statuses/retweets/#{data[:id]}.json"
  end

  def success(response)
    log.info("SUCCESS")
    tweets = JSON.parse(response.body)
    log.info("#{tweets.size} retweet(s) received.")
    yield tweets
  end

end
