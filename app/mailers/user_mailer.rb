class UserMailer < ActionMailer::Base
  default from: "Social Media Registry <socialmediaregistry@gsa.gov>"
  def emailnow(record)
  	@email = record
  	mail(:to => @email.to, :subject => @email.subject, :body => @email.body)
  end
end
