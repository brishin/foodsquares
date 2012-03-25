class VotersController < ApplicationController
  def index
    @items = []
    Item.all.each do |item|
      @items << item if item.image_url
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