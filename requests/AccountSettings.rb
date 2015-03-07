require_relative '../core/TwitterRequest'

class AccountSettings < TwitterRequest

  def initialize(args)
    super args
  end

  def request_name
    "AccountSettings"
  end

  def twitter_endpoint
    "/account/settings"
  end

  def url
    'https://api.twitter.com/1.1/account/settings.json'
  end

  def success(response)
    log.info("SUCCESS")
    settings = JSON.parse(response.body)
    log.info("#{settings}")
    yield settings
  end

end