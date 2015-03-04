require_relative '../requests/Timeline'

require 'trollop'

USAGE = %Q{
get_home_tweets: Retrieve tweets for the current authenticating user.

Usage:
  ruby get_home_tweets.rb <options>

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_home_tweets 0.1 (c) 2015 Kenneth M. Anderson, Dan Bye"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:screen_name] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { screen_name: input[:screen_name] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = HomeTimeline.new(args)

  puts "Collecting up to 3200 most recent tweets for current user."

  File.open('tweets.json', 'w') do |f|
    twitter.collect do |tweets|
      tweets.each do |tweet|
        f.puts "#{tweet.to_json}\n"
      end
    end
  end

  puts "DONE."

end
