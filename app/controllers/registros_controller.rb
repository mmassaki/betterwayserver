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
end
