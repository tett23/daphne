class Wiki
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :body, Text
  property :is_project_index, Boolean

  belongs_to :account
  belongs_to :issue, :required=>false
  belongs_to :project, :required=>false

  def self.detail(account_id, project_id, title)
    first_or_create(
      account_id: account_id,
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
end
