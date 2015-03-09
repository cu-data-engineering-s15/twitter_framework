require_relative '../core/CursorRequest'

class MuteIDs < CursorRequest

  def initialize(args)
    super args
    @count = 0
  end

  def request_name
    "MuteIDs"
  end

  def twitter_endpoint
    "/mutes/users/ids"
  end

  def url
    'https://api.twitter.com/1.1/mutes/users/ids.json'
  end

  def success(response)
    log.info("SUCCESS")
    mutes = JSON.parse(response.body)["ids"]
    @count += mutes.size
    log.info("#{mutes.size} mute(s) recieved.")
    log.info("#{@count} total mute(s) recieved.")
    yield mutes
  end

end
