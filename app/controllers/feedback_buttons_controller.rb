class FeedbackButtonsController < ApplicationController
  unloadable

  before_action :verify_authenticity_token, except: [:approve]

  def approve
    issue_id = params[:issue_id]
    issue = Issue.find(issue_id)
    @issue = issue
    @issue_id = issue_id

    closed_status = IssueStatus.find_by(name: 'Fechada')
    issue.status = closed_status

    if issue.save
      flash[:notice] = "Solução do chamado #@issue aprovada com sucesso! De seu feedback sobre o atendimento abaixo."
    end

    render 'feedback_buttons/approve'
  end
  def satisfaction
    rating = params[:rating]
    comment = params[:comment]
    issue_id = params[:issue_id]
    @issue = Issue.find(issue_id)

    flash[:notice] = "Nota: #{rating} Comentário: #{comment} issue_id: #{issue_id}"

    render 'feedback_buttons/approve' #necessário renderizar uma view
  end

  def decline
    @issue = Issue.find(params[:issue_id])
    # Lógica para recusa
    flash[:notice] = 'Solução recusada com sucesso!'
    redirect_to issue_path(@issue)
  end

  def create
    issue_id = params[:issue_id]
    response = params[:response]

    issue = Issue.find(issue_id)

    if response == 'Aprovar'
      # api_response = send_feedback_to_external_api(issue_id, response)
      # if api_response.is_a?(Net::HTTPSuccess)
      #   closed_status = IssueStatus.find_by(name: 'Fechada')
      #   issue.status = closed_status
      # end
      # Implementar logica de abrir pesquisa de satisfação
    elsif response == 'Recusar'
      rejected_status = IssueStatus.find_by(name: 'Rejeitada')
      issue.status = rejected_status
      if issue.save
        render json: { success: true, message: 'Chamado rejeitado com sucesso.' }
        return
      end
      # Implementar logica de incluir nota do usuário no chamado
    end

    if api_response.is_a?(Net::HTTPSuccess)
      #render json: { success: true, message: 'Uma pesquisa de satisfação foi enviada para seu email.' }
      
      closed_status = IssueStatus.find_by(name: 'Fechada')
      issue.status = closed_status
      render json: { success: true, message: "API Response: #{api_response}" }
    else
      render json: { success: false, message: "Erro ao processar requisição. Detalhes: #{api_response}" }
    end
  rescue => e
    render json: { success: false, message: "Erro: #{e.message}" }
  end

  private

  def send_feedback_to_external_api(issue_id, response)
    uri = URI.parse('http://192.168.2.106/api/redmine')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false

    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
    request.body = { response: response, issue_id: issue_id }.to_json
    request['Authorization'] = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjYwMzY'

    begin
      http_response = http.request(request)

      if http_response.is_a?(Net::HTTPSuccess)
        return http_response
      else
        # Log detalhes da resposta para ajudar no debug
        Rails.logger.error("HTTP Response Code: #{http_response.code}")
        Rails.logger.error("HTTP Response Body: #{http_response.body}")
        return http_response
      end
    rescue => e
      Rails.logger.error("Erro durante a requisição: #{e.message}")
      return e
    end
  end
end
