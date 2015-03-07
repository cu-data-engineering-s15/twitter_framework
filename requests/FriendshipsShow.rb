require_relative '../core/TwitterRequest'

class FriendshipsShow < TwitterRequest

  def initialize(args)
    super args
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
    relationship = JSON.parse(response.body)['relationship']
    yield relationship
  end

end
