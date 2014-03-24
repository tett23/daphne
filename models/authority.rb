class Authority
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :type, Enum[:account, :global], default: :global
  property :privilege, Enum[:all, :view, :issue, :deny], default: :view

  belongs_to :project
  belongs_to :account, require: false
end
