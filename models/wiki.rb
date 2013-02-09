class Wiki
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :body, Text

  belongs_to :issue
  belongs_to :project
end
