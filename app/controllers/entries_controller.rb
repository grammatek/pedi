class EntriesController < ApplicationController
  before_action :log_in
  before_action :set_entry, only: [:show, :edit, :update, :destroy, :finalize]

  # GET /entries
  # GET /entries.json
  def index
    if params[:dictionary_id]
      @dictionary = Dictionary.find(params[:dictionary_id])
      @entries = @dictionary.entries
    else
      @entries = Entry.all
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
  end

  # GET /entries/new
  def new
    @dictionary = Dictionary.find(params[:dictionary_id])
    @entry = Entry.new
    @url = dictionary_entries_path(@dictionary)
  end

  # GET /entries/1/edit
  def edit
    @url = dictionary_entry_path(@dictionary, @entry)
    @avail_pos = Entry.pos_available
    @avail_dialects = Entry.dialects_available
    @avail_comp_parts = Entry.compound_parts_available
    @avail_pos = Entry.pos_available
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(entry_params)
    @dictionary = Dictionary.find(params[:dictionary_id])
    respond_to do |format|
      if @entry.save
        format.html { redirect_to dictionary_entry_path(@dictionary, @entry), notice: 'Entry was successfully created.' }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entries/1
  # PATCH/PUT /entries/1.json
  def update
    respond_to do |format|
      # Policy: also update finished attribute to true if form was submitted
      if @entry.update(entry_params.merge({finished: true}))
        format.js { render partial: "update.js" }
        redir_url = cookies[:before_url].nil? ? dictionary_url(@dictionary): cookies[:before_url]
        format.html { redirect_to redir_url }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.js {}
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /entries/1/
  def finalize
    is_final = params["Correct"] || false
    respond_to do |format|
      if @entry.update({finished: is_final})
        format.js { head 200 }
      else
        flash[:warning] =  "Could not update value: #{@entry.errors.full_messages}"
        logger.warn "#{@entry.errors.full_messages}"
        redirect_to(dictionary_path(@dictionary)) and return
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to dictionary_entries_url(@dictionary), notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
      @dictionary = @entry.dictionary
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:word, :sampa, :comment, :user_id, :dictionary_id,
                                    :warning, :finished, :pos, :lang, :is_compound, :comp_part, :prefix, :dialect)
    end

  def log_in
    redirect_to help_path unless helpers.logged_in?
  end
end
