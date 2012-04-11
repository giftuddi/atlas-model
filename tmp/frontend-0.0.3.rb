
system "frontend" do

  server "load-balancer", base: "load-balancer:giftudi?from=80&to=8000"

  server "front", base: "appserver",
                  cardinality: ["tiger", "fluffy", "snickers", "joe"],
                  install: ["galaxy:frontend-0.0.3", 
                            "lb-add:giftudi"]
end
