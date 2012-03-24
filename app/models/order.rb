class Order
  include MongoMapper::Document

  key :uid, String
  key :description, String
  key :restaurant, String
  key :voters, Array
  key :tray, Array
  key :name, String
  key :address, String
  key :city, String
  key :state, String
  key :zip, String
  key :phone, String
  key :email, String

end
