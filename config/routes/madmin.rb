# Below are the routes for madmin
namespace :madmin do
  resources :impersonates do
    post :impersonate, on: :member, as: :fake
    post :stop_impersonating, on: :collection, as: :stop_fake
  end
  namespace :paper_trail do
    resources :versions
  end
  resources :miscs
  namespace :audit_log do
    resources :logs
  end
  namespace :action_text do
    resources :rich_texts
  end
  resources :grathmeld_conversations
  resources :nouns
  resources :entries
  resources :users
  resources :gift_installs
  resources :narrators
  resources :cosmosphere_randoms
  resources :night_conversations
  resources :project_files
  resources :events
  namespace :active_storage do
    resources :attachments
  end
  namespace :active_storage do
    resources :variant_records
  end
  namespace :active_storage do
    resources :blobs
  end
  root to: "dashboard#show"
  namespace :active_storage do
    resources :variant_records
  end
  namespace :active_storage do
    resources :blobs
  end
  namespace :action_text do
    resources :rich_texts
  end
  namespace :active_storage do
    resources :attachments
  end
end
