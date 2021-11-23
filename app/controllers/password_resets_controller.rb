# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i[edit update]
  # before_action :valid_user, only: [:edit, :update]
  # before_action :check_expiration, only: [:edit, :update]

  def new; end

  def edit
    @user = current_user
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Sendi tölvupóst með upplýsingum til þess að breyta lykilorði'
      redirect_to root_url
    else
      flash.now[:danger] = 'Netfang fannst ekki!'
      render 'new'
    end
  end

  def update
    Rails.logger.debug '======================= Going for an update ... ======================='
    if params[:user][:password].empty?
      @user.errors.add(:password, 'ekkert lykilorð')
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = 'Lykilorð hefur verið uppfært'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    redirect_to root_url unless @user&.activated? && @user&.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password has expired, please create a new one'
    redirect_to new_password_reset_url
  end
end
