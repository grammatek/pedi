class Dictionary < ApplicationRecord
  validates :name, presence: true
  validates :sampa, presence: true
  after_save :import_csv

  has_many :entries, dependent: :nullify, autosave: true
  belongs_to :sampa

  has_one_attached :import_data
  validates :import_data, attached: true
  has_one_attached :export_data

  # Bulk import all entries as CSV
  def import_csv
    return if attachment_changes['import_data'].nil?

    all_entries = array_of_records
    Entry.insert_all all_entries
  end

  def array_of_records
    user_id = Current.user.id
    now = Time.current
    records = []
    phonemes = sampa.phonemes.split
    CSV.read(attachment_changes['import_data'].attachable,
             headers: true, col_sep: "\t").each do |record|
      records << extract_(record, user_id, now, phonemes)
    end
    records
  end

  def extract_(record, user_id, now, phonemes)
    {
       word: record[0],
       sampa: record[1] || '',
       pos: record[2],
       dialect: record[3] || 'all',
       is_compound: record[4] || false,
       comp_part: record[5] || 'none',
       prefix: record[6] || false,
       lang: record[7] || 'IS',
       finished: record[8] || false,
       comment: record[9] || '',
       user_id: user_id,
       dictionary_id: id,
       created_at: now,
       updated_at: now,
       warning: !sampa_correct?(record[1], phonemes)
    }
  end

  def sampa_correct?(sampa, phonemes)
    return false if sampa.nil?

    phonemes.size.positive? ? (sampa.split - phonemes).size.zero? : true
  end
end
