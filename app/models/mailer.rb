# class Mailer < ActionMailer::Base
#   default from: 'teste@despace.online'
#   def feedback_email(issue_id, issue_subject, issue_project, issue_author, issue_author_email, notes)
#     @issue_id = issue_id
#     @issue_subject = issue_subject
#     @issue_project = issue_project
#     @issue_author = issue_author
#     @issue_author_email = issue_author_email
#     @notes = notes
#     puts "AAAaAAAAAaAAaaAAAAAaAAAAAAaAAAAAAA #{@issue_id} - #{@issue_subject} - #{@issue_project} - #{@issue_author} - #{@issue_author_email} - #{@notes}"
#     mail(to: issue_author.mail, subject: "Feedback do chamado ##{@issue_id} - #{@issue_subject}")
#   end
# end
class Mailer < ActionMailer::Base
  default from: 'teste@despace.online'

  def self.deliver_feedback_email(user, issue, notes)

    puts "HUASUSAHUHSAUHSAUASH USER: #{user} - ISSUE: #{issue} - NOTES: #{notes}"
    logger = Logger.new(STDERR)
    logger.error "Erro: Deu pau!!!! USER: #{user} - ISSUE: #{issue} - NOTES: #{notes}"

    feedback_email(user, issue, notes).deliver_now
  end
  def feedback_email(user, issue, notes)
    @user = user
    @issue = issue
    @notes = notes

    view = ActionView::Base.new('app/views/mailer', assigns: { user: user, issue: issue, notes: notes })
    content = view.render 'feedback_email.text.erb'

    puts "HAHAHAHAAHAHAAHAHAHAHAHAAHHA USER: #{user} - ISSUE: #{issue} - NOTES: #{notes}"
    mail(to: user.mail, subject: "Feedback do chamado ##{@issue.id} - #{@issue.subject} #{@user.name}", body: content)
  end
end