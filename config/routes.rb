RedmineApp::Application.routes.draw do
    post 'feedback_buttons', to: 'feedback_buttons#create'

    get 'feedback_buttons/approve', to: 'feedback_buttons#approve', as: 'approve'
    get 'feedback_buttons/decline', to: 'feedback_buttons#decline', as: 'decline'
end
  