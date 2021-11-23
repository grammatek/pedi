# frozen_string_literal: true

require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  test 'validity of entry' do
    entry = entries('afstrakts')
    dict = entry.dictionary
    phonemes = dict.sampa.phonemes.split
    assert entry.sampa_correct?(phonemes)
    assert entry.valid?
  end

  test 'Some attributes shall not be saved with leading/trailing whitespace' do
    entry = entries('afstrakts')
    spacy_sampa = " #{entry.sampa} "
    spacy_word = " #{entry.word} "
    spacy_comment = " #{entry.comment} "
    entry.sampa = spacy_sampa
    entry.word = spacy_word
    entry.comment = spacy_comment
    entry.save

    entry2 = entries('afstrakts')
    assert_not_equal(entry2.sampa, spacy_sampa)
    assert_not_equal(entry2.word, spacy_word)
    assert_not_equal(entry2.comment, spacy_comment)
    assert_equal(entry2.sampa, spacy_sampa.strip)
    assert_equal(entry2.word, spacy_word.strip)
    assert_equal(entry2.comment, spacy_comment.strip)
  end

  test 'Lang should be changeable from IS to GB' do
    entry = entries('afstrakts')
    entry.lang = 'GB'
    assert entry.valid?
  end

  test 'Lang should be no changeable from IS to invalid ISO3166 country code EN' do
    entry = entries('afstrakts')
    entry.lang = 'EN'
    assert_not entry.valid?
  end
end
