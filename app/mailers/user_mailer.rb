class UserMailer < ActionMailer::Base
  default from: "System@apprentice-doc-lab.de"
  def testmail(user)
    @user = user
    mail(:to => "IRGENDWAS@IRGENDWAS.DE",
      :subject => "It works!")
   
  end
  
  def password_recovery_mail(user)
    @user = user
    mail(:to => @user.email, :subject => "Apprentice Doc Lab: Dein vergessenes Passwort") 
  end
end
