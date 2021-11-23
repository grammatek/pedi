# frozen_string_literal: true

require 'test_helper'

class EntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    log_in_as(users(:usera), password: 'AGeheim')

    @entry = entries(:bera)
    @dictionary = Dictionary.find_by_name('Dict1')
    user = User.find_by_name('NameAA')
    @new_entry = Entry.new(word: 'bera2',
                           sampa: 'b E: r a 2',
                           comment: '',
                           user_id: user.id,
                           dictionary_id: @dictionary.id,
                           pos: 'none',
                           lang: 'IS',
                           is_compound: false,
                           comp_part: 'none',
                           prefix: false,
                           dialect: 'all')
    assert(@new_entry.valid?)
  end

  test 'should get index' do

    get dictionary_entries_url(@dictionary)
    assert_response :success
  end

  test 'should get new' do
    get new_dictionary_entry_url(@dictionary)
    assert_response :success
  end

  test 'should create entry' do
    assert_difference('Entry.count') do
      post dictionary_entries_url(@dictionary),
        params: {
          entry: {
            word: @new_entry.word,
            sampa: @new_entry.sampa,
            comment: @new_entry.comment,
            user_id: User.find_by_name('NameAA').id,
            dictionary_id: @dictionary.id,
            finished: false,
            warning: false,
            pos: @new_entry.pos,
            lang: @new_entry.lang,
            is_compound: @new_entry.is_compound,
            comp_part: @new_entry.comp_part,
            prefix: @new_entry.prefix,
            dialect: @new_entry.dialect,
          }
        }
    end

    assert_redirected_to dictionary_entry_url(@dictionary, Entry.last)
  end

  test 'should show entry' do
    get dictionary_entry_url(@dictionary, @entry)
    assert_response :success
  end

  test 'should get edit' do
    get edit_dictionary_entry_url(@dictionary, @entry)
    assert_response :success
  end

  test 'should update entry' do
    patch dictionary_entry_url(@dictionary, @entry),
          params: {
            entry: {
              word: 'bera2',
              sampa: 'b E: r a 2',
              comment: '',
              user_id: User.find_by_name('NameAA').id,
              dictionary_id: @dictionary.id,
              pos: 'none',
              lang: 'DE',
              is_compound: false,
              comp_part: 'none',
              prefix: false,
              dialect: 'all'
            }
          }
    assert_redirected_to dictionary_url(@dictionary)
  end

  test 'should destroy entry' do
    assert_difference('Entry.count', -1) do
      delete dictionary_entry_url(@dictionary, @entry)
    end

    assert_redirected_to dictionary_entries_url
  end
end
