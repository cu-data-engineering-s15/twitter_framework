require_relative '../requests/StatusesLookup'

require 'trollop'

USAGE = %Q{
get_tweets_lookup: returns the tweet objects associated with a given set of tweet ids

Example:
  ruby get_tweets_lookup -p oauth.properties --ids <file_of_tweet_ids>

Usage:

  ruby get_statuses_lookup.rb <options>

The following options are required:
}

def parse_command_line

  options_props = {type: :string, required: true}
  options_ids   = {type: :string, required: true}

  opts = Trollop::options do
    version "get_lookup 0.1 (c) 2015 Kenneth M. Anderson; Updated by Bremt Pivnik"
    banner USAGE
    opt :props, "OAuth Properties File", options_props
    opt :ids, "List of Space-Separated Tweet Ids", options_ids
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  unless File.exist?(opts[:ids])
    Trollop::die :props, "must point to an existing file of tweet ids"
  end

  opts
end

def parse_id_file( id_file_name )
  input = File.open( id_file_name )
  data  = input.read
  ids   = data.split("\n")
end

if __FILE__ == $0

  STDOUT.sync = true

  input   = parse_command_line

  list_of_ids = parse_id_file( input[:ids] )

  params  = { id: "" }
  data    = { props: input[:props] }

  args    = { params: params, data: data }
  twitter = StatusesLookup.new(args)

  while list_of_ids.length > 0

    ids = list_of_ids.shift(100)

    twitter.params[:id] = ids.join(",")

    puts "Getting Tweet objects for tweet ids: '#{ids.join(', ')}'"

    File.open('tweets.json', 'a') do |f|
      twitter.collect do |tweets|
        tweets.each do |tweet|
          f.puts "#{tweet.to_json}"
        end
      end
    end

  end

  puts "Tweet objects stored in file 'tweets.json'."
  puts "DONE."

end
