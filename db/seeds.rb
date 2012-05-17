require "yaml"
require_relative "../models/init"

thing1 = Thing.new(:name => "test", :description => "testing", :time => Time.now, :number => 5)
thing2 = Thing.new(:name => "thing", :description => "thinging", :time => Time.now+60*60)

thing1.save
thing2.save