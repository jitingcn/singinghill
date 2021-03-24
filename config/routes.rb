Rails.application.routes.draw do
  root "project_files#index"
  resources :project_files do
    get "output", to: "project_files#output", as: :output
  end
  resources :entries
  # get "project_files/:name", controller: "project_files",
  #                            action: :show,
  #                            format: false,
  #                            defaults: { format: "html" },
  #                            as: :project_filename, constraints: { name: /\d+.evd.txt/ }

  devise_for :users, controllers: {
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  } do
    devise_scope :user do
      get "sign_in", to: "users/sessions#new", as: :new_user_session
      get "sign_out", to: "users/sessions#destroy", as: :destroy_user_session
    end
  end
  authenticate :user, -> (u) { u.id == 1 } do
    mount AuditLog::Engine => "/audit-log"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
