# config/initializers/ransack.rb
#
# Custom ransack predicate to simplify query for date range
#
# See lib/ransack.rb in ransack gem
# See wiki https://github.com/activerecord-hackery/ransack/wiki/Custom-Predicates

Ransack.configure do |config|
  config.add_predicate 'end_of_day_lteq',
    arel_predicate: 'lteq',
    formatter: proc { |v| v.end_of_day }
end
