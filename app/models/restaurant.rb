class Restaurant
  include MongoMapper::Document

  key :nid, String
  key :name, String
  key :menu, Array

end
