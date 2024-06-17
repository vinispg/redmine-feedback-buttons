class Mailer < ActionMailer::Base
  default from: 'redmine@unochapeco.edu.br'
  def feedback_email(user, issue, notes)
    @user = user
    @issue = issue
    @notes = notes

    mail(to: @user.mail, subject: "Feedback do chamado ##{@issue.id} - #{@issue.subject} #{@user.name}") do |format|
      format.html { render 'feedback_email' }  # Renderiza o template feedback_email.html.erb
    end
    Rails.logger.info "Email enviado para #{@user.mail}" #Debug
  end
end