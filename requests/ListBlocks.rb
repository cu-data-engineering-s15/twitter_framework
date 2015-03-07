require_relative '../core/CursorRequest'

class ListBlocks < CursorRequest

  def initialize(args)
    super args
    @count = 0
  end

  def request_name
    "ListBlocks"
  end

  def twitter_endpoint
    "/blocks/list"
  end

  def url
    'https://api.twitter.com/1.1/blocks/list.json'
  end

  def success(response)
    log.info("SUCCESS")
    users = JSON.parse(response.body)['users']
    @count += users.size
    log.info("#{users.size} blocked users received.")
    log.info("#{@count} total blocked users received.")
    yield users
  end

end
