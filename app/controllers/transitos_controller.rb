require 'polyline_decoder'

class TransitosController < ApplicationController
  
  DIST_LAT = 0.01
  DIST_LONG = 0.01
  MIN_REPORTADO = 0
  
  # GET /transitos
  # GET /transitos.xml
  def index
    lat = params[:latitude].to_f
    long = params[:longitude].to_f
    delta_lat = params[:delta_latitude].to_f + DIST_LAT
    delta_long = params[:delta_longitude].to_f + DIST_LONG
    lat_min = (lat - delta_lat)
    lat_max = (lat + delta_lat)
    long_min = (long - delta_long)
    long_max = (long + delta_long)
    if !lat.zero? || !long.zero?
      @transitos = Transito.where("ativo = 1 AND reportado >= ? AND ((latitude_ponto1 BETWEEN ? AND ? AND longitude_ponto1 BETWEEN ? AND ?) OR (latitude_ponto2 BETWEEN ? AND ? AND longitude_ponto2 BETWEEN ? AND ?))", MIN_REPORTADO, lat_min, lat_max, long_min, long_max, lat_min, lat_max, long_min, long_max)
    else
      @transitos = Transito.all
    end
    
    @transitos.each do |transito|
      transito.polyline = ActiveSupport::JSON.decode(transito.polyline)
      transito.intensidade = transito.intensidade.round
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transitos }
      format.json { render :json => @transitos, :only => [:polyline, :intensidade] }
    end
  end

  # GET /transitos/1
  # GET /transitos/1.xml
  def show
    @transito = Transito.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transito }
    end
  end

  # GET /transitos/new
  # GET /transitos/new.xml
  def new
    @transito = Transito.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transito }
    end
  end

  # GET /transitos/1/edit
  def edit
    @transito = Transito.find(params[:id])
  end

  # POST /transitos
  # POST /transitos.xml
  def create
    @transito = Transito.new(params[:transito])

    respond_to do |format|
      if @transito.save
        format.html { redirect_to(@transito, :notice => 'Transito was successfully created.') }
        format.xml  { render :xml => @transito, :status => :created, :location => @transito }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transito.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transitos/1
  # PUT /transitos/1.xml
  def update
    @transito = Transito.find(params[:id])

    respond_to do |format|
      if @transito.update_attributes(params[:transito])
        format.html { redirect_to(@transito, :notice => 'Transito was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transito.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transitos/1
  # DELETE /transitos/1.xml
  def destroy
    @transito = Transito.find(params[:id])
    @transito.destroy

    respond_to do |format|
      format.html { redirect_to(transitos_url) }
      format.xml  { head :ok }
    end
  end
  
end
