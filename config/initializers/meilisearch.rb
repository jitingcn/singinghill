MeiliSearch::Rails.configuration = {
  meilisearch_url: Settings.meilisearch_host,
  meilisearch_api_key: Settings.meilisearch_api_key,
  pagination_backend: :kaminari,
  timeout: 2,
  max_retries: 1
}
