# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    log_in_as(users(:usera), password: 'AGeheim')
    @user = users(:userb)
    @new_user = User.new(name: 'ANewUser',
                         password: 'AGeheim',
                         password_digest: BCrypt::Password.create('AGeheim'),
                         email: 'newuser@domain.com')
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: { user: { email: @new_user.email,
                                        name: @new_user.name,
                                        password: @new_user.password } }
    end

    assert_redirected_to user_url(User.last)
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    patch user_url(@user),
          params: { user: { email: @new_user.email, name: @new_user.name,
                            password: @new_user.password } }
    assert_redirected_to user_url(@user)
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
