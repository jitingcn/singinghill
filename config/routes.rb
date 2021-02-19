Rails.application.routes.draw do
  root "project_files#index"
  resources :project_files
  get "project_files/:name", controller: "project_files",
                             action: :show,
                             format: false,
                             defaults: { format: "html" },
                             as: :project_filename, constraints: { name: /\d+.evd.txt/ }

  devise_for :users, controllers: {
    sessions: "users/sessions",
    passwords: "users/passwords",
    registrations: "users/registrations",
    unlocks: "users/unlocks",
    confirmations: "users/confirmations"
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
