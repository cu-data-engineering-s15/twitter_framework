require_relative '../requests/statusesShowId'

require 'trollop'

USAGE = %Q{
get_status_ids: Returns a single Tweet, specified by the id parameter. The Tweet’s author will also be embedded within the tweet.

Usage:
  ruby get_statusesId.rb <options> <Id>

  <Id>: The numerical ID of the desired Tweet.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_status_ids 0.1 (c) 2015 Kenneth M. Anderson"
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

  twitter = StatusesShowId.new(args)

  puts "Returns a single Tweet, specified by the id parameter. The Tweet’s author will also be embedded within the tweet. '#{input[:Id]}'"

    #File.open('showStatusId.txt', 'w') do |f|
    #print(twitter.collect)
      #print params
  twitter.collect do |data|
  puts data
  #print(twitter.collect)
end

  #end

  puts "DONE."

end

