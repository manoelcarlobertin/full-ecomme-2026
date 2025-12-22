Rails.application.routes.draw do
  devise_for :users
  # Rota para a loja pública (Faremos depois)
  root "home#index"

  # Adicione esta linha para visualizar o pagamento de qualquer pedido em modo sandbox:
  get "pay_test/:id", to: "checkout#sandbox", as: :pay_test

  # --- Carrinho de Compras --- O carrinho deve ser público. Não faz parte do admin.
  # Usamos 'resource' (singular) pois o usuário só tem UM carrinho por vez
  resource :cart, only: [ :show ], controller: "cart" do
    post "add/:product_id", action: :add, as: :add_to
    delete "remove/:product_id", action: :remove, as: :remove_from
  end

  # Agrupamos rotas de webhook para ficar organizado
  namespace :webhooks do
    post 'juno', to: 'juno#create'
  end

  resources :wish_items, only: [ :index, :create, :destroy, :show ]
  # Adicione esta linha (pode ser perto de resources :wish_items)
  resources :products, only: [ :show ]

  # --- Área Administrativa ---
  namespace :admin do
    # O "root" dentro do namespace admin direciona para /admin
    root to: "dashboard#index"
    # Outras rotas do admin
    resources :categories
    resources :products
    resources :system_requirements
    resources :users
    resources :coupons
    resources :games, only: [], shallow: true do
        resources :licenses
    end

    namespace :dashboard do
      resources :sales_ranges, only: :index
      resources :summaries, only: :index
      resources :top_five_products, only: :index
    end
  end

  # Rotas de Checkout FORA do namespace :admin
  post "checkout", to: "checkout#create", as: :checkout
  get "checkout/success/:order_id", to: "checkout#success", as: :checkout_success

  # 0. Uma rota pública (mas autenticada) para o usuário ver seus próprios pedidos abaixo:
  # resources :orders, only: [ :index, :show, :update ]

  # --- atenção aqui CANCELAR PEDIDO pelo cliente ---
  # 1. Vamos adicionar uma ação personalizada chamada 'cancel' dentro dos recursos de pedidos.
  # 2. Alteramos a linha resources :orders para incluir o bloco do 'member'
  resources :orders, only: [ :index, :show ]  do
    member do
      patch :cancel
    end
  end
end
