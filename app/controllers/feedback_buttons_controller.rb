class FeedbackButtonsController < ApplicationController
  unloadable

  before_action :verify_authenticity_token, except: [:approve]
  before_action :require_login

  def approve
    issue_id = params[:issue_id]
    issue = Issue.find(issue_id)
    relations = IssueRelation.where(issue_from_id: issue.id).first
    issue_relation = Issue.find(relations.issue_to_id)
    closed_status = IssueStatus.find_by(name: 'Fechada') #configurar status de chamado fechado
    rating_custom_field = IssueCustomField.find_by(name: 'Nota') #Nome do campo personalizado
    @issue = issue



    #valida se o chamado está encerrado e a pesquisa ainda não foi respondida
    if @issue.status_id == closed_status.id && @issue.custom_value_for(rating_custom_field.id).value.blank?
      flash[:notice] = "O chamado já foi aprovado mas seu feedback ainda não foi registrado."
      render 'feedback_buttons/approve' #Renderiza a view
      return
    end


    if @issue.status_id != closed_status.id
      issue.status = closed_status
      issue_relation.status = closed_status
      if issue.save && issue_relation.save
        flash[:notice] = "Solução do chamado: <strong>##{@issue.id} - #{@issue.subject}</strong> foi aprovada com sucesso! De seu feedback sobre o atendimento abaixo."
        render 'feedback_buttons/approve' #Renderiza a view
      end
    else
      flash[:error] = "Este chamado ja foi aprovado ou encerrado anteriormente."
      redirect_to issue_path(@issue)
    end
  end

  def satisfaction
    rating = params[:rating]
    comment = params[:comment]
    issue_id = params[:issue_id]
    @issue = Issue.find(issue_id)

    rating_custom_field = IssueCustomField.find_by(name: 'Nota') #Nome do campo personalizado
    comment_custom_field = IssueCustomField.find_by(name: 'Satisfação') #Nome do campo personalizado

    if @issue && rating_custom_field && comment_custom_field
      @issue.custom_field_values = {
        rating_custom_field.id => rating,
        comment_custom_field.id => comment
      }
    end

    if @issue.save!
      flash[:notice] = "Obrigado pelo feedback!"
    else
      flash[:error] = "Erro ao salvar feedback"
    end

    redirect_to issue_path(@issue)
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
