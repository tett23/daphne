# coding: utf-8

class Issue
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, String
  property :closed_at, DateTime
  property :issue_status_id, Integer, :default=>1
  property :scheduled_on, Date
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :account, :required=>false
  belongs_to :project, :required=>false
  belongs_to :issue_status
  belongs_to :wiki
  has n, :tags, :through=>Resource

  attr_accessor :description

  # テキストからの入力をcreate用のHashに変換
  def self.parse_text(account_id, text)
    text.strip!

    lines = text.lines.to_a
    head = lines.first.strip
    text = lines[1..lines.size-1].join('').strip

    head = head.split('#')
    if head.size == 1 # タスク名のみとして処理する
      project_id = nil
      issue_title = head.last
    else # プロジェクトとタスク名の両方がある
      issue_title = head.last
      project_title = head.first
      owner_name = project_title.match(/\(.+?\)/).to_a.first # ユーザ名の指定がある場合
      owner_name = Account.get(account_id).nickname if owner_name.nil? # なければ自分のnicknameを取得
      owner_name = owner_name.gsub(/\(|\)/, '')
      project_title = project_title.gsub(/\(.+?\)/, '')

      owner = Account.first(nickname: owner_name)

      projects = Project.search(owner.id, project_title)
      project_id = projects.first.id unless projects.blank?
    end

    {
      account_id: account_id,
      project_id: project_id,
      issue_status_id: IssueStatus.get_status_id(:new),
      title: issue_title,
      description: text
    }
  end

  def self.list(project_id, options={})
    default = {
      issue_status_id: 1 # new
    }
    options = default.merge(options)
    options[:project_id] = project_id unless project_id.nil?

    all(options)
  end

  def self.detail(id)
    get(id)
  end

  def text
    wiki_body = self.wiki.body.strip.gsub(/h1\..+$/, '').strip
    project_title = self.project.title unless self.project.nil?


    "#{project_title}#{'#' unless project_title.nil?}#{self.wiki.title}\n\n#{wiki_body}"
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

  def tags_text
    self.tags.map{|tag| tag.title}.join(',')
  end

  def self.aggrigate(project_id, status_name, account_id=nil)
    options = {}
    options[:project_id] = project_id unless project_id.nil?
    options[:account_id] = account_id unless account_id.nil?

    case status_name.to_sym
    when :all
      self.all(options).count
    else
      status_id = IssueStatus.get_status_id(status_name)
      raise '不正なIssueStatusId' if status_id.nil?
      options[:issue_status_id] = status_id

      self.all(options).count
    end
  end
end
