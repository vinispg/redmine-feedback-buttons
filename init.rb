require 'redmine'

Redmine::Plugin.register :redmine_feedback_buttons do
  name 'Pesquisa de satisfação'
  author 'Vinicios Spigiorin'
  description 'Este plugin adiciona pesquisa de satisfação e encerramento automatizado dos chamados'
  version '1.0.0'
end

# Hook para adicionar o botão na view dos chamados
require File.expand_path('lib/redmine_feedback_buttons/hooks/view_issues_show_details_bottom_hook', __dir__)
require File.expand_path('lib/redmine_feedback_buttons/hooks/update_issue_hook', __dir__)
require_relative 'app/models/mailer'
require_dependency 'mailer'


