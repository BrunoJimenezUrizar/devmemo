Rapidfire::Engine.routes.draw do
#Rails.application.routes.draw do
  	

  resources :question_groups do
    get 'results', on: :member

    resources :questions
    resources :answer_groups, only: [:new, :create, :index]
  end

  match 'activate_question_group(/:question_group_id)' => 'question_groups#activate', :as => :activate
  match 'deactivate_question_group(/:question_group_id)' => 'question_groups#deactivate', :as => :deactivate

  root :to => "question_groups#index"
end