require_relative '../requests/StatusesRetweetsId'

require 'trollop'

USAGE = %Q{
get_retweets: Retrieves the retweets of the tweet with the given id. 

Usage:
  ruby get_retweets.rb <options> <id>

  <id>: The numerical id of the desired Tweet.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_retweets 0.1 (c) 2015 Kenneth M. Anderson; Modified by Sheefali Tewari."
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:id] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  data   = { id: input[:id], props: input[:props] }

  args     = { params: {}, data: data }

  twitter = StatusRetweetId.new(args)

  puts "Retrieving the retweets of the tweet with this id: #{input[:id]}"

  File.open('retweets.json', 'w') do |f|
    twitter.collect do |tweets|
      tweets.each do |tweet|
        f.puts "#{tweet.to_json}\n"
      end
    end
  end

  puts "Retweets were stored in the file 'retweets.json'."
  puts "DONE."

end
