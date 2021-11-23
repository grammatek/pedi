# frozen_string_literal: true

include ::SampasConcern

class Sampa < ApplicationRecord
  validates :name, presence: true
  validates :phonemes, presence: true
  validates_with SampaValidator

  before_validation :fill_phonemes

  has_one_attached :attachment
  has_many :dictionaries, dependent: :nullify

  def fill_phonemes
    return if attachment_changes['attachment'].nil?

    # XXX DS: this is a hack! Because of some undefined reason, we cannot access the uploaded
    # file _officially_ before the model is saved to DB. So we use the metadata available in
    # the depths of ActiveStorage to get this information indirectly and load the file into memory.
    # But how would it make sense, to make the transformation of the uploaded
    # data into a model attribute _after_ the validation phase of the model has already been run ?
    # Here ActiveStorage is really inflexible.
    content = File.read(attachment_changes['attachment'].attachable)

    # the phoneme lists are newline separated.
    # TODO: make a validation of the content and raise an appropriate error in case the minimal
    #       format cannot be found
    self.phonemes = content.split(/\n/).uniq.join(' ')
  end
end
