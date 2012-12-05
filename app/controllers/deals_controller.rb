require 'net/http'
require 'json'

class DealsController < ApplicationController
  # GET /deals
  # GET /deals.json
  def index
    @deals = Deal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @deals }
    end
  end

  # GET /deals/1
  # GET /deals/1.json
  def show
    @deal = Deal.find(params[:id])

    token_my_finance = "https://2a4d1f61dd6bf122b55890b72bff57032ded61f0bdcf8c3e:x@app.myfinance.com.br/"
    

    token_pipedrive = "api_token=57f839e9a500cf2ef6b9dc8b156bce2c09a0905d"
    uri_pipedrive_prod = "http://api.pipedrive.com/v1/deals/#{@deal.pipedrive_id}/products?start=0&#{token_pipedrive}"

    respprod = Net::HTTP.get_response(URI.parse(uri_pipedrive_prod))
    parsedprod = JSON.parse(respprod.body)

    parsedprod["data"].each do |registro|
      uri_my_finance = "#{token_my_finance}entities/12276/receivable_accounts"
      uritpprod = "http://api.pipedrive.com/v1/products/#{registro['product_id']}?#{token_pipedrive}"
      resptpprod = Net::HTTP.get_response(URI.parse(uritpprod))
      parsedtpprod = JSON.parse(resptpprod.body)

      #uri_my_finance_categ = "#{token_my_finance}categories"
      #resp_categ = RestClient.get(uri_my_finance_categ, {:accept => :json})
      #parsedresp_categ = JSON.parse(resp_categ.body)
      #parsedresp_categ.each do |registro|
      #  registro["category"]["id"]
      #  registro["category"]["full_name"]
      #end

      resp = RestClient.post( uri_my_finance,
               { :receivable_account => {
                 due_date:  "2012-10-10",
	         amount: registro["sum"],
                 category_id: 1747046,
		 person_id: @deal.company_id
                 }
               },
               :accept => :json,
               :content_type => :json
             )
    end

    redirect_to :action => :index

    #respond_to do |format|
    #  format.html # show.html.erb
    #  format.json { render json: @deal }
    #end
  end

  # GET /deals/new
  # GET /deals/new.json
  def new

    token_my_finance = "https://2a4d1f61dd6bf122b55890b72bff57032ded61f0bdcf8c3e:x@app.myfinance.com.br/"
    token_pipedrive = "api_token=57f839e9a500cf2ef6b9dc8b156bce2c09a0905d"
    uri_pipedrive = "http://api.pipedrive.com/v1/deals?start=0&#{token_pipedrive}"
    resp_pipedrive = Net::HTTP.get_response(URI.parse(uri_pipedrive))
    parsedresp = JSON.parse(resp_pipedrive.body)

    parsedresp["data"].each do |registro|

      uri_pipedrive_org = "http://api.pipedrive.com/v1/organizations/#{registro["org_id"]["value"]}?#{token_pipedrive}"
      resp_pipedrive_org = Net::HTTP.get_response(URI.parse(uri_pipedrive_org))
      parsedresp_org = JSON.parse(resp_pipedrive_org.body)
      unless parsedresp_org["data"]["766bc8061847bc4a302ae67993ea7a895c496286"].nil? || parsedresp_org["data"]["766bc8061847bc4a302ae67993ea7a895c496286"].empty? || registro["status"] == "open" || registro["status"] == "lost"
	busca_my_finance = "people.json?search%5Bfederation_subscription_number_only_numbers_or_federation_subscription_number_contains%5D="
        cpf_cnpj = parsedresp_org["data"]["766bc8061847bc4a302ae67993ea7a895c496286"]
        cpf_cnpj["/"] = "%2F"
        uri_my_finance = "#{token_my_finance}#{busca_my_finance}#{cpf_cnpj}"
        resp = RestClient.get(uri_my_finance, {:accept => :json})
	unless resp == "[]"
          resp_json = JSON.parse(resp.body)
	  my_finance_org_id = resp_json[0]["person"]["id"]
          @deal = Deal.new
          @deal.pipedrive_id = registro["id"]
          @deal.public_id = registro["public_id"]
          @deal.company_id = my_finance_org_id
          @deal.title = registro["title"]
          @deal.value = registro["value"]
          @deal.currency = registro["currency"]
          @deal.products_count = registro["products_count"]
          @deal.feira_id = registro["pipeline"]
          @deal.save
	end
      end
    end
    
    redirect_to :action => :index

    # respond_to do |format|
    #  format.html # new.html.erb
    #  format.json { render json: @deal }
    # end
  end

  # GET /deals/1/edit
  def edit
    @deal = Deal.find(params[:id])
  end

  # POST /deals
  # POST /deals.json
  def create
    @deal = Deal.new(params[:deal])

    respond_to do |format|
      if @deal.save
        format.html { redirect_to @deal, notice: 'Deal was successfully created.' }
        format.json { render json: @deal, status: :created, location: @deal }
      else
        format.html { render action: "new" }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /deals/1
  # PUT /deals/1.json
  def update
    @deal = Deal.find(params[:id])

    respond_to do |format|
      if @deal.update_attributes(params[:deal])
        format.html { redirect_to @deal, notice: 'Deal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deals/1
  # DELETE /deals/1.json
  def destroy
    @deal = Deal.find(params[:id])
    @deal.destroy

    respond_to do |format|
      format.html { redirect_to deals_url }
      format.json { head :no_content }
    end
  end
end
