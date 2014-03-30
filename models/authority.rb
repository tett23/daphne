class Authority
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :type, Enum[:account, :global], default: :global
  property :privilege, Enum[:all, :view, :issue, :deny], default: :view
  property :account_nickname, String

  belongs_to :project
  belongs_to :account, required: false

  before :save, :link_account
  before :create, :link_account

  def self.project_index(project_id)
    self.all(project_id: project_id)
  end

  def self.type_select
    self.properties.find do |p|
      p.name == :type
    end.flag_map.map do |_, v|
      [v, v]
    end
  end

  def self.privilege_select
    self.properties.find do |p|
      p.name == :privilege
    end.flag_map.map do |_, v|
      [v, v]
    end
  end

  def link_account
    return true if self.account_nickname.nil?

    account = Account.first(nickname: self.account_nickname)
    return true if account.nil?

    self.account_id = account.id
  end
end
