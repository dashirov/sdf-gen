require 'gli'
require 'sdf-gen/version.rb'

module SDFGen
  class Command < GLI::Command
    class << self
      def method_missing *a, &b
        SDFGen::CLI.send *a, &b
      end
      
      def require_arg(args, name)
        args.shift.tap do |arg|
          exit_now! "Missing parameter: #{name}" unless arg
        end
      end
      
      def assert_empty(args)
        exit_now! "Received extra command arguments" unless args.empty?
      end
      
      def load_config config_file
        require 'hashr'
        Hashr.new(YAML.load(File.read(config_file), config_file))
      end
      
      def process_template path, config
        require 'erb'
        erb = ERB.new File.read(path)
        erb.filename = path
        erb.result(config.instance_eval{ binding })
      end
    end
  end
  
  class CLI
    extend GLI::App
  
    subcommand_option_handling :normal
    
    program_desc 'SDF portal generator'
    
    version SDFGen::VERSION
    
    commands_from "sdf-gen/command"
  end
end
