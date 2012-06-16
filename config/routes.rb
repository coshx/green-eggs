GreenEggs::Application.routes.draw do
  resources :tags
  resources :ballots
  resources :polls

  root :to => 'home#index'

  get '/:poll_id/invite_voters' => 'ballots#new', :as => :invite_voters
  post 'ballots/update' => 'ballots#update', :as => :update_ballot
  get '/:poll_id/admin' => 'polls#edit', :as => :poll_admin
  get '/:poll_id/:ballot_key' => 'ballots#show', :as => :vote_on_ballot
  get '/:poll_id/:ballot_key/results' => 'polls#show', :as => :poll_results
  post '/:poll_id/ballots/create' => 'ballots#create', :as => :create_ballot
  get '/:poll_id/admin' => 'polls#edit', :as => :poll_admin
  get '/:poll_id/admin/choices' => 'polls#choices', :as => :poll_choices
  get '/github' => 'polls#from_gh_issues', :as => 'new_poll_from_gh_issues'

end
