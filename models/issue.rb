class Issue
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, String
  property :description, Text
  property :wiki, Text
  property :closed_at, DateTime
  property :issue_status_id, Integer, :default=>1

  belongs_to :account, :required=>false
  belongs_to :project, :required=>false
  belongs_to :issue_status

  def self.list(account_id, options={})
    default = {
      issue_status_id: 1 # new
    }
    options = default.merge(options)
    options[:account_id] = account_id

    all(options)
  end

  def self.project(project_id)
    all(:project_id=>project_id)
  end

  def self.detail(id)
    get(id)
  end

  def status_close
    update(
      issue_status_id: 2, # close
      closed_at: Time.now
    )
  end

  def status_new
    update(
      issue_status_id: 1, # new
      closed_at: nil
    )
  end
end
