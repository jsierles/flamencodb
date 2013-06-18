Rails.application.routes.draw do
  root to: "pages#home"
  resources :lyrics, :tracks, :albums, :artists
  
  get "/search", to: "search#search"
end
