class Order
  include MongoMapper::Document

  before_save :generate_uid, :generate_voters

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

  private
  def generate_uid
    length = 6
    begin
      charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
      rand_uid = (0...length).map{ charset.to_a[rand(charset.size)] }.join
    end while Order.exists?(:uid => rand_uid)
    self.uid = rand_uid
  end

  private 
  def generate_voters
    @temp = self.voters
    self.voters = []
    @temp.each do |voter_info|
      voter = Voter.new(:email => voter_info,
                        :order => self._id)
      voter.save
      self.voters << voter._id
    end
  end
end
