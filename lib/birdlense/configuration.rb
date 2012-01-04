require 'yaml'
module Birdlense
  class Configuration
    # Load the config from a file
    def self.load(file)
        file = File.expand_path(file)
        @config = YAML::load File.open(file)
    end
    
    # Get the config
    # This will work for now
    def self.get
      @config || Hash.new
    end
  end
end
