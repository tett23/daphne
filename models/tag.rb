class Tag
  include DataMapper::Resource

  property :id, Serial
  property :title, String

  belongs_to :account, :required=>false
  belongs_to :color, :required => false

  def self.create_by_text(text, account_id)
    return nil if text.strip.blank?

    tags = []

    text.split(',').each do |tag|
      tag = tag.strip

      tags << first_or_create(
        title: tag,
        account_id: account_id
      )
    end

    tags
  end
end
