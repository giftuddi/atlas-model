
system "frontend" do

  server "load-balancer", base: "load-balancer:giftudi?from=80&to=8000"

  server "front", base: "appserver",
                  cardinality: ["tiger", "fluffy", "snickers"],
                  install: ["galaxy:frontend-0.1.0", 
                            "lb-add:giftudi"]
end
