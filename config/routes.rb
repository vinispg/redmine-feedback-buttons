RedmineApp::Application.routes.draw do
    post 'feedback_buttons', to: 'feedback_buttons#create'
    post 'feedback_buttons/satisfaction', to: 'feedback_buttons#satisfaction'
    post 'feedback_buttons/submit_refusal', to: 'feedback_buttons#submit_refusal'

    get 'feedback_buttons/approve', to: 'feedback_buttons#approve', as: 'approve'
    get 'feedback_buttons/declined', to: 'feedback_buttons#declined', as: 'declined'
end
  