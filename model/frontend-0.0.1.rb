
system "frontend" do
  
  server "cat", base: "appserver",
    			install: ["galaxy:frontend-0.0.2-SNAPSHOT2"]
end

