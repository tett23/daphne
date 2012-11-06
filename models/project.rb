class Project
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, String
  property :description, Text
  property :color, String

  has n, :issues
end
