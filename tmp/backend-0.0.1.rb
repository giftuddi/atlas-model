
system "backend" do

  server "gifts", base: "appserver",
                  cardinality: 2,
                  install: ["galaxy:backend-0.0.1"]
end
