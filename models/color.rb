class Color
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :color_code, String

  def self.select_list
    all.map do |r|
      [r.name, r.id]
    end
  end
end
