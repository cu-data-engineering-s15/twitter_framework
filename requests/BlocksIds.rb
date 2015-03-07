require_relative '../core/CursorRequest'

class BlockIds < CursorRequest
  
  def initialize(args)
    super args
    @count=0
  end
  
  def request_name
    "BlocksId"
  end
  
  def twitter_endpoint
    "/blocks/ids"
  end
  
  def url
    'https://api.twitter.com/1.1/blocks/ids.json'
  end
  
  def success(response)
    log.info("SUCCESS")
    ids = JSON.parse(response.body)['ids']
    @count += ids.size
    log.info("#{ids.size} ids received.")
    log.info("#{@count} total ids received.")
    yield ids
  end
  
end
