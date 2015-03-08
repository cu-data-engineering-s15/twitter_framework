require_relative '../core/TwitterRequest'

class UsersProfileBanner < TwitterRequest

  def request_name
    "UsersProfileBanner"
  end

  def twitter_endpoint
    "/users/profile_banner"
  end

  def url
    'https://api.twitter.com/1.1/users/profile_banner.json'
  end

  def success(response)
    log.info("SUCCESS")
    sizes = JSON.parse(response.body)["sizes"]
    log.info("#{sizes.count} size(s) received.")
    yield sizes
  end

  def error(response)
    if response.code == 404
      puts "No profile banner information found"
      return
    end
    super
  end

end
