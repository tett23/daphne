class Account
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :email, String
  property :role, String
  property :uid, String
  property :provider, String

  def self.create_with_omniauth(auth)
    account = first_or_create({
      :uid => auth['uid'],
      :provider => auth['provider'],
      :name => auth['info']['name'],
      :role => :users
    })

    return account.first if Array == account.class

    account
  end

  # omniauthが使用するORMの変更がうまくいくなら直すこと
  def self.find_by_id(id)
    first(id)
  end
end
