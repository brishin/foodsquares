require 'iron_worker'
require 'json'
require 'rest-client'

class PopulateRestaurant < IronWorker::Base
  attr_accessor :restaurant_id

  def run
    begin
      res = RestClient.get 'https://r-test.ordr.in/rd/' + @restaurant_id
      parsed = JSON.parse(res)
      if res

      else
        log "Invalid restaurant #{restaurant_id}."
      end
    rescue Exception => e
      log "Exception: #{e.inspect}"
    end
  end
end