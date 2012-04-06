
environment "dev" do

  listener "ssh-keypairs", atlas: "default"
  #listener "progress-bars"

  server "console", base: "console"

  provisioner "vmware", vmrun: "/Applications/VMware Fusion.app/Contents/Library/vmrun",
                        ubuntu: "file:///Volumes/big_data/atlas_vmware/base-ubuntu.vmwarevm.tgz?user=atlas&pass=atlas"

  base "ubuntu", provisioner: "vmware:ubuntu", init: ["apt:emacs23-nox curl"]

  base "appserver", inherit: "ubuntu",
                    init: ["sculptor-agent"]

  base "console", inherit: "ubuntu", init: ["scratch:console=@", "sculptor-console"]


  installer "sculptor-common",  virtual:["apt:openjdk-7-jre-headless",
                                         "exec:curl -O http://static.giftudi.com/sculptor_0.0.3.1.deb",
                                         "exec:sudo dpkg -i sculptor_0.0.3.1.deb"]

  installer "sculptor-agent",   virtual: ["sculptor-common", 
                                          "exec:sudo service sculptor-agent start",
                                          "exec:sudo update-rc.d sculptor-agent defaults",
                                          "erb:sculptor/sculptor.conf.erb > /etc/sculptor.conf"]

  installer "sculptor-console", virtual: ["sculptor-common", 
                                          "exec:sudo service sculptor-console start",
                                          "exec:sudo update-rc.d sculptor-console defaults",
                                          "erb:sculptor/sculptor.conf.erb > /etc/sculptor.conf"]
end
