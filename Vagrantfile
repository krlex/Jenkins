Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.cpus = 2
    vb.memory = "2048"
  end

  config.vm.provision "shell" do |shell|
    shell.path = "jenkins.sh"
  end
end
