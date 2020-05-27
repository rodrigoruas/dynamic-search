Rails.application.routes.draw do
  root to: "flats#index"
  get "flats", to: "flats#index"
end
