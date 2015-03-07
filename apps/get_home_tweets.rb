require_relative '../requests/HomeTimeline'

require 'trollop'

USAGE = %Q{
get_home_tweets: Retrieve tweets from the current user's home timeline.

Usage:
  ruby get_home_tweets.rb <options>

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_home_tweets 0.1 (c) 2015 Kenneth M. Anderson, alterations (c) 2015 Dan Bye"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line

  data   = { props: input[:props] }
  args   = { params: {}, data: data }

  twitter = HomeTimeline.new(args)

  puts "Collecting tweets on home timeline for current user."

  File.open('home_tweets.json', 'w') do |f|
    twitter.collect do |tweets|
      tweets.each do |tweet|
        f.puts "#{tweet.to_json}\n"
      end
    end
  end

  puts "Tweets stored in the file 'home_tweets.json'."
  puts "DONE."

end
