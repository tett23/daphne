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

  def self.allow_everyone_access?(project_id, privilege=:view)
    authority = Authority.first(project_id: project_id, type: :global, privilege: privilege)
    return false if authority.nil?
    return false if authority.privilege == :deny
    return true if authority.privilege == :all
    return true if authority.privilege == :view && privilege == :view
    return true if authority.privilege == :issue && (privilege == :issue || privilege == :view)

    false
  end

  def self.account_privileges(project_id, account_id)
    Authority.all(project_id: project_id, account_id: account_id, type: :account).map do |authority|
      authority.privilege
    end
  end

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

  def self.concerned(account_id, privileges=[:view])
    Authority.all(account_id: account_id, type: :account, privilege: [:all, :issue])
  end
end
