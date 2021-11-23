require 'application_system_test_case'

class DictionariesTest < ApplicationSystemTestCase
  setup do
    @dictionary = dictionaries(:dict1)
    @user = users(:userc)
    puts @user.inspect
    login_as(@user)
  end

  def login_as(user)
    visit login_url
    fill_in 'EMail', with: user.email
    fill_in 'Password', with: user.password
    print page.html

    click_button 'Login'
  end

  test 'visiting the index' do
    visit dictionaries_url
    assert_selector 'h2', text: 'Dictionaries'
  end

  test 'creating a Dictionary' do
    visit dictionaries_url
    click_on 'New Dictionary'

    fill_in 'Edited', with: @dictionary.edited
    fill_in 'Name', with: @dictionary.name
    click_on 'Create Dictionary'

    assert_text 'Dictionary was successfully created'
    click_on 'Back'
  end

  test 'updating a Dictionary' do
    visit dictionaries_url
    click_on 'Edit', match: :first

    fill_in 'Edited', with: @dictionary.edited
    fill_in 'Name', with: @dictionary.name
    click_on 'Update Dictionary'

    assert_text 'Dictionary was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Dictionary' do
    visit dictionaries_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Dictionary was successfully destroyed'
  end
end
