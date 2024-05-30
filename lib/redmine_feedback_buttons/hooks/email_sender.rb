# frozen_string_literal: true
require 'mail'

module RedmineFeedbackButtons
  module Hooks
    class EmailSender
      def self.send_feedback_email(issue_id, issue_subject, issue_author, issue_author_email, notes)
        puts "ENTÃO TOMA: #{issue_id} - #{issue_subject} - #{issue_author} - #{issue_author_email} - #{notes}"

        mail = Mail.new do
          from 'teste@despace.online'
          to issue_author_email
          subject "Feedback do chamado ##{issue_id} - #{issue_subject}"
          body "Olá #{issue_author},\n\nO chamado ##{issue_id} - #{issue_subject} foi finalizado.\n\nFeedback:\n#{notes}\n\nAtenciosamente,\n\nDespace"
        end

        mail.deliver!
      end
    end
  end
end
