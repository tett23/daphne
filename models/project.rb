class Project
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, String
  property :description, Text
  property :color, String

  belongs_to :account, :required=>false
  has n, :issues

  def self.list(account_id)
    all(:account_id=>account_id)
  end
end
