module RedmineFeedbackButtons
  module Hooks
    class UpdateIssueHook < Redmine::Hook::ViewListener

      AGUARDANDO_FEEDBACK = 29
      PROJETO_CHAMADOS = 26
      def controller_issues_edit_after_save(context={})
        issue = context[:issue]
        status_id = context[:params][:issue][:status_id]
        notes = context[:params][:issue][:notes]
        user = issue.author

        #Dispara o email se o chamado estiver no status de aguardando feedback e for do projeto de chamados
        if status_id.to_i == AGUARDANDO_FEEDBACK && issue.project_id == PROJETO_CHAMADOS
          Rails.logger.info "Status ID: #{status_id}, Enviando e-mail para #{user.mail}"
          Mailer.feedback_email(user, issue, notes).deliver_now
        end
      end
    end
  end
end
