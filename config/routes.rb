GreenEggs::Application.routes.draw do
  devise_for :users

  root :to => 'home#index'

  match '/auth/:provider/callback' => 'authentications#create'
  namespace :api do
    resources :ballots, :except => [:new, :edit]
    resources :polls, :except => [:new, :edit]

    get '/:poll_id/invite_voters' => 'ballots#new', :as => :invite_voters
    post 'ballots/update' => 'ballots#update', :as => :update_ballot
    get '/:poll_id/admin' => 'polls#edit', :as => :poll_admin
    get '/:poll_id/:ballot_key' => 'ballots#show', :as => :vote_on_ballot
    get '/:poll_id/:ballot_key/results' => 'polls#show', :as => :poll_results
    post '/:poll_id/ballots/create' => 'ballots#create', :as => :create_ballot
    get '/:poll_id/admin' => 'polls#edit', :as => :poll_admin
    get '/:poll_id/admin/choices' => 'polls#choices', :as => :poll_choices
    post '/:id/admin/remind_voters' => 'polls#remind_voters', :as => :remind_voters
    get '/:poll_id' => 'ballots#show', :as => :group_link
  end
  get '*path' => "home#index"
end
