# frozen_string_literal: true

class UsersController < ApplicationController
  def show #fix
    User.all
  end

  def create
    return unless params[:username]
    return unless params[:avatar]
    user = User.create(params[:username])
    user.avatar.attach(params[:avatar])
    user.save
  end
 
  private
    def user_params
      params.permit(:username, :avatar)
    end
end
