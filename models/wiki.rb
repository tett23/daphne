class Wiki
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :body, Text
  property :is_project_index, Boolean

  belongs_to :account
  belongs_to :issue, :required=>false
  belongs_to :project, :required=>false

  def self.detail(project_id, title)
    first_or_create(
      project_id: project_id,
      title: title
    )
  end

  def self.project_index(account_id, project_id)
    wiki = first_or_create({
      account_id: account_id,
      project_id: project_id,
      is_project_index: true
    })

    if wiki.title.blank?
      wiki.update(:title => wiki.project.title)
    end

    wiki
  end

  def self.create_by_issue(issue)
    wiki_body = "h1. #{issue.title}\n\n#{issue.description}"

    self.create(
      account_id: issue.account_id,
      project_id: issue.project_id,
      title: issue.title,
      body: wiki_body
    )
  end

  def update_by_issue(issue)
    wiki_body = "h1. #{issue.title}\n\n#{issue.description}"

    self.update(
      title: issue.title,
      body: wiki_body
    )
  end

  def self.exist?(account_id, project_id, title)
    !first(
      account_id: account_id,
      project_id: project_id,
      title: title
    ).nil?
  end

  def self.list(project_id)
    all(
      project_id: project_id
    )
  end

  def outline
    self.body.strip.gsub(/h1\..+$/, '').strip
  end
end
