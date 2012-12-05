require 'net/http'
require 'json'

class ItemsController < ApplicationController
  before_filter :get_deal
  # :get_deal is defined at the bottom of the file, 
  # and takes the deal_id given by the routing and
  # converts it to an @student object.
  
  # GET /items
  # GET /items.json
  def index
    @items = @deal.items

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = @deal.items.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @deal = Deal.find(params[:deal_id])    

    token_pipedrive = "api_token=57f839e9a500cf2ef6b9dc8b156bce2c09a0905d"
    uri_pipedrive_prod = "http://api.pipedrive.com/v1/deals/#{@deal.pipedrive_id}/products?start=0&#{token_pipedrive}"

    respprod = Net::HTTP.get_response(URI.parse(uri_pipedrive_prod))
    parsedprod = JSON.parse(respprod.body)

    parsedprod["data"].each do |registro|
      @item = @deal.items.build
      @item.unique_id = registro["id"]
      @item.pipe_deal_id = registro["deal_id"]
      @item.order_nr = registro["order_nr"]
      @item.product_id = registro["product_id"]
      @item.item_price = registro["item_price"]
      @item.sum = registro["sum"]
      @item.currency = registro["currency"]
      @item.name = registro["name"]
      @item.quantity = registro["quantity"]

      uritpprod = "http://api.pipedrive.com/v1/products/#{registro["product_id"]}?#{token_pipedrive}"
      resptpprod = Net::HTTP.get_response(URI.parse(uritpprod))
      parsedtpprod = JSON.parse(resptpprod.body)
    
      @item.product_code = parsedtpprod["data"]["code"]
      @item.save
    end

    redirect_to :action => :index

    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.json { render json: @item }
    #end
  end

  # GET /items/1/edit
  def edit
    @item = @deal.items.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = @deal.items.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to deal_items_url(@deal), notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = @deal.items.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to deal_items_url(@deal), notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = @deal.items.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to (deal_items_path(@deal)) }
      format.json { head :no_content }
    end
  end

  private
  # get_deal converts the deal_id given by the routing
  # into an @deal object, for use here and in the view.
  def get_deal
    @deal = Deal.find(params[:deal_id])
  end
  
end
