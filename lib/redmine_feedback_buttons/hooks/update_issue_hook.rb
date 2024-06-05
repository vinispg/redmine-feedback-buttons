module RedmineFeedbackButtons
  module Hooks
    class UpdateIssueHook < Redmine::Hook::ViewListener
      def controller_issues_edit_after_save(context={})
        issue = context[:issue]
        status_id = context[:params][:issue][:status_id]
        notes = context[:params][:issue][:notes]
        user = issue.author

        #definir o id do projeto para enviar o email somente quando for Chamado
        if status_id.to_i == 4 && issue.project_id == 1 # id do status 'Aguardando Feedback' -> Configurar
          Rails.logger.info "Status ID: #{status_id}, Enviando e-mail para #{issue.author.mail}"
          Mailer.feedback_email(user, issue, notes).deliver_now
        end
      end
    end
  end
end
