require_relative '../requests/StatusesLookup'

require 'trollop'

USAGE = %Q{
get_tweets_lookup: returns the tweet objects associated with a given set of tweet ids

Example:
  ruby get_tweets_lookup -p oauth.properties --ids 20 432656548536401920

Usage:

  ruby get_statuses_lookup.rb <options>

The following options are required:
}

def parse_command_line

  options_props = {type: :string, required: true}
  options_ids   = {type: :integers, required: true}

  opts = Trollop::options do
    version "get_lookup 0.1 (c) 2015 Kenneth M. Anderson; Updated by Bremt Pivnik"
    banner USAGE
    opt :props, "OAuth Properties File", options_props
    opt :ids, "List of Space-Separated Tweet Ids", options_ids
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input   = parse_command_line

  params  = { id: input[:ids].join(',') }
  data    = { props: input[:props] }

  args    = { params: params, data: data }

  twitter = StatusesLookup.new(args)

  puts "Getting Tweet objects for tweet ids: '#{input[:ids].join(', ')}'"

  File.open('tweets.json', 'w') do |f|
    twitter.collect do |tweets|
      tweets.each do |tweet|
        f.puts "#{tweet.to_json}"
      end
    end
  end

  puts "Tweet objects stored in file 'tweets.json'."
  puts "DONE."

end
