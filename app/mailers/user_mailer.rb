# coding: UTF-8
class UserMailer < ActionMailer::Base
  default from: "System@apprentice-doc-lab.de"
  def testmail(user)
    @user = user
    mail(:to => "IRGENDWAS@IRGENDWAS.DE",
      :subject => "It works!")

  end
  
  def welcome_mail(user, password)
    @user = user
    @password = password
    mail(:to => @user.email, :subject => "Apprentice Doc Lab: Dein neuer Account")
  end
  
  def password_recovery_mail(user, password)
    @user = user
    @password = password
    mail(:to => @user.email, :subject => "Apprentice Doc Lab: Dein neues Passwort")
  end

  def password_verification_mail(data)
    @user = data[:user]
    @domain = data[:domain]
    mail(:to => @user.email, :subject => "Apprentice Doc Lab: Du hast dein Passwort vergessen?")
  end

  def unchecked_reports_mail(data)
    @user = data[:instructor]
    @unchecked_reports_num = data[:unchecked_reports_num]
    mail(:to => @user.email, :subject => "Apprentice Doc Lab: zu prüfende Berichte")
  end

  def unwritten_reports_mail(data)
    @user = data[:apprentice]
    @date_array = data[:date_array]
    #@buffer = ''
    #@date_array.each do |year_month|
    #  @buffer += year_month[0].to_s + ' - ' + year_month[1] + "\n"
    #end
    mail(:to => @user.email, :subject => "Apprentice Doc Lab: fehlende Berichte")
  end

  def unset_trainingsbegin_mail(data)
    @user = data[:user]
    mail(:to => @user.email, :subject => "Apprentice Doc Lab: Bitte Ausbildungsbeginn vervolständigen")
  end
end
