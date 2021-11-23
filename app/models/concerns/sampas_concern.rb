# frozen_string_literal: true

module SampasConcern
  class SampaValidator < ActiveModel::Validator
    def validate(record)
      record.phonemes&.split&.each do |phoneme|
        unless /^[a-z:_09]{1,3}$/i.match?(phoneme)
          record.errors.add(:phonemes, 'contain invalid characters')
        end
      end
    end
  end
end

