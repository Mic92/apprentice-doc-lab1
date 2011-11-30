class PasswordRecoveryController < ApplicationController
  def new
  end
  
  def create
    if !params[:password_recovery][:email].nil? 
      @user = User.find_by_email(params[:password_recovery][:email])
      if @user.nil?
        # Tu nix
      else
        UserMailer.password_recovery_mail(@user).deliver
      end
    end  
    redirect_to root_path, :notice => 'Email wurde versendet, falls User existiert.'
  end
end
