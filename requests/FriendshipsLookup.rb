require_relative '../core/TwitterRequest'

class FriendshipsLookup < TwitterRequest

  def initialize(args)
    super args
  end

  def request_name
    "FriendshipsLookup"
  end

  def twitter_endpoint
    "/friendships/lookup"
  end

  def url
    'https://api.twitter.com/1.1/friendships/lookup.json'
  end

  def escaped_params
    params
  end

  def success(response)
    log.info("SUCCESS")
    friendships = JSON.parse(response.body)
    log.info("Received information on #{friendships.size} friendship(s).")
    yield friendships
  end

end
