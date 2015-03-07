require_relative '../requests/ShowStatusId'

require 'trollop'

USAGE = %Q{
show_status: Get the tweet specified by the given tweet id.

Usage:
  ruby show_status.rb <options> <id>

  <id>: The id of the desired tweet.

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

  opts[:id] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input   = parse_command_line

  params  = { id: input[:id] }
  data    = { props: input[:props] }

  args    = { params: params, data: data }

  twitter = ShowStatusId.new(args)

  puts "Getting tweet with id '#{input[:id]}'."

  File.open('tweet.json', 'w') do |f|
    twitter.collect do |tweet|
      puts "Tweet Created By: #{tweet['user']['screen_name']}"
      puts "Tweet Created On: #{tweet['created_at']}"
      puts "Tweet Text      : #{tweet['text']}"
      f.puts "#{tweet.to_json}"
    end
  end

  puts "Full tweet stored in file 'tweet.json'."
  puts "DONE."

end
