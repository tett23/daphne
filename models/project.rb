class Project
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, String
  property :description, Text

  belongs_to :account, :required=>false
  has n, :issues
  belongs_to :color, :required=>false

  def self.detail(id)
    get(id)
  end

  def self.list(account_id)
    all(:account_id=>account_id)
  end

  def self.select_list(account_id)
    all(:account_id=>account_id).map do |r|
      [r.title, r.id]
    end
  end

  def self.search(account_id, title)
    all(
      :account_id => account_id,
      :title.like => "%#{title}%"
    )
  end

  def owner?(account_id)
    self.account_id == account_id
  end
end
