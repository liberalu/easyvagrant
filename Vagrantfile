Vagrant.configure(2) do |config|
    
    #Box    
    config.vm.box = "ubuntu/trusty64"

    config.vm.synced_folder "puppet/scripts/", "/home/vagrant/bin"

    config.vm.network "private_network", ip: "192.168.33.10"

    # The page url is http://webpage.local.dev    
    config.vm.hostname = "webpage.local.dev"

    # phpMyAdmin url is http://phpmyadmin.local.dev
    # if you want to get info about php, you can look at http://phpinfo.local.dev
    config.hostsupdater.aliases = ["phpmyadmin.local.dev", "phpinfo.local.dev", "git.local.dev", "webgrind.local.dev", ]

    # puppets folder
    config.librarian_puppet.puppetfile_dir = "puppet"
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet"
        puppet.manifest_file  = "default.pp"
        puppet.module_path = ["puppet/modules"]
    end

    # The guest machine use 2048 MB RAM and 2 CPU cores
    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]   
    end

    config.trigger.after :up do
        run_remote "/bin/bash /home/vagrant/bin/run-rtail.sh -s"
    end

end
