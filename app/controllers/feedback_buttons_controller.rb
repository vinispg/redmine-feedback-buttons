class FeedbackButtonsController < ApplicationController
  unloadable

  before_action :verify_authenticity_token, except: [:approve]
  before_action :require_login
  #11 Fechado
  def approve
    issue_id = params[:issue_id]
    issue = Issue.find(issue_id)
    relations = IssueRelation.where(issue_from_id: issue.id).first
    closed_status = IssueStatus.find_by(id: 11) # Id status encerrado
    rating_custom_field = IssueCustomField.find_by(id: 1) # id do campo personalizado 'NOTA'
    @issue = issue

    if @issue.author_id != User.current.id
      flash[:error] = "Somente o autor do chamado pode aprova-lo."
      redirect_to issue_path(@issue)
      return
    end

    # Valida se o chamado está encerrado e a pesquisa ainda não foi respondida
    if @issue.status_id == closed_status.id && @issue.custom_value_for(rating_custom_field.id).value.blank?
      flash[:notice] = "O chamado já foi aprovado mas seu feedback ainda não foi registrado."
      render 'feedback_buttons/approve' # Renderiza a view
      return
    end

    if @issue.status_id != closed_status.id
      issue.status = closed_status

      if relations.present?
        issue_relation = Issue.find(relations.issue_to_id)
        issue_relation.status = closed_status
      end

      if issue.save && (relations.nil? || issue_relation.save)
        flash[:notice] = "Solução do chamado: <strong>##{@issue.id} - #{@issue.subject}</strong> foi aprovada com sucesso! De seu feedback sobre o atendimento abaixo."
        render 'feedback_buttons/approve' # Renderiza a view
      else
        flash[:error] = "Houve um problema ao salvar o status do chamado."
        redirect_to issue_path(@issue)
      end
    else
      flash[:error] = "Este chamado já foi aprovado ou encerrado anteriormente."
      redirect_to issue_path(@issue)
    end
  end


  def satisfaction
    rating = params[:rating]
    comment = params[:comment]
    issue_id = params[:issue_id]
    @issue = Issue.find(issue_id)

    rating_custom_field = IssueCustomField.find_by(id: 1) #Id do campo personalizado NOTA
    comment_custom_field = IssueCustomField.find_by(id: 2) #Id do campo personalizado Satisfação

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

  def declined
    issue_id = params[:issue_id]
    issue = Issue.find(issue_id)
    relations = IssueRelation.where(issue_from_id: issue.id).first
    refused_status = IssueStatus.find_by(id: 12) #configurar status de chamado rejeitado

    if relations.present?
      issue_relation = Issue.find(relations.issue_to_id)
      assigned_to = User.find(issue_relation.assigned_to_id)

      last_comment = Journal
                       .where(journalized_id: issue.id, user_id: assigned_to.id, journalized_type: 'Issue')
                       .where.not(notes: [nil, ''])
                       .order(created_on: :desc).first

      @assigned_to = assigned_to
      @last_comment = last_comment
    end

    @issue = issue

    if @issue.author_id != User.current.id
      flash[:error] = "Somente o autor do chamado pode recusa-lo."
      redirect_to issue_path(@issue)
      return
    end

    if @issue.status_id != refused_status.id
      render 'feedback_buttons/declined'
    else
      flash[:error] = "Este chamado já foi recusado anteriormente."
      redirect_to issue_path(@issue)
    end
  end

  def submit_refusal
    issue_id = params[:issue_id]
    refusal_comment = params[:refusal_comment]
    issue = Issue.find(issue_id)
    relations = IssueRelation.where(issue_from_id: issue.id).first
    rejected_status = IssueStatus.find_by(id: 12) #configurar status de chamado rejeitado
    @issue = issue

    if relations.present?
      issue_relation = Issue.find(relations.issue_to_id)
    end

    if @issue.status_id != rejected_status.id
      issue.status = rejected_status

      if relations.present?
        issue_relation.status = rejected_status
      end

      journal = issue.journals.build(
        notes: refusal_comment,
        user_id: issue.author_id
      )

      if issue.save && (relations.nil? || issue_relation.save) && journal.save
        flash[:notice] = "Solução do chamado: <strong>##{issue.id} - #{issue.subject}</strong> foi recusada."
        redirect_to issue_path(@issue)
      else
        flash[:error] = "Houve um problema ao salvar o status do chamado."
        redirect_to issue_path(@issue)
      end
    else
      flash[:error] = "Este chamado já foi recusado anteriormente."
      redirect_to issue_path(@issue)
    end
  end

  def show_issue
    @issue = Issue.find(params[:issue_id])

    redirect_to issue_path(@issue)
  end
end
