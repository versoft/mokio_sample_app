#require_relative "../app/helpers/application_helper"

Rails.application.routes.draw do
  mount Mokio::Engine => '/backend'
  
  scope "(:locale)", :locale => /en|pl/, :module => "frontend" do
    root to: "content#home"

    post '/content/home'
    post '/contacts/mail' => 'contacts#mail'
    
    get '/:ctrl/:id/:slug' => "articles#show", constraints: { ctrl: /articles|artykuly/ }
    #
    # routes for hierarchical menu
    #
    get "/:locale/*menu_path/:menu_id" => "content#show"
    get "/:menu_id" => "content#show"
    
    
    #
    # routes for non-hierarchical menu
    #
    #get "/:menu_id" => "content#show"



  end
  
  
  
  
  
end
