# plugins/redmine_feedback_buttons/app/controllers/feedback_buttons_controller.rb
class FeedbackButtonsController < ApplicationController
  unloadable

  def create
    issue_id = params[:issue_id]
    response = params[:response]

   # api_response = nil
    #if response == 'Aprovar'
    #  api_response = send_feedback_to_external_api(issue_id, response)
    #end

    issue = Issue.find(issue_id)
    if response == 'Recusar'
      rejected_status = IssueStatus.find_by(name: 'Rejeitada') # ou o nome do status de rejeição
      issue.status = rejected_status
    end

   # if response == 'Aprovar' && api_response.present? && api_response.code.to_i == 200
    #  closed_status = IssueStatus.find_by(name: 'Fechada')
     # issue.status = closed_status
    #elsif response == 'Recusar'
     # rejected_status = IssueStatus.find_by(name: 'Rejeitada')
     # issue.status = rejected_status
   # end

    if api_response.code.to_i == 200
      render json: { success: true, message: 'Uma pesquisa de satisfação foi enviada para seu email.' }
    else
      render json: { success: false, message: 'Erro ao processar requisição.' }
    end
  rescue => e
    render json: { success: false, message: "Erro: #{e.message}" }
  end

  private

  def send_feedback_to_external_api(issue_id, response)
    uri = URI.parse('http://192.168.2.104/api/redmine')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
    request.body = { response: response, issue_id: issue_id }.to_json
    http.request(request)
  end
end
