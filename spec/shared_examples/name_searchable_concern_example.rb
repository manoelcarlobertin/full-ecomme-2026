# spec/shared_examples/name_searchable_concern.rb

RSpec.shared_examples "name searchable concern" do |factory_name|
  # 1. Define o termo de busca
  let!(:search_param) { "Example" }

  # 2. Cria registros que DEVEM ser encontrados
  let!(:records_to_find) do
    (0..3).to_a.map { |index| create(factory_name, name: "Example #{index}") }
  end

  # 3. Cria registros que DEVEM ser ignorados
  # Usamos um nome fixo diferente para garantir que não haja colisão acidental
  let!(:records_to_ignore) { create_list(factory_name, 3, name: "Other Product") }

  describe ".search_by_name" do
    it "retorna apenas os registros que correspondem ao padrão de busca" do
      found_records = described_class.search_by_name(search_param)

      # match_array é perfeito aqui: ele verifica se o resultado contém EXATAMENTE
      # os elementos esperados, sem se importar com a ordem.
      # Se 'records_to_ignore' estiver presente, o teste falha.
      # Se faltar algum 'records_to_find', o teste falha.
      expect(found_records).to match_array(records_to_find)
    end
  end
end
