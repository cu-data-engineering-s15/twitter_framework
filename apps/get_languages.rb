require_relative '../requests/Languages'

require 'trollop'

USAGE = %Q{
get_languages: Retrieves a list of languages supported by Twitter, along with their Twitter language code.

Usage:
	ruby get_languages.rb <options>

The following options are supported:
}

def parse_command_line

	options = {type: :string, required: true}
	
	opts = Trollop::options do
		version "get_languages 0.1 (c) 2015 Kenneth M. Anderson; Modified by Heather Witte"
		banner USAGE
		opt :props, "OAuth Properties File", options
	end

	unless File.exist?(opts[:props])
		Trollop::die :props, "must point to a valid oauth properties file"
	end
	opts
end

if __FILE__ == $0
	
	STDOUT.sync = true

	input = parse_command_line
	data = {props: input[:props] }
	
	args = {params: {}, data: data}
	twitter = Languages.new(args)

	File.open('languages.json', 'w') do |f|
		twitter.collect do |languages|
			languages.each do |language|
			puts "#{language["code"]}: #{language["name"]} "
			end
		end
	end
	
	puts "DONE"

end
