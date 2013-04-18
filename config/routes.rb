Bae::Application.routes.draw do
  get "/login" => "login#new", :as =>"login"
  post "/login" => "login#create"
end
