
system "frontend" do

  server "load-balancer", base: "load-balancer:front?from=80&to=8000"

  server "front", base: "appserver",
                  cardinality: ["tiger", "fluffy"],
                  install: ["galaxy:frontend-0.0.1", 
                            "lb-add:front"]
end
