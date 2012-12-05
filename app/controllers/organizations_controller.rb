require 'net/http'
require 'json'

class OrganizationsController < ApplicationController
  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organizations }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @organization = Organization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /organizations/new
  # GET /organizations/new.json
  def new
    token_my_finance = "https://2a4d1f61dd6bf122b55890b72bff57032ded61f0bdcf8c3e:x@app.myfinance.com.br/"
    token_pipedrive = "api_token=57f839e9a500cf2ef6b9dc8b156bce2c09a0905d"
    uri_pipedrive = "http://api.pipedrive.com/v1/organizations?start=0&#{token_pipedrive}"
    resp_pipedrive = Net::HTTP.get_response(URI.parse(uri_pipedrive))
    parsedresp = JSON.parse(resp_pipedrive.body)
    parsedresp["data"].each do |registro|
      unless registro["766bc8061847bc4a302ae67993ea7a895c496286"].nil? || registro["766bc8061847bc4a302ae67993ea7a895c496286"].empty?
      	@org = Organization.find_by_cpf_cnpj(registro["766bc8061847bc4a302ae67993ea7a895c496286"])
	unless @org
          @organization = Organization.new
          @organization.pipedrive_id = registro["id"]
          @organization.name = registro["name"]
          @organization.segmento = registro["03ad8a3f3e6772319942623d1ee7e57ae9cd874f"]
          @organization.razao_social = registro["5f297cb189fe93cdb2df12d30ff9ddeae9c2c662"]
          @organization.fisica_juridica = registro["ba254e36c125442cc1220a51fd1decf1029dc7b0"] 
          @organization.cpf_cnpj = registro["766bc8061847bc4a302ae67993ea7a895c496286"]
          @organization.url = registro["313365dc5ab3c0230a08f3d221685b73d4a5c55c"]
          @organization.save
          @org = Organization.find_by_cpf_cnpj(registro["766bc8061847bc4a302ae67993ea7a895c496286"])	  
	end
	if @org.my_finance_id.nil? and @org.pipedrive_id != 6
           busca_my_finance = "people.json?search%5Bfederation_subscription_number_only_numbers_or_federation_subscription_number_contains%5D="
           cpf_cnpj = registro["766bc8061847bc4a302ae67993ea7a895c496286"]
           cpf_cnpj["/"] = "%2F"
	   uri_my_finance = "#{token_my_finance}#{busca_my_finance}#{cpf_cnpj}"
           # Verifica se já possui CPNJ cadastrado
           resp = RestClient.get(uri_my_finance, {:accept => :json})
	   if resp != "[]"
             resp_json = JSON.parse(resp.body)
	     @org.my_finance_id = resp_json[0]["person"]["id"]
	     @org.save
           else
             uri_my_finance = "#{token_my_finance}people"
             resp = RestClient.post( uri_my_finance,
                    { :person => {
   	              :customer => true,
		      :federation_subscription_number => @org.cpf_cnpj,
	              :name => @org.razao_social,
		      :person_type => "JuridicalPerson",
		      :site => @org.url,
		      :supplier => false
	              }
                    },
                    :accept => :json,
                    :content_type => :json
	            )
             resp_json = JSON.parse(resp.body)
             @org.my_finance_id = resp_json["person"]["id"]
             @org.save
	   end
	end
      end
    end

    uri = 'https://2a4d1f61dd6bf122b55890b72bff57032ded61f0bdcf8c3e:x@app.myfinance.com.br/people'
    resp = RestClient.get(uri, {:accept => :json})
    parsedresp = JSON.parse(resp.body)
    parsedresp.each do |registro|
      unless registro["person"]["federation_subscription_number"].nil? || registro["person"]["federation_subscription_number"].empty?
        if @org = Organization.find_by_cpf_cnpj(registro["person"]["federation_subscription_number"])
          @org.my_finance_id = registro["person"]["id"]
	  @org.save
	end
      end
    end

    redirect_to :action => :index

    # @organization = Organization.new
    # respond_to do |format|
    #   format.html # new.html.erb
    #   format.json { render json: @organization }
    # end
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(params[:organization])

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render json: @organization, status: :created, location: @organization }
      else
        format.html { render action: "new" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :no_content }
    end
  end
end
