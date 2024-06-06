class Mailer < ActionMailer::Base
  default from: 'redmine@despace.online'
  def feedback_email(user, issue, notes)
    Rails.logger.info "Feedback email - User: #{user.inspect}, Issue: #{issue.inspect}, Notes: #{notes.inspect}"

    @user = user
    @issue = issue
    @notes = notes

    mail(to: @user.mail, subject: "Feedback do chamado ##{@issue.id} - #{@issue.subject} #{@user.name}") do |format|
      format.html { render 'feedback_email' }  # Renderiza o template feedback_email.html.erb
    end
  end
end