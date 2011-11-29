class UserMailer < ActionMailer::Base
  default from: "System@apprentice-doc-lab.de"
  def testmail(user)
    @user = user
    mail(:to => "IRGENDWAS@IRGENDWAS.DE",
      :subject => "It works!")
   
  end
end
