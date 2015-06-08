require 'sdf-gen/cli'

class SDFGen::Command::Forwarder < SDFGen::Command

  desc 'Generate a forwarder'
  arg_name "config"
  command :forwarder do |c|
    c.desc "Id of the forwarder to generate (if there are multiple)"
    c.flag [:i, "forwarder-id"]
    
    c.desc "Conjur authentication identifier"
    c.flag [:l, :"authn-login"]

    c.desc "Conjur authentication API key"
    c.flag [:k, :"authn-api-key"]
    
    c.action do |global_options,options,args|
      config_file = require_arg(args, "config")
      assert_empty args
      
      config = load_config(config_file)
      
      forward = config.forward or raise "No 'forward' settings found in #{config_file}"
      forward = select_forward forward, options[:i]
      forward.global = Hashr.new(config.global)
      puts generate_forwarder(forward, options)
    end
  end
  
  def self.select_forward forward, id
    result = if id
      forward[id] or raise "Forwarder #{id} not found"
    elsif forward.length == 1
      forward.values.first
    else
      raise "Forwarder id is required when multiple forwarders are defined"
    end
    Hashr.new(result)
  end
  
  def self.generate_forwarder forward, options, id = nil
    forward.authn_login = options[:l] or raise "authn-login is missing"
    forward.authn_api_key = options[:k] or raise "authn-api-key is missing"
    process_template(File.expand_path("../forwarder.conf.erb", __FILE__), forward)
  end
end
