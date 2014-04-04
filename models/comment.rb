class Comment
  include DataMapper::Resource

  property :id, Serial
  property :body, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :wiki
  belongs_to :account, required: false

  def self.list(wiki_id)
    all(wiki_id: wiki_id)
  end
end
