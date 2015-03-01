require_relative '../core/CursorRequest'

class FriendshipLookup
	
	def initialize(args)
		super args
		params[:count] = 500
		@count = 0
	end

	def request_name
		"FriendshipLookup"
	end

	def twitter_endpoint
		"/friendship/lookup"
	end

	def url
		'https://api.twitter.com/1.1/friendships/lookup.json'
	end

	def success(response)
		log.info("SUCCESS")
		friendships = JSON.parse(response.body)
		@count += friendships.size
		log.info("#{friendships.size} new friendships received.")
		log.info("#{count} total friendships received.")
		yield friendships
		endf
end