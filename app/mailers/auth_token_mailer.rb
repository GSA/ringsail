class AuthTokenMailer < ActionMailer::Base
  default from: "info@measuredvoice.com"

  def token_link_email(auth_token, service_url=nil)
    @auth_token = auth_token
    @link_url = url_for(
      :controller  => 'outlets', 
      :action      => 'add',
      :only_path   => false, 
      :service_url => service_url,
      :auth_token  => @auth_token.token
    )
    
    if Rails.env.production?
      to_email = auth_token.email
    else
      to_email = ENV['EMAIL_BYPASS_USER']
    end
    
    mail(:to => to_email, :subject => "your Social Media Registry request")
  end
end
