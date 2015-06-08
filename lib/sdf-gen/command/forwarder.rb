require 'sdf-gen/cli'

class SDFGen::Command::Forwarder < SDFGen::Command

  desc 'Count the number of forwarders in the config'
  arg_name "config"
  command :"forwarder-count" do |c|
    c.action do |global_options,options,args|
      config_file = require_arg(args, "config")
      assert_empty args
      config = load_config(config_file)
      puts(config.forward ? config.forward.count : 0)
    end
  end

  desc 'Generate a forwarder'
  arg_name "config"
  command :forwarder do |c|
    c.desc "Index of the forwarder to generate (if there are multiple)"
    c.flag [:i, "forwarder-index"]
    
    c.desc "Conjur authentication identifier"
    c.flag [:l, :"authn-login"]

    c.desc "Conjur authentication API key"
    c.flag [:k, :"authn-api-key"]
    
    c.action do |global_options,options,args|
      config_file = require_arg(args, "config")
      assert_empty args
      
      config = load_config(config_file)
      
      forward = config.forward or raise "No 'forward' settings found in #{config_file}"
      
      result = if forward.is_a?(Hash)
        generate_forwarder forward, options
      elsif forward.length == 1
        generate_forwarder forward[1], options
      else 
        index = options[:i] or raise "--forwarder-index is required when multiple forwarders are defined"
        generate_forwarder forward[index.to_i-1], options
      end
      puts result
    end
  end
  
  def self.generate_forwarder forward, options
    forward = Hashr.new(forward)
    forward.authn_login = options[:l] or raise "authn-login is missing"
    forward.authn_api_key = options[:k] or raise "authn-api-key is missing"
    process_template(File.expand_path("../forwarder.conf.erb", __FILE__), forward)
  end
end