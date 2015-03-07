require_relative '../requests/ReverseGeocode'

require 'trollop'
 
USAGE = %Q{
reverse_geocode: Given a latitude and a longitude, searches for up to 20 places.

Usage:

  ruby reverse_geocode.rb <options>

Example: 

  ruby reverse_geocode.rb --props oauth.properties --lat 37.76893497 --long -122.42284884

  The valid range of values for Latitude is -90.0 to +90.0 
  The valid range of values for Longitude is -180.0 to +180.0.

The following options are supported:
}

def parse_command_line

  opts = Trollop::options do
    version "reverse_geocode 0.1 (c) 2015 Kenneth M. Anderson; Updated by Vikas Mehta"
    banner USAGE
    opt :props, "OAuth Properties File", type: :string, required: true
    opt :lat, "latitude", type: :float, required: true, short: "-t"
    opt :long, "longitude", type: :float, required: true, short: "-n"
    opt :max, "max results", type: :int, required: false, short: "-m"
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end
 
  opts
end


if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { lat: input[:lat], long: input[:long]}

  params.merge!({max_results: input[:max]}) unless input[:max].nil?

  data   = { props: input[:props] }
  args   = { params: params, data: data }
 
  geo    = ReverseGeocode.new(args)

  puts "Searching for locations near: #{params[:lat]}, #{params[:long]}"

  File.open('locations.json', 'w') do |f|
    geo.collect do |locations|
      locations.each do |location|
        f.puts "#{location.to_json}\n"
      end
    end
  end

  puts "Locations stored in file 'locations.json'."
  puts "DONE."

end
