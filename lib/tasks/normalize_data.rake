namespace :normalize_data do
  desc "Normalize Dados"
  task run: :environment do
    puts 'Normalizing...'

    ActiveRecord::Base.transaction do
      estates = [
        ['Goias', 'GO'],
        ['Maceio', 'AL'],
        ['Goiás', 'GO'],
        ['Bahia', 'BA'],
        ['Espirito Santo', 'ES'],
        ['Df', 'DF'],
        ['Acre', 'AC'],
        ['Pe', 'PE'],
        ['Rio Grande Do Sul', 'RS'],
        ['Tocantins', 'TO'],
        ['Paraiba', 'PB'],
        ['Parana', 'PR'],
        ['Paraíba', 'PB'],
        ['São Paulo', 'SP'],
        ['Tocantis', 'TO'],
        ['Brasilia', 'DF'],
        ['Minas Gerais', 'MG'],
        ['Ceara', 'CE'],
        ['Mato Grosso', 'MT'],
        ['Sao Paulo', 'SP'],
        ['Pernanbuco', 'PE'],
        ['Rondonia', 'RO']
      ]
      estates.each {|e| User.where(state: e.first).update_all(state: e.second)}

      countries = [[nil, 'BR'],['', 'BR'], ['Brazil', 'BR']]
      countries.each {|e| User.where(country: e.first).update_all(country: e.second)}

      puts 'Normalized...'
    end

  end
end
