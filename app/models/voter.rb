class Voter
  include MongoMapper::Document

  key :email, String
  key :phone, String
  key :order, Array

end
