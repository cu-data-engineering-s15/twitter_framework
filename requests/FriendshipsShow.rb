require_relative ##what to write here

class FriendshipsShow < ##what to write here

  def initialize(args)
    super args
    ##what to write here
  end

  def request_name
    "FriendshipsShow"
  end

  def twitter_endpoint
    "/friendships/show"
  end

  def url
    'https://api.twitter.com/1.1/friendships/show.json'
  end

  def success(response)
    log.info("SUCCESS")
    ##what to write here
  end

end
