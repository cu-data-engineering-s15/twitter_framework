require_relative '../requests/SearchGeo'

require 'trollop'

USAGE = %Q{
geo_search: Retrieve search information based on lattitude and longitude.

Usage:
  ruby geo_search.rb <options>

Example: ruby geo_search.rb -p oauth.properties --lat 40.015 --long -105.27

The following options are supported:
}

def parse_command_line

  options_string = {type: :string, required: true}
  options_lat    = {short: "a", type: :float, required: true}
  options_long   = {short: "o", type: :float, required: true}

  opts = Trollop::options do
    version "geo_search 0.1 (c) 2015 Kenneth M. Anderson; Updated by Upendra Sabnis"
    banner USAGE
    opt :props, "OAuth Properties File", options_string
    opt :lat, "Latitude", options_lat
    opt :long, "Longitude", options_long
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid file"
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { lat: input[:lat],long: input[:long] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = SearchGeo.new(args)

  puts "Searching for locations near Latitude: #{input[:lat]} and Longitude: #{input[:long]}"

  File.open('locations.json', 'w') do |f|
    twitter.collect do |georesults|
      georesults.each do |georesult|
        f.puts "#{georesult.to_json}\n"
      end
    end
  end

  puts "Locations placed in file 'locations.json'."
  puts "DONE."

end
