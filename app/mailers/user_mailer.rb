class UserMailer < ActionMailer::Base
  default from: "System@apprentice-doc-lab.de"
  def testmail(user)
    @user = user
    mail(:to => "IRGENDWAS@IRGENDWAS.DE",
      :subject => "It works!")

  end

  def password_recovery_mail(data)
    @user = data[:user]
    @password = data[:password]
    mail(:to => @user.email, :subject => "Apprentice Doc Lab: Dein neues Passwort")
  end 
  
  def password_verification_mail(data)
    @user = data[:user]
    @domain = data[:domain]
    mail(:to => @user.email, :subject => "Apprentice Doc Lab: Du hast dein Passwort vergessen?")
  end
 
  def unchecked_reports_mail(instructor)
    @user = instructor
    mail(:to => @user.email, :subject => "Apprentice Doc Lab: Sie haben noch vorgelegte Berichte, die nicht ueberprueft wurden")
  end 
end
