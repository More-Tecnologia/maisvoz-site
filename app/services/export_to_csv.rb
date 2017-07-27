require 'csv'

class ExportToCsv

  prepend SimpleCommand

  def initialize(options)
    @collection = options.fetch(:collection)
    @model = options.fetch(:model)
  end

  def call
    to_csv
  end

  private

  attr_reader :collection, :model

  def to_csv
    CSV.generate do |csv|
      csv << attrs

      collection.each do |line|
        csv << line.attributes.values_at(*attrs)
      end
    end
  end

  def attrs
    @attrs ||= model.column_names
  end

end
