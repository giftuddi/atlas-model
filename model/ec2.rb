
environment "ec2" do

  listener "progress-bars"
  listener "aws-config", ssh_ubuntu: "ubuntu@default"

  system "utilities" do
    server "giftudi-security-group", base: "ec2-security-group:giftudi"
    server "console", base: "console", install: ["sculptor-console"]
  end

  base "load-balancer", {
    provisioner: ["elb:{base.fragment}", {
                    from_port: "{base.params.from}",
                    to_port: "{base.params.to}",
                    protocol: "http",
                    allow_group_giftudi: "giftudi"
                  }],
  }

  base "ec2-security-group", {
    provisioner: ["ec2-security-group:{base.fragment}", {
                    ssh_from_outside: "tcp 22 0.0.0.0/0",
                    sculptor_agent: "tcp 25365 {base.fragment}",
                    sculptor_console: "tcp 36525 {base.fragment}"
                  }]
  }

  base "mysql", {
    provisioner: [ "rds", {
                     name: "{base.fragment}",
                     storage_size: "5",
                     instance_class: "db.m1.small",
                     engine: "MySQL",
                     username: "wp",
                     password: "wp",
                     security_group: "dbs"
                   }],
    init: ["scratch:{base.fragment}=@"]
  }


  base "ubuntu", provisioner: "ec2:ami-ebea3482?instance_type=m1.small&security_group=giftudi",
                 init: ["exec:sudo apt-get update", "apt:emacs23-nox"]

  base "appserver", inherit: "ubuntu",
                    init: ["sculptor-agent"]

  base "console", inherit: "ubuntu", init: ["scratch:console=@", "sculptor-console"]


  installer "lb-add", virtual: ["elb-add:{virtual.fragment}"]

  installer "sculptor-common",  virtual:["apt:openjdk-7-jre-headless openjdk-7-jdk m4 curl",
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
