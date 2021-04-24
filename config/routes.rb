Rails.application.routes.draw do
  root to: "home#index"

  # Service Worker Routes
  get "/service-worker.js" => "service_worker#service_worker"
  get "/manifest.json" => "service_worker#manifest"
  get "/offline.html" => "service_worker#offline"

  get "project_files/download", to: "project_files#download_all", as: :download_all_file
  get "project_files/goto/:name", to: "project_files#goto", constraints: { name: /.+?(?:json)?/ }
  resources :project_files do
    get "output", to: "project_files#output", as: :output
    post "batch", to: "project_files#batch_update_entry", as: :batch_update_entry
  end
  resources :entries do
    get "hints", to: "entries#hints"
  end
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
  authenticate :user, ->(u) { u.role == "admin" } do
    mount AuditLog::Engine => "/audit-log"
    namespace :madmin do
      resources :nouns
      resources :users
      resources :entries
      resources :narrators
      resources :project_files
      namespace :active_storage do
        resources :variant_records
      end
      namespace :active_storage do
        resources :blobs
      end
      namespace :audit_log do
        resources :logs
      end
      namespace :action_text do
        resources :rich_texts
      end
      namespace :active_storage do
        resources :attachments
      end
      root to: "dashboard#show"
    end
  end
end
