Bae::Application.routes.draw do
  get "/login" => "login#new", :as =>"login"
  post "/login" => "login#create"

  match "/logout" => "login#destory", :as=>"logout"
  match "/:room" => "login#today"

  match "/freebusy/:room/:date" => "book#index", :as => "freebusy"
  match "/book/confirm" => "book#confirm", :as => "book_confirm"
  get "/book/:room/:from/:to" => "book#create", :as => "book"
end
