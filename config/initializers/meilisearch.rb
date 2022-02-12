MeiliSearch::Rails.configuration = {
  meilisearch_host: Settings.meilisearch_host,
  meilisearch_api_key: Settings.meilisearch_api_key,
  pagination_backend: :kaminari,
  timeout: 2,
  max_retries: 1,
}
