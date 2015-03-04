require_relative '../requests/TrendsClosest'

require 'trollop'

USAGE = %Q{
get_trend_locations: 
  Retrieve a Where On Earth ID and Location Name for the closest location with
  trending topic information based on Latitude and Longitude.

Usage:
  ruby get_trend_locations.rb <options> <lat_dir> <lat> <long_dir> <long>

  <lat>: A latitude coordinate with valid ranges 0 to 90.0 
  
  <lat_dir>: Direction of latitude with valid input <s> - South or <n> - North

  <long>: A longitude coordinate with valid ranges 0 to 180.0

  <long_dir>: Direction of longitude with valid input <w> - West or <e> - East

Example: 

  lat = North 40.0274 and long = West 105.2519 is Boulder, Colorado:

  $ ruby get_trend_locations.rb --props oauth.properties n 40.0274 w 105.2519

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_trend_locations 0.1 (c) 2015 Kenneth M. Anderson; Updated by William DeRaad"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid file"
  end

  opts[:lat_dir]  = ARGV[0]
  opts[:lat]      = ARGV[1]
  opts[:long_dir] = ARGV[2]
  opts[:long]     = ARGV[3]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  if input[:lat_dir] == "s"
    input[:lat] = "-" + input[:lat]
  end
  if input[:long_dir] == "w"
    input[:long] = "-" + input[:long]
  end
  params = { lat: input[:lat], long: input[:long]}
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = TrendsClosest.new(args)

  puts "Getting the closest WOEID and Location Name for: 
        Latitude: #{input[:lat]} Longitude: #{input[:long]}"

  File.open('locations.txt', 'w') do |f|
    twitter.collect do |locations|
      f.puts "#{locations[0]} #{locations[1]}\n"
    end
  end

  puts "DONE."

end
