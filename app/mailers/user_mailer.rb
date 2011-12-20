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
    mail(:to => @user.email, :subject => "Apprentice Doc Lab: Sie haben noch " +  @unchecked_reports_num.to_s + " vorgelegte Berichte, die nicht ueberprueft wurden")
  end

  def unwritten_reports_mail(data)
    @user = data[:apprentice]
    @date_array = data[:date_array]
    mail(:to => @user.email, :subject => "TODO Ausgabe der Monate+Jahr, an denen ein Bericht fehlt")
  end
end
