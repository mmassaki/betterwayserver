class RegistrosController < ApplicationController
  # GET /registros
  # GET /registros.xml
  def index
    @registros = Registro.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registros }
    end
  end

  # GET /registros/1
  # GET /registros/1.xml
  def show
    @registro = Registro.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @registro }
    end
  end

  # GET /registros/new
  # GET /registros/new.xml
  def new
    @registro = Registro.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @registro }
    end
  end

  # GET /registros/1/edit
  def edit
    @registro = Registro.find(params[:id])
  end

  # POST /registros
  # POST /registros.xml
  # POST /registros.json
  def create
    @registro = Registro.new(params[:registro])
    @registro.data_hora = Time.now

    respond_to do |format|
      if @registro.save
        # Thread.new do
          busca_via @registro
        # end
        format.html { redirect_to(@registro, :notice => 'Registro was successfully created.') }
        format.xml  { render :xml => @registro, :status => :created, :location => @registro }
        format.json { render :json => @registro, :status => :created, :location => @registro }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @registro.errors, :status => :unprocessable_entity }
        format.json { render :json => @registro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /registros/1
  # PUT /registros/1.xml
  def update
    @registro = Registro.find(params[:id])

    respond_to do |format|
      if @registro.update_attributes(params[:registro])
        format.html { redirect_to(@registro, :notice => 'Registro was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /registros/1
  # DELETE /registros/1.xml
  def destroy
    @registro = Registro.find(params[:id])
    @registro.destroy

    respond_to do |format|
      format.html { redirect_to(registros_url) }
      format.xml  { head :ok }
    end
  end

  private #--------------------------------------------
  
  def busca_via registro
    latlng = "#{registro.latitude},#{registro.longitude}"
    url = URI.parse('http://maps.googleapis.com')
    http = Net::HTTP.new(url.host, url.port)
    resp = http.get("/maps/api/geocode/json?latlng=#{latlng}&sensor=true")
    json = ActiveSupport::JSON.decode(resp.body)
    json["results"].each do |result|
      if result["types"].include? "street_address"
        result["address_components"].each do |node|
          node["types"].each do |type|
            case type
            when "street_number"
              registro.via_num = node["long_name"]
            when "route"
              registro.via = node["long_name"]
            when "sublocality"
              registro.bairro = node["long_name"]
            when "locality"
              registro.cidade = node["long_name"]
            when "administrative_area_level_1"
              registro.estado = node["long_name"]
            when "country"
              registro.pais = node["long_name"]
            when "postal_code"
              registro.cep = node["long_name"]
            end
          end
        end
        break
      end
    end
    registro.save
    Transito.informar registro
  end
  
end