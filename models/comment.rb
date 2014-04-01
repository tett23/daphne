class Comment
  include DataMapper::Resource

  property :id, Serial
  property :body, Text

  belongs_to :wiki
  belongs_to :account, required: false
end
