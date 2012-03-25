
class VotersController < ApplicationController
  def index
    @items = []
    Restaurant.first(:nid => '141').menu.each do |db_item|
      new_item = Item.first(:nid => db_item)
      @items << new_item if new_item.image_url
    end
    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end
  def tumblr
    user = Tumblr::User.new(ENV['TUMBLR_EMAIL'], ENV['TUMBLR_PASSWORD'])
    Tumblr.blog = 'failterest'
    if params[:source] && params[:caption]
      post = Tumblr::Post.create(photo, :source => params[:source], 
        :caption => 'Tumblr')
    end
  end
 end