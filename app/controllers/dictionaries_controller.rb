class DictionariesController < ApplicationController
  before_action :set_current_user
  before_action :set_dictionary, only: %i[show edit update destroy export]

  # GET /dictionaries
  # GET /dictionaries.json
  def index
    redirect_to help_path unless helpers.logged_in?
    @dictionaries = Dictionary.all
    # TODO: sort by name ? If we hide sortable metadata per dictionary in the views html,
    #       the frontend can make the sorting itself, as this view so far is not paginated
  end

  # GET /dictionaries/1
  # GET /dictionaries/1.json
  def show
    @word = params[:word] || '%'
    @sampa = params[:sampa] || '%'
    @comment = params[:comment] || '%'
    @only_warnings = params[:only_warnings] || false

    @sel_entries = @dictionary.entries.with_word(@word).with_sampa(@sampa)
                              .with_comment(@comment).ordered
    @sel_entries = @sel_entries.with_warning if @only_warnings

    @pagy, @entries = pagy(@sel_entries, count: @sel_entries.count)
    @entry_count = @dictionary.entries.size
    cookies[:dictionary_page] = @pagy.vars[:page]
  end

  # GET /dictionaries/new
  def new
    @dictionary = Dictionary.new
  end

  # GET /dictionaries/1/edit
  def edit; end

  # POST /dictionaries
  # POST /dictionaries.json
  def create
    @dictionary = Dictionary.new(dictionary_params)

    respond_to do |format|
      if @dictionary.save
        format.html { redirect_to @dictionary, notice: 'Dictionary was successfully created.' }
        format.json { render :show, status: :created, location: @dictionary }
      else
        format.html { render :new }
        format.json { render json: @dictionary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dictionaries/1
  # PATCH/PUT /dictionaries/1.json
  def update
    respond_to do |format|
      p = dictionary_params
      sampa = Sampa.find_by_id(p[:sampa_id])
      p[:sampa] = sampa
      if @dictionary.update(p.except(:sampa_id))
        format.html { redirect_to @dictionary }
        format.json { render :show, status: :ok, location: @dictionary }
      else
        format.html { render :edit }
        format.json { render json: @dictionary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dictionaries/1
  # DELETE /dictionaries/1.json
  def destroy
    @dictionary.destroy
    respond_to do |format|
      format.html { redirect_to dictionaries_url, notice: 'Dictionary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Exports dictionary as CSV file
  def export
    all_entries = @dictionary.entries.all.load
    respond_to do |format|
      format.html { send_data gen_as_csv(all_entries), filename: "#{@dictionary.name}.csv" }
      format.json { head :no_content }
    end
  end

  # Exports multiple dictionaries as CSV file
  def export_multiple
    dictionary_ids = params[:dictionary_ids]
    unless dictionary_ids
      respond_to do |format|
        format.html { redirect_to dictionaries_url, notice: 'No Dictionary was selected' }
        format.json { head :no_content }
        return
      end
    end
    @dictionaries = Dictionary.find(dictionary_ids)

    all_entries = @dictionaries.each_with_object([]) do |dict, obj|
      obj.concat dict.entries.all.load
    end
    respond_to do |format|
      format.html do
        send_data gen_as_csv(all_entries), filename: "dictionaries_#{dictionary_ids.join('_')}.csv"
      end
      format.json { head :no_content }
      format.js { render inline: 'location.reload();' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dictionary
    @dictionary = Dictionary.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dictionary_params
    params.require(:dictionary).permit(:name, :edited, :sampa_id, :dictionary_id,
                                       :import_data, :word, :sampa, :comment, :only_warnings,
                                       :is_final, :locale)
  end

  def gen_as_csv(entries)
    CSV.generate('', headers: true, col_sep: "\t") do |csv|
      csv << %w[WORD SAMPA POS PRON_VARIANT IS_COMPOUND COMPOUND_ATTR HAS_PREFIX LANG IS_VALIDATED COMMENT]
      entries.each do |e|
        is_validated = e.finished && !e.warning || false
        csv << [e.word.strip, e.sampa.strip, e.pos, e.dialect, e.is_compound, e.comp_part,
                e.prefix, e.lang, is_validated, e.comment.strip]
      end
    end
  end

  def set_current_user
    redirect_to help_path unless helpers.logged_in?
    Current.user = helpers.current_user
  end
end
