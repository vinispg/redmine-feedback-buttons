class Mailer < ActionMailer::Base
  default from: 'teste@despace.online'
  def feedback_email(user, issue, notes)
    Rails.logger.info "Feedback email - User: #{user.inspect}, Issue: #{issue.inspect}, Notes: #{notes.inspect}"

    @user = user
    @issue = issue
    @notes = notes

    #@approve_url = approve_url(issue_id: @issue.id)
    #@decline_url = decline_url(issue_id: @issue.id)

    mail(to: @user.mail, subject: "Feedback do chamado ##{@issue.id} - #{@issue.subject} #{@user.name}") do |format|
      format.html { render 'feedback_email' }  # Renderiza o template feedback_email.html.erb
      #format.text { render plain: "Olá #{@user.name},\n\nPor favor, dê seu feedback para o chamado ##{@issue.id} - #{@issue.subject}.\n\nNotas: #{@notes}\n\nVocê aprova a solução proposta?\n\nAprovar: #{@approve_url}\nRecusar: #{@decline_url}\n\nObrigado." }
    end
  end
end