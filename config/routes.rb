Rails.application.routes.draw do
  root to: "flats#index"
  get "flats", to: "flats#index"
  post "search_results", to: "flats#search_results"
end
