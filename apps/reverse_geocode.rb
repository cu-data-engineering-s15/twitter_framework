require_relative '../requests/ReverseGeocode'

require 'trollop'
 
USAGE = %Q{
reverse_geocode: Given a latitude and a longitude, searches for up to 20 places.

Usage:

  ruby reverse_geocode.rb <options> <latitude> <longitude>

Example: 

  ruby reverse_geocode.rb --props oauth.properties --lat 37.76893497 --long -122.42284884

The following options are required:

  --params: An OAuth Properties File

  --lat: The latitude to search around. This parameter will be ignored unless it is inside the range -90.0 to +90.0 

  --long: The longitude to search around. The valid ranges for longitude is -180.0 to +180.0.

The following options are optional:

  --max: A hint as to the number of results to return.

The following options are supported:
}

def parse_command_line

  opts = Trollop::options do
    version "public_stream 0.1 (c) 2015 Kenneth M. Anderson; Updated by Vikas Mehta"
    banner USAGE
    opt :props, "OAuth Properties File", type: :string, required: true, short: "-o"
    opt :lat, "lattitude", type: :double, required: true, short: "-t"
    opt :long, "langitude", type: :double, required: true, short: "-n"
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
  params   = { lat: input[:lat], long: input[:long]}

  if(input[:max] != nil)
    params = params.merge({max_results: input[:max]})
  end

  data   = { props: input[:props] }
  args     = { params: params, data: data }
 
  geo = ReverseGeocode.new(args)

  puts "Starting connection to Twitter's Public Streaming API."
  puts "Search for location with the following latitude and longitude:"
  puts params[:lat]
  puts params[:long]

  File.open('reverse_geocode' + '.json', 'w') do |f|
    geo.collect do |geodata|
      geodata.each do |geodata|
        f.puts "#{geodata.to_json}\n"
      end
    end
  end

end
