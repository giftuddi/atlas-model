
environment "dev" do

  cardinality "/frontend.0/cat" => 1

  listener "ssh-keypairs", atlas: "default"
  #listener "progress-bars"

  server "console", base: "console", install:["apt:git ruby1.9.3 rake", 
                                              "exec:sudo update-alternatives --set ruby /usr/bin/ruby1.9.1"]

  provisioner "vmware", vmrun: "/Applications/VMware Fusion.app/Contents/Library/vmrun",
                        ubuntu: "file:///Volumes/big_data/atlas_vmware/base-ubuntu.vmwarevm.tgz?user=atlas&pass=atlas"



  base "ubuntu", provisioner: "vmware:ubuntu", init: ["apt:emacs23-nox"]

  base "appserver", inherit: "ubuntu",
                    init: ["sculptor-agent"]

  base "console", inherit: "ubuntu", init: ["scratch:console=@", "sculptor-console"]



  installer "sculptor-common",  virtual:["apt:openjdk-7-jre-headless openjdk-7-jdk m4 curl",
                                         "exec:curl -O http://static.giftudi.com/sculptor_0.0.3.6.deb",
                                         "exec:sudo dpkg -i sculptor_0.0.3.6.deb"]

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
