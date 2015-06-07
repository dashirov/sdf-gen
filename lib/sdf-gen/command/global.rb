require 'sdf-gen/cli'

class SDFGen::Command::Global < SDFGen::Command

  desc 'Generate the global Nginx config file'
  arg_name "config"
  command :global do |c|
    c.action do |global_options,options,args|
      config_file = require_arg(args, "config")
      assert_empty args
      
      config = load_config(config_file)
      global = config.global or raise "No 'global' settings found in #{config_file}"
      puts process_template(File.expand_path("../global.conf.erb", __FILE__), global)
    end
  end
end
