
system "frontend" do

  server "load-balancer", base: "load-balancer:giftudi?from=80&to=8000"

  server "cat", base: "appserver",
  				cardinality: ["Tiger", "Fluffy"],
    			install: ["galaxy:frontend-0.0.2-SNAPSHOT2", 
    				      "lb-add:giftudi"]
end

