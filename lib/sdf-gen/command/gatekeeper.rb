require 'sdf-gen/cli'

class SDFGen::Command::Forwarder < SDFGen::Command

  desc 'Generate a gatekeeper'
  arg_name "config"
  command :gatekeeper do |c|
    c.action do |global_options,options,args|
      config_file = require_arg(args, "config")
      assert_empty args
      
      config = load_config(config_file)
      
      gatekeeper = config.gatekeeper or raise "No 'gatekeeper' settings found in #{config_file}"
      
      gatekeeper = Hashr.new(gatekeeper)
      puts process_template(File.expand_path("../gatekeeper.conf.erb", __FILE__), gatekeeper)
    end
  end
end
