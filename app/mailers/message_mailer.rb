class MessageMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.new_message_notification.subject
  #
  def new_message_notification
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
