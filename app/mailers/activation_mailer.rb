class ActivationMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #
  def activation_needed_email user
    @user = user
    @url = activate_user_url(user.activation_token)
    mail(:to => user.email,
       :subject => "Welcome to FlightsApp")

  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  def activation_success_email user
    @user = user
    @url  = login_url
    mail(:to => user.email,
         :subject => "Your account is now activated")
  end
end
