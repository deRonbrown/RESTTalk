class Item
  include DataMapper::Resource
  
  # Primary key
  property :id,             Serial
  
  # Relationship
  belongs_to :thing, :required => false
  
  # General info
  property :someProp,       String
  
  # Record Info
  property :created_at,     DateTime
  property :modified_at,    DateTime
  
end