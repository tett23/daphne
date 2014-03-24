class Account
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :nickname, String
  property :email, String
  property :role, String
  property :uid, String
  property :provider, String

  def self.create_with_omniauth(auth)
    account = first(uid: auth['uid'])
    if account.nil?
      account = create(
        uid: auth['uid'],
        provider: auth['provider'],
        name: auth['info']['name'],
        nickname: auth['info']['nickname'],
        role: :users
      )
    end
    account.update_name(auth['info']['name']) unless account.name == auth['info']['name']
    account.update_nickname(auth['info']['nickname']) unless account.nickname == auth['info']['nickname']

    account
  end

  # omniauthが使用するORMの変更がうまくいくなら直すこと
  def self.find_by_id(id)
    get(id)
  end

  def update_name(name)
     update(name: name)
  end

  def update_nickname(nickname)
    update(nickname: nickname)
  end
end
