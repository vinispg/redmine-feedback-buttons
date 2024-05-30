require 'redmine'
#require_dependency 'mailer'

Redmine::Plugin.register :redmine_feedback_buttons do
  name 'Pesquisa de satisfação'
  author 'Vinicios Spigiorin'
  description 'Este plugin adiciona requisição para API externa a partir de botões nos chamados'
  version '0.0.1'
end

# Hook para adicionar o botão na view dos chamados
require File.expand_path('lib/redmine_feedback_buttons/hooks/view_issues_show_details_bottom_hook', __dir__)
#require_relative 'lib/redmine_feedback_buttons/hooks/email_sender'
require File.expand_path('app/models/mailer', __dir__)
require File.expand_path('lib/redmine_feedback_buttons/hooks/update_issue_hook', __dir__)

