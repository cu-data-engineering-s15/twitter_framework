require_relative '../core/TwitterRequest'

class AccountSettings < TwitterRequest

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
    yield settings
  end

end
