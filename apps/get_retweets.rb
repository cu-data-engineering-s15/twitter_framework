require_relative '../requests/StatusRetweetId'

require 'trollop'

USAGE = %Q{
get_retweets: Retrieves ids for retweets, specified by the id parameter. 

Usage:
  ruby get_statusesId.rb <options> <Id>

  <Id>: The numerical ID of the desired Tweet.

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

  opts[:Id] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { Id: input[:Id] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = StatusRetweetId.new(args)

  puts "Retrieves a retweeted tweet, specified by the id parameter.'#{input[:Id]}'"

  twitter.collect do |data|
  puts data

end

  puts "DONE."

end