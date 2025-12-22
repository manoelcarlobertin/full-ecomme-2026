# Agora aceita 2 argumentos: factory_name e o campo de busca (field)
RSpec.shared_examples "like searchable concern" do |factory_name, field|
  let!(:search_param) { "Example" }

  let!(:records_to_find) do
    # Cria registros usando o 'campo dinâmico' (ex: name: "Example" ou key: "Example")
    (0..3).to_a.map { |index| create(factory_name, field => "Example #{index}") }
  end

  let!(:records_to_ignore) { create_list(factory_name, 3) }

  describe ".search_by_#{field}" do
    it "found records with expression in :#{field}" do
      # Chama o método dinamicamente (ex: search_by_name ou search_by_key)
      search_method = "search_by_#{field}" 

      # Garante que o método existe antes de chamar
      expect(described_class).to respond_to(search_method)

      found_records = described_class.send(search_method, search_param)
      expect(found_records).to match_array(records_to_find)
      expect(found_records).to_not include(records_to_ignore)
    end

    # it "found records with expression in :#{field}" do
    #   found_records = described_class.like(field, search_param)
    #   expect(found_records.to_a).to contain_exactly(*records_to_find)
    # end

    # it "ignores records without expression in :#{field}" do
    #   found_records = described_class.like(field, search_param)
    #   expect(found_records.to_a).to_not include(*records_to_ignore)
    # end
  end
end
