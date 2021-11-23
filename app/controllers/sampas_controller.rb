# frozen_string_literal: true

class SampasController < ApplicationController
  before_action :log_in
  before_action :set_sampa, only: %i[show destroy]

  # GET /sampas
  # GET /sampas.json
  def index
    @sampas = Sampa.all
  end

  # GET /sampas/1
  # GET /sampas/1.json
  def show; end

  # GET /sampas/new
  def new
    @sampa = Sampa.new
  end

  def destroy
    @sampa.destroy
    flash[:success] = 'SAMPA entry has been deleted'
    redirect_to request.referer || root_url
  end

  # POST /sampas
  # POST /sampas.json
  def create
    @sampa = Sampa.new(sampa_params)
    respond_to do |format|
      if @sampa.save
        format.html { redirect_to sampas_url, notice: 'SAMPA was successfully created.' }
        format.json { render :show, status: :created, location: @sampa }
      else
        format.html { render :new }
        format.json { render json: @sampa.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sampa
    @sampa = Sampa.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sampa_params
    params.require(:sampa).permit(:name, :attachment, :dictionary)
  end

  def log_in
    redirect_to help_path unless helpers.logged_in?
  end
end
