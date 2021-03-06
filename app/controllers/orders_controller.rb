class OrdersController < ApplicationController
  require 'populate_and_mail.rb'

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])

    worker = PopulateAndMail.new
    worker.order_id = @order._id
    worker.restaurant_id = params[:order][:restaurant]
    if ENV['MONGO_DB'].present?
      worker.mongo_db = ENV['MONGO_DB']
      worker.mongo_host = ENV['MONGO_HOST']
      worker.mongo_password = ENV['MONGO_PASSWORD']
      worker.mongo_port = ENV['MONGO_PORT']
      worker.mongo_username = ENV['MONGO_USERNAME']
      worker.mailgun_api_key = ENV['MAILGUN_API_KEY']
    end
    worker.queue

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  
  def email
    @order = Order.first(:uid => params[:uid])
    @voter = Voter.first({:email => params[:email],
                          :order => @order._id.to_s})
    @items = []
    Restaurant.first(:nid => @order.restaurant).menu.each do |db_item|
      new_item = Item.first(:nid => db_item)
      @items << new_item if new_item.image_url
    end
    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def scrape
    worker = PopulateRestaurant.new
    worker.restaurant_id = params[:id]
    worker.mongo_db = ENV['MONGO_DB']
    worker.mongo_host = ENV['MONGO_HOST']
    worker.mongo_password = ENV['MONGO_PASSWORD']
    worker.mongo_port = ENV['MONGO_PORT']
    worker.mongo_username = ENV['MONGO_USERNAME']
    worker.queue
  end

end
