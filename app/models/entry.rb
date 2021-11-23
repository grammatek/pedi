# frozen_string_literal: true

class Entry < ApplicationRecord
  include ::EntryConcern

  belongs_to :dictionary
  belongs_to :user, default: -> { Current.user }

  scope :ordered, -> { order(word: :asc) }
  scope :with_word, ->(pattern) { where('word like  ?', pattern) }
  scope :with_sampa, ->(pattern) { where('sampa like  ?', pattern) }
  scope :with_comment, ->(pattern) { where('comment like  ?', pattern) }
  scope :with_warning, -> { where(warning: true) }
  scope :version_eq, ->(version) { joins(:dictionary).where('dictionaries.version = ?', version) }

  validates :word, presence: true
  validates :lang, inclusion: { in: ISO3166::Country.codes,
                                message: '(%{value}) is not a valid ISO3166 country code' }
  validates :pos, inclusion: { in: pos_available,
                               message: '(%{value}) is not a supported PoS tag' }
  validates :dialect, inclusion: { in: dialects_available,
                                   message: '(%{value}) is not a supported pronunciation variant' }
  validates :comp_part, inclusion: { in: compound_parts_available,
                                     message: '(%{value}) is not a supported compound part' }
  before_save :strip_whitespace, :update_warning

  # add validation: unique per dictionary ...

  # Returns if sampa is correct according to given phoneme list
  def sampa_correct?(phonemes)
    return false if sampa.nil?

    (sampa.split.uniq - phonemes).empty?
  end

  # Validates, if given PoS (Part of Speech) tag is supported
  def pos_supported?(pos)
    pos_available.include?(pos)
  end

  # Validates, if given dialect is supported
  def dialect_supported?(dialect)
    dialects_available.include?(dialect)
  end

  # Validates, if given compound part is supported
  def comp_part_supported?(comp_part)
    compound_parts_available.include?(comp_part)
  end

  private

  def update_warning
    return unless dictionary.sampa

    phonemes = dictionary.sampa.phonemes.split
    self.warning = !sampa_correct?(phonemes)
  end

  # Strips leading/trailing whitespace from attributes
  #   - word
  #   - sampa
  #   - comment
  def strip_whitespace
    self.word = word.strip unless word.nil?
    self.sampa = sampa.strip unless sampa.nil?
    self.comment = comment.strip unless comment.nil?
  end
end
