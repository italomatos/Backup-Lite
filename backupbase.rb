require 'yaml'
require 'logger'

class BackupBase
	def initialize() 
		@config = YAML.load_file("config.yml")
		@logger = Logger.new(STDERR)
		key = self.class.name.downcase
		@config[key].each {|key_attr, value| instance_variable_set("@#{key_attr}_#{key}", value)}
	end
end

