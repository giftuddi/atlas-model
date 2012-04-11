
system "backend" do
t
  server "dog", base: "appserver",
                cardinality: ["Bean", "Bouncer"],
                install: ["galaxy:frontend-0.0.1", 
                          "lb-add:giftudi"]
end

