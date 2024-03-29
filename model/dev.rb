
environment "dev" do

  cardinality "/frontend.0/cat" => 1

  listener "ssh-keypairs", atlas: "default"
  #listener "progress-bars"

  server "console", base: "console", install:["apt:git ruby1.9.3 rake", 
                                              "exec:sudo update-alternatives --set ruby /usr/bin/ruby1.9.1",
                                              "exec:mkdir src && git clone git://github.com/giftuddi/frontend.git"]

  provisioner "vmware", vmrun: "/Applications/VMware Fusion.app/Contents/Library/vmrun",
                        ubuntu: "file:///Users/brianm/vmware/ubuntu-12.04-atlas.tgz?user=atlas&pass=atlas"

  base "ubuntu", provisioner: "vmware:ubuntu", init: ["exec:sudo apt-get update", "apt:emacs23-nox"]

  base "appserver", inherit: "ubuntu",
                    init: ["sculptor-agent"]

  base "console", inherit: "ubuntu", init: ["scratch:console=@", "sculptor-console"]

  base "load-balancer", provisioner: "noop"

  installer "lb-add", virtual: ["noop"]

  installer "sculptor-common",  virtual:["apt:openjdk-7-jre-headless m4 curl",
                                         "exec:curl -O http://static.giftudi.com/sculptor_0.0.3.7.deb",
                                         "exec:sudo dpkg -i sculptor_0.0.3.7.deb"]

  installer "sculptor-agent",   virtual: ["sculptor-common",
                                          "exec:sudo update-rc.d sculptor-agent defaults",
                                          "erb:sculptor/sculptor.conf.erb > /etc/sculptor.conf",
                                          "exec:sudo service sculptor-agent restart"]

  installer "sculptor-console", virtual: ["sculptor-common",
                                          "exec:sudo update-rc.d sculptor-console defaults",
                                          "erb:sculptor/sculptor.conf.erb > /etc/sculptor.conf",
                                          "exec:sudo service sculptor-console restart"]
  installer "galaxy", {
    virtual: ["script:sculptor/install.sh {virtual.fragment}"]
  }

end
