class ResetPasswordMailer < ActionMailer::Base
  default from: "from@example.com"
  def reset_password_email user
    @user = user
    @url = reset_password_user_url(user.reset_password_token)
    mail(:to => user.email,
         :subject => "Reset Your Fodder password")
  end
end
