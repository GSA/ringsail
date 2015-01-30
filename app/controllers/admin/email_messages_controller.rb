class Admin::EmailMessagesController < Admin::AdminController

	def new
		param1 = params[:param1]
		@emails = [current_user.email]
		@emails << param1
		@email = EmailMessage.new(to: @emails.map(&:to_s).join(', '))
	end

	def create
		@email = EmailMessage.new(email_message_params)
		@email.current_user_id = current_user.id
		if @email.save
			flash[:notice] = "Email successfully sent!"
			EmailJob.perform_later @email
			redirect_to admin_users_path
		else
			render "new"
		end
	end	


	private 

		def set_email_message
			@email = EmailMessage.find(params[:id])
		end

		def email_message_params 
			params.require(:email_message).permit(:to, :subject, :body)
		end

end
