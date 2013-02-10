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

  # テキストからの入力をcreate用のHashに変換
  def self.parse_text(account_id, text)
    text.strip!

    lines = text.lines.to_a
    head = lines.first.strip
    text = lines[1..lines.size-1].join('').strip

    head = head.split('#')
    if head.size == 1 # プロジェクトとタスク名の両方がある
      project_id = nil
      issue_title = head.last
    else # タスク名のみとして処理する
      issue_title = head.last
      project_id = nil

      projects = Project.search(account_id, head.first)
      project_id = projects.first.id unless projects.nil?
    end

    {
      account_id: account_id,
      project_id: project_id,
      title: issue_title,
      description: text
    }
  end

  def self.list(account_id, options={})
    default = {
      issue_status_id: 1 # new
    }
    options = default.merge(options)
    options[:account_id] = account_id

    all(options)
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
