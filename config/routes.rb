RedmineApp::Application.routes.draw do
    post 'feedback_buttons', to: 'feedback_buttons#create'
  end
  