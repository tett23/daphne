class Color
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :color_code, String
end
