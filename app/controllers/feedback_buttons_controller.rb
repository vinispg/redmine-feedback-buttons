class FeedbackButtonsController < ApplicationController
    unloadable
  
    def create
      issue_id = params[:issue_id]
      response = params[:response]
  
      # Chamada à API externa aqui
      uri = URI.parse('https://endpoint-externo.com/api/feedback')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
      request.body = { response: response, issue_id: issue_id }.to_json
  
      response = http.request(request)
  
      if response.code.to_i == 200
        flash[:notice] = 'Feedback enviado com sucesso.'
      else
        flash[:error] = 'Erro ao enviar feedback.'
      end
  
      redirect_to issue_path(issue_id)
    end
  end
  