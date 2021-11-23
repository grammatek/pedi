# frozen_string_literal: true

require 'test_helper'

class SampaTest < ActiveSupport::TestCase
  test 'validity of sampa' do
    sampa = Sampa.new(name: 'sampa2', phonemes: 'a ab abc')
    assert sampa.valid?
  end

  test 'validity of sampa with associated dictionary' do
    sampa = Sampa.new(name: 'sampa2', phonemes: 'a ab abc', dictionary_id: dictionaries('dict1').id)
    assert sampa.valid?
  end

  test 'invalidity of invalid sampa' do
    sampa = Sampa.new(name: 'sampa2', phonemes: 'abcd ab abc :_8')
    assert_not sampa.valid?, 'expect validation to fail, but didnt'
    assert_not_nil sampa.errors[:phonemes], "contain invalid characters\n"
  end
end
