class Issue
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, String
  property :description, Text

  belongs_to :account, :required=>false
  belongs_to :project, :required=>false

  def self.list(account_id)
    all(:account_id=>account_id)
  end
end
