class IssueStatus
  include DataMapper::Resource

  property :id, Serial
  property :title, String

  def self.get_status_id(status_title)
    first(
      title: status_title
    ).id
  end
end
