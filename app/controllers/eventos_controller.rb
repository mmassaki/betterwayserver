class EventosController < ApplicationController
  
  DIST_LAT = 0.01
  DIST_LONG = 0.01
  
  # GET /eventos
  # GET /eventos.xml
  # GET /eventos.json
  def index
    
    lat = params[:latitude].to_f
    long = params[:longitude].to_f
    delta_lat = params[:delta_latitude].to_f + DIST_LAT
    delta_long = params[:delta_longitude].to_f + DIST_LONG
    
    if !lat.zero? || !long.zero?
      @eventos = Evento.where({:ativo => true, :latitude => (lat - delta_lat)..(lat + delta_lat), :longitude => (long - delta_long)..(long + delta_long)})  
    else
      @eventos = Evento.all
    end
    
    @eventos.each do |evento|
      trocar_foto_por_url evento
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @eventos }
      format.json { render :json => @eventos }
    end
  end

  # GET /eventos/1
  # GET /eventos/1.xml
  def show
    @evento = Evento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @evento }
    end
  end

  # GET /eventos/new
  # GET /eventos/new.xml
  def new
    @evento = Evento.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @evento }
    end
  end

  # GET /eventos/1/edit
  def edit
    @evento = Evento.find(params[:id])
  end

  # POST /eventos
  # POST /eventos.xml
  # POST /eventos.json
  def create
    @evento = Evento.new(params[:evento])
    @evento.data_hora = Time.now
    @evento.foto = @evento.foto.read if !@evento.foto.nil?

    respond_to do |format|
      if @evento.save
        trocar_foto_por_url @evento
        format.html { redirect_to(@evento, :notice => 'Evento was successfully created.') }
        format.xml  { render :xml => @evento, :status => :created, :location => @evento }
        format.json { render :json => @evento, :status => :created, :location => @evento }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @evento.errors, :status => :unprocessable_entity }
        format.json { render :json => @evento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /eventos/1
  # PUT /eventos/1.xml
  def update
    @evento = Evento.find(params[:id])

    respond_to do |format|
      if @evento.update_attributes(params[:evento])
        format.html { redirect_to(@evento, :notice => 'Evento was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @evento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /eventos/1
  # DELETE /eventos/1.xml
  def destroy
    @evento = Evento.find(params[:id])
    @evento.destroy

    respond_to do |format|
      format.html { redirect_to(eventos_url) }
      format.xml  { head :ok }
    end
  end
  
  def foto
    evento = Evento.find(params[:id])
    send_data evento.foto, :type => 'image', :disposition => 'inline'
  end
  
  private #-------------------------------

  def trocar_foto_por_url(evento)
    evento.foto = url_for :action => 'foto', :id => evento if !evento.foto.nil?
  end

end