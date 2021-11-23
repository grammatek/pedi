require 'csv'

module DictionariesHelper
  # Returns if given entry's SAMPA is correct according to the Sampa associated to the dictionary
  # In case there is no such association, returns always true
  def sampa_correct?(entry)
    if @dictionary.sampa.nil?
      true
    else
      all_phonemes = @dictionary.sampa.phonemes.split
      entry_phonemes = entry.sampa.split
      (entry_phonemes.uniq - all_phonemes).empty?
    end
  end
end
