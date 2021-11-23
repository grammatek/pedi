# frozen_string_literal: true

require 'test_helper'

class DictionariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    log_in_as(users(:usera), password: 'AGeheim')
    Current.user = users(:usera)
    test_dict = Rails.root.join('sample-data/pron_dict_test.txt')
    @dictionary = dictionaries(:dict1)
    uf = ActionDispatch::Http::UploadedFile.new(filename: 'pron_dict_test.txt', type: 'text/plain',
                                                tempfile: test_dict)
    @dictionary.import_data.attach(uf)
    @sampa = sampas(:sampa1)
    assert_not_equal(@sampa, nil)
  end

  test 'should get index' do
    get dictionaries_url
    assert_response :success
  end

  test 'should get new' do
    get new_dictionary_url
    assert_response :success
  end

  test 'should create dictionary with sample CSV' do
    dict_name = 'NewDictInTest'
    csv_file = fixture_file_upload(Rails.root.join('sample-data/pedi_extended_test.csv'),
                                   'text/csv')
    assert_difference('Dictionary.count') do
      post dictionaries_url, params: { dictionary: { edited: @dictionary.edited,
                                                     name: dict_name,
                                                     sampa_id: @sampa.id,
                                                     import_data: csv_file } }
    end
    assert_redirected_to dictionary_url(Dictionary.last)
    dict = Dictionary.find_by_name(dict_name)
    assert_not_equal(dict, nil)
    assert_not_equal(dict.sampa, nil)
  end

  test 'should recreate dictionary with importing the exported dictionary' do
    dict_name = 'NewDictInTest'
    pedi_test_csv_path = Rails.root.join('sample-data/pedi_extended_test.csv')
    dict = Dictionary.find_by_name('Dict1')
    assert_not_equal(dict, nil)
    post export_dictionary_path(dict)

    csv_file = fixture_file_upload(pedi_test_csv_path, 'text/csv')
    assert_difference('Dictionary.count') do
      post dictionaries_url, params: { dictionary: { edited: @dictionary.edited,
                                                     name: dict_name,
                                                     sampa_id: @sampa.id,
                                                     import_data: csv_file } }
    end
    assert_redirected_to dictionary_url(Dictionary.last)
    dict = Dictionary.find_by_name(dict_name)
    assert_not_equal(dict, nil)
    assert_not_equal(dict.sampa, nil)
  end

  test 'should show dictionary' do
    get dictionary_url(@dictionary)
    assert_response :success
  end

  test 'should get edit' do
    get edit_dictionary_url(@dictionary)
    assert_response :success
  end

  test 'should update dictionary' do
    csv_file = fixture_file_upload(Rails.root.join('sample-data/pedi_extended_test.csv'),
                                   'text/csv')
    patch dictionary_url(@dictionary), params: {
      dictionary: { name: @dictionary.name, sampa_id: @sampa.id, import_data: csv_file }
    }
    assert_redirected_to dictionary_url(@dictionary)
  end

  test 'should not update dictionary without valid sampa' do
    patch dictionary_url(@dictionary),
          params: { dictionary: { name: @dictionary.name, sampa_id: nil } }
    assert_response(200)
  end

  test 'should destroy dictionary' do
    assert_difference('Dictionary.count', -1) do
      delete dictionary_url(@dictionary)
    end

    assert_redirected_to dictionaries_url
  end

  test 'Should strip whitespace attributes, when exporting as CSV' do
    post export_dictionary_url(@dictionary)
    assert_response(200)
  end
end
