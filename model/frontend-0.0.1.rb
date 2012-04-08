
system "frontend" do
  
  server "cat", base: "appserver",
  				cardinality: ["Tiger", "Fluffy"],
    			install: ["galaxy:frontend-0.0.2-SNAPSHOT-3"]
end

