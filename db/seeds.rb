require "yaml"
require_relative "../models/init"

thing1 = Thing.new(:name => "test", :description => "testing", :time => Time.now, :number => 5)
thing2 = Thing.new(:name => "thing", :description => "thinging", :time => Time.now+60*60)

item1 = Item.new(:someProp => "item1")
item2 = Item.new(:someProp => "item2")
item3 = Item.new(:someProp => "item3")

thing1.items << item1
thing1.items << item2
thing2.items << item3

thing1.save
thing2.save