class Tag
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  belongs_to :color, :required => false
end
