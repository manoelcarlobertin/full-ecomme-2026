if Rails.env.development? || Rails.env.test?
  require "factory_bot"

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: :environment do
      include FactoryBot::Syntax::Methods

      # 1. LIMPEZA (Ordem importa por causa das chaves estrangeiras)
      puts "🧹 Limpando dados antigos..."
      # Apaga tudo que depende de outras tabelas primeiro
      License.destroy_all rescue nil
      OrderItem.destroy_all rescue nil
      Order.destroy_all rescue nil
      ProductCategory.destroy_all rescue nil
      Product.destroy_all rescue nil
      Category.destroy_all rescue nil
      Coupon.destroy_all rescue nil
      SystemRequirement.destroy_all rescue nil

      # Apaga usuários, MAS PRESERVA O ADMIN (para você não perder o acesso)
      User.where.not(profile: :admin).destroy_all rescue nil
      puts "✨ Banco limpo (Admin preservado)!"

      # 2. POPULANDO (O código que você já tinha)
      puts "👥 Criando Usuários..."
      15.times do
        profile = [ :admin, :client ].sample
        create(:user, profile: profile)
      end

      puts "💻 Criando Requisitos e Cupons..."
      system_requirements = []
      ['Basic', 'Intermediate', 'Advanced'].each do |sr_name|
        system_requirements << create(:system_requirement, name: sr_name)
      end

      15.times do
        coupon_status = [ :active, :inactive ].sample
        create(:coupon, status: coupon_status)
      end

      puts "📦 Criando Categorias..."
      categories = []
      25.times do
        categories << create(:category, name: Faker::Game.unique.genre)
      end

      puts "🎮 Criando Produtos e Jogos..."
      30.times do
        game_name = Faker::Game.unique.title
        availability = [ :available, :unavailable ].sample
        categories_count = rand(0..3)

        # Garante que pegamos IDs que existem
        game_categories_ids = Category.all.sample(categories_count).pluck(:id)

        game = create(:game, system_requirement: system_requirements.sample)
        create(
          :product,
          name: game_name,
          status: availability,
          category_ids: game_categories_ids,
          productable: game
        )
      end

      puts "✅ Ambiente populado com sucesso!"
    end
  end
end
