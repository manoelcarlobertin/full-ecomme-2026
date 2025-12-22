# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
# para interceptar requisições HTTP no Ruby
require 'webmock/rspec'

# Isso impede que qualquer teste tente acessar a internet de verdade.
# Se algum código tentar sair para a web, o WebMock vai gritar e falhar o teste.
WebMock.disable_net_connect!(allow_localhost: true)
# --- CARREGAMENTO DE ARQUIVOS DE SUPORTE ---
# Carrega recursivamente todos os arquivos em spec/support e spec/shared_examples
# Isso garante que seus Shared Examples e configurações extras sejam lidos.
Rails.root.glob('spec/{support,shared_examples}/**/*.rb').each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # 1. Antes de começar a suíte inteira de testes, limpe tudo (garante banco zerado)
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # 2. Define a estratégia padrão para a maioria dos testes (Transação é muito rápido)
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # 3. Para testes que usam JS (js: true), o navegador não vê a transação.
  #    Então usamos 'truncation' (apaga dados das tabelas) para garantir a limpeza.
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  # 4. Inicia a estratégia definida acima antes do teste
  config.before(:each) do
    DatabaseCleaner.start
  end

  # 5. Limpa o banco depois que o teste acaba
  config.after(:each) do
    DatabaseCleaner.clean
  end
  # --- CONFIGURAÇÕES DE FIXTURES ---
  # Se você não estiver usando Rails Fixtures, pode remover essa linha,
  # mas mantê-la não atrapalha o FactoryBot.
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # precisamos avisar ao RSpec para parar de usar a limpeza nativa do Rails,
  # senão teremos duas ferramentas brigando para limpar o banco (o que causa erros).
  config.use_transactional_fixtures = false

  # --- CONFIGURAÇÕES EXTRAS (SUAS ADIÇÕES) ---

  # Permite usar 'create', 'build' sem digitar FactoryBot.create
  config.include FactoryBot::Syntax::Methods

  # Permite usar métodos como 'travel_to' para manipular tempo nos testes
  config.include ActiveSupport::Testing::TimeHelpers

  # Permite usar sign_in / sign_out nos testes de Request e Controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  # --- CONFIGURAÇÕES PADRÃO DO RSPEC RAILS ---

  # Infere o tipo de teste baseada na localização do arquivo
  # Ex: spec/models é tratado como type: :model automaticamente
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.alias_it_behaves_like_to :it_has_behavior_of, 'has behavior of'
end

# --- CONFIGURAÇÃO SHOULDA MATCHERS ---
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
