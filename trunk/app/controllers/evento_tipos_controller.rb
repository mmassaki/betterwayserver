class EventoTiposController < ApplicationController
  # GET /evento_tipos
  # GET /evento_tipos.xml
  def index
    @evento_tipos = EventoTipo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @evento_tipos }
    end
  end

  # GET /evento_tipos/1
  # GET /evento_tipos/1.xml
  def show
    @evento_tipo = EventoTipo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @evento_tipo }
    end
  end

  # GET /evento_tipos/new
  # GET /evento_tipos/new.xml
  def new
    @evento_tipo = EventoTipo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @evento_tipo }
    end
  end

  # GET /evento_tipos/1/edit
  def edit
    @evento_tipo = EventoTipo.find(params[:id])
  end

  # POST /evento_tipos
  # POST /evento_tipos.xml
  def create
    @evento_tipo = EventoTipo.new(params[:evento_tipo])

    respond_to do |format|
      if @evento_tipo.save
        format.html { redirect_to(@evento_tipo, :notice => 'Evento tipo was successfully created.') }
        format.xml  { render :xml => @evento_tipo, :status => :created, :location => @evento_tipo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @evento_tipo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /evento_tipos/1
  # PUT /evento_tipos/1.xml
  def update
    @evento_tipo = EventoTipo.find(params[:id])

    respond_to do |format|
      if @evento_tipo.update_attributes(params[:evento_tipo])
        format.html { redirect_to(@evento_tipo, :notice => 'Evento tipo was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @evento_tipo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /evento_tipos/1
  # DELETE /evento_tipos/1.xml
  def destroy
    @evento_tipo = EventoTipo.find(params[:id])
    @evento_tipo.destroy

    respond_to do |format|
      format.html { redirect_to(evento_tipos_url) }
      format.xml  { head :ok }
    end
  end
end
