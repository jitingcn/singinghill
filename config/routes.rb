Rails.application.routes.draw do
  root to: "home#index"

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      get "/sessions", to: "sessions#create"
      get "/me", to: "users#me"
      get "/entries/search", to: "entries#search"
      get "/project_files/download_all", to: "project_files#download_all"
    end
  end

  # Service Worker Routes
  get "/service-worker.js" => "service_worker#service_worker"
  get "/manifest.json" => "service_worker#manifest"
  get "/offline.html" => "service_worker#offline"

  get "/progress/total" => "progress#total"

  get "project_files/download", to: "project_files#download_all", as: :download_all_file

  resources :project_files, controller: "project_files", type: "ProjectFile" do
    get "output", to: "project_files#output", as: :output
    post "batch", to: "project_files#batch_update_entry", as: :batch_update_entry
  end

  %i[event night_conversation grathmeld_conversation cosmosphere_random gift_install misc].each do |type|
    resources type, controller: "project_files", type: type.to_s.camelize do
      get "output", to: "project_files#output", as: :output
      post "batch", to: "project_files#batch_update_entry", as: :batch_update_entry
    end
    get "#{type}/goto/:name", to: "project_files#goto", type: type.to_s.camelize, constraints: {name: /.+?(?:json)?/}
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
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  } do
    devise_scope :user do
      get "edit", to: "users/registrations#edit", as: :edit_user_registration
      get "sign_in", to: "users/sessions#new", as: :new_user_session
      get "sign_out", to: "users/sessions#destroy", as: :destroy_user_session
    end
  end
  authenticate :user, ->(u) { u.admin? } do
    mount AuditLog::Engine => "/audit-log"
    draw :madmin
  end
end
