require_relative '../core/CursorRequest'

class ListBlocks < CursorRequest

  def initialize(args)
    super args
    params[:count] = 5000
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
    ids = JSON.parse(response.body)["users"].map { |user| user["id"] }
    @count += ids.size
    log.info("#{ids.size} ids received.")
    log.info("#{@count} total ids received.")
    yield ids
  end

end
