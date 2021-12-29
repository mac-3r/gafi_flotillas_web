class ApplicationMailer < ActionMailer::Base
  
  default from: 'no_replay_flotillas@gafi.com.mx'
  layout 'mailer'

  ERRORS_TO_RESCUE = [
    Net::SMTPAuthenticationError,
    Net::SMTPServerBusy,
    Net::SMTPSyntaxError,
    Net::SMTPFatalError,
    Net::SMTPUnknownError,
    Errno::ECONNREFUSED,
    OpenSSL::SSL::SSLError
  ]

  rescue_from *ERRORS_TO_RESCUE do |exception|
    # Handle it here
    Rails.logger.error(exception)
    puts "--------------------************** #{exception}"
  end

end
