# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    users = User.select(:avatar, :id, :username).map {|user| user_filter(user)}
    render json: users, status: :ok
  end

  def create
    errors = []
    errors << 'Avatar can\'t be blank' unless params[:user][:avatar].present?
    errors << 'Username can\'t be blank' unless params[:user][:username].present?
    
    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity
      return
    end

    user = User.new
    user.username = params[:user][:username]
    user.avatar.attach(params[:user][:avatar])
    begin
      user.save!
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors[:avatar] }, status: :unprocessable_entity
      return
    end

    render json: user_filter(user), status: :created
  end

  private

  def user_filter user
    { avatar: user.avatar.blob.filename, id: user.id, username: user.username }
  end
end
