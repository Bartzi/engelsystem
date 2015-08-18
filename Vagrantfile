Vagrant.configure("2") do |config|
  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
  config.vm.network :forwarded_port, host: 5000, guest: 80

  config.vm.provision :puppet do |puppet|
    puppet.environment_path = "puppet/environments"
    puppet.environment = "engelsystem"
    puppet.options = "--verbose --debug"
  end
end  