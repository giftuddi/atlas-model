
environment "dev" do

  cardinality "/frontend.0/front" => 1

  listener "ssh-keypairs", atlas: "default"
  listener "progress-bars"

  server "console", base: "console", install:["apt:git ruby1.9.3 rake", 
                                              "exec:sudo update-alternatives --set ruby /usr/bin/ruby1.9.1",
                                              "exec:mkdir src && git clone git://github.com/giftuddi/frontend.git"]

  provisioner "vmware", vmrun: "/Applications/VMware Fusion.app/Contents/Library/vmrun",
                        ubuntu: "file:///Users/brianm/vmware/ubuntu-12.04-atlas.tgz?user=atlas&pass=atlas"

  base "ubuntu", provisioner: "vmware:ubuntu", 
                 init: ["exec:sudo apt-get update", "apt:emacs23-nox"]

  base "appserver", inherit: "ubuntu",
                    init: ["sculptor-agent"]

  base "console", inherit: "ubuntu", init: ["scratch:console=@", "sculptor-console"]

  installer "sculptor-common",  virtual:["apt:openjdk-6-jre-headless m4 curl",
                                         "exec:curl -O http://static.giftudi.com/sculptor_0.0.3.7.deb",
                                         "exec:sudo dpkg -i sculptor_0.0.3.7.deb",
                                         "erb:sculptor/sculptor.conf.erb > /etc/sculptor.conf"]

  installer "sculptor-agent",   virtual: ["sculptor-common",
                                          "exec:sudo update-rc.d sculptor-agent defaults",
                                          "exec:sudo service sculptor-agent restart"]

  installer "sculptor-console", virtual: ["sculptor-common",
                                          "exec:sudo update-rc.d sculptor-console defaults",
                                          "exec:sudo service sculptor-console restart"]
  installer "galaxy", {
    virtual: ["script:sculptor/install.sh {virtual.fragment}"]
  }

  installer "lb-add", virtual: ["noop"]

  base "load-balancer", provisioner: "noop"

end
