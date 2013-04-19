Bae::Application.routes.draw do
  get "/login" => "login#new", :as =>"login"
  post "/login" => "login#create"

  match "/book/:date/:room" => "book#index", :as => "book"
end
