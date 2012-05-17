class Thing
  include DataMapper::Resource
  
  # Primary key
  property :id,               Serial
  
  # Relationships
  has n, :items
  
  # Info
  property :name,             String, :index => true
  property :description,      Text
  property :time,             DateTime
  property :number,           Integer, :default => 50
  
  # Record Information
  property :created_at,       DateTime
  property :modified_at,      DateTime
  
end