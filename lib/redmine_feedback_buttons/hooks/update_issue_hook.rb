#NAO FUNCIONA - DELETAR ESSE LIXO
module RedmineFeedbackButtons
  module Hooks
    class UpdateIssueHook
      def controller_issues_edit_after_save(context={})
        issue = context[:issue]
        status_id = context[:params][:issue][:status_id]
        notes = context[:params][:issue][:notes]

        if status_id.to_i == 4 # id do status 'Aguardando Feedback'
          issue_id = issue.id
          issue_subject = issue.subject
          issue_project = issue.project.name
          issue_author = issue.author.name
          issue_author_email = issue.author.mail

          puts "HUASUSAHUHSAUHSAUASH #{issue_id} - #{issue_subject} - #{issue_project} - #{issue_author} - #{issue_author_email} - #{notes}"
          logger = Logger.new(STDERR)
          logger.error "Erro: Deu pau!!!!"

          #RedmineFeedbackButtons::EmailSender.send_feedback_email(issue_id, issue_subject, issue_project, issue_author, issue_author_email, notes)
          Mailer.feedback_email(issue_id, issue_subject, issue_project, issue_author, issue_author_email, notes).deliver
        end
      end

    end
  end
end
