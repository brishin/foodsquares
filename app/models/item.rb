class Item
  include MongoMapper::Document

  key :nid, String
  key :name, String
  key :description, String
  key :price, String
  key :image_url, String

end
