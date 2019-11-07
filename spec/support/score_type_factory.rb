module ScoreTypeFactory
  def self.create
    score_types = [{ name: 'Pontuação de Adesões' },
                   { name: 'Pontuação de Ativação' },
                   { name: 'Pontuação de Compras' },
                   { name: 'Pontuação Binária', tree_type: :binary },
                   { name: 'Estorno de Pontuação Binária por Desqualificação', tree_type: :binary },
                   { name: 'Estorno de Pontuação Binária por Inatividade', tree_type: :binary },
                   { name: 'Débito de Bonus Binário', tree_type: :binary }]
    score_types.each { |score_type| ScoreType.find_or_create_by!(score_type) }
  end
end
