# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    users = User.select(:avatar, :id, :username)
    users = users.map {|user| {avatar: user.avatar.blob.filename, id: user.id, username: user.username}}
    render json: users, status: :ok
  end

  def create
    unless params[:user][:avatar].present?
      render json: { errors: ['Avatar can\'t be blank'] }, status: :unprocessable_entity
      return
    end
    unless params[:user][:username].present?
      render json: { errors: ['Username can\'t be blank'] }, status: :unprocessable_entity
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

    render json: { avatar: user.avatar.blob.filename, id: user.id, username: user.username }, status: :created
  end
end
