require 'iron_worker'
require 'json'
require 'rest-client'

class PopulateRestaurant < IronWorker::Base
  attr_accessor :restaurant_id, :mongo_db, :mongo_host, :mongo_password,
    :mongo_port, :mongo_username

  merge_gem 'mongo_mapper'
  merge "../models/item.rb"
  merge "../models/restaurant.rb"

  def run
    init_mongo

    begin
      res = RestClient.get 'https://r-test.ordr.in/rd/' + @restaurant_id.to_s
      parsed = JSON.parse(res)
      if parsed
        items = []
        parsed['menu'].each do |cat|
          cat['children'].each do |i|
            if i['is_orderable'] == '1'
              items << i['id']
              new_item = Item.new(:nid => i['id'],
                                  :restaurant_id => @restaurant_id,
                                  :name => i['name'],
                                  :description => i['descrip'],
                                  :price => i['price'],
                                  :image_url => grab_image_url(i['name']))
              new_item.save
            end
          end
        end
        new_restaurant = Restaurant.new(:nid => @restaurant_id,
                                        :name => parsed['name'],
                                        :menu => items)
        new_restaurant.save
      else
        log "Invalid restaurant #{restaurant_id}."
      end
    rescue Exception => e
      log "Exception: #{e.inspect}"
    end
  end

  def grab_image_url(name)
    res = RestClient.get 'https://api.pinterest.com/v2/search/pins/', 
      {:params => {:query => name}}
    parsed = JSON.parse(res)
    log parsed
    if parsed && parsed['pins'] && parsed['pins'][0]
      parsed['pins'][0]['images']['board']
    else
      nil
    end
  end

  def init_mongo
    MongoMapper.connection = Mongo::Connection.new(@mongo_host, @mongo_port)

    MongoMapper.database = @mongo_db
    if @mongo_username.present?
      MongoMapper.database.authenticate(@mongo_username, @mongo_password)
    end
  end
end