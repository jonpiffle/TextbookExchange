class MessageMailer < ActionMailer::Base
  default from: "donotreply@textbookexchange.herokuapp.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.new_message_notification.subject
  #
  def new_message_notification(message)
    @message = message
    @user = message.receiver
    @sender = message.sender

    mail(to: @user.email, subject: 'TextbookExchange message received!')
  end
end
