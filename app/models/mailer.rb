class Mailer < ActionMailer::Base
  def feedback_email(issue_id, issue_subject, issue_project, issue_author, issue_author_email, notes)
    @issue_id = issue_id
    @issue_subject = issue_subject
    @issue_project = issue_project
    @issue_author = issue_author
    @issue_author_email = issue_author_email
    @notes = notes
    puts "AAAaAAAAAaAAaaAAAAAaAAAAAAaAAAAAAA #{@issue_id} - #{@issue_subject} - #{@issue_project} - #{@issue_author} - #{@issue_author_email} - #{@notes}"
    mail(to: issue_author.mail, subject: "Feedback do chamado ##{@issue_id} - #{@issue_subject}")
  end
end