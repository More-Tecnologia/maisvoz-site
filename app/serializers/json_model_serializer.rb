class JsonModelSerializer
  # Dumps objects to json.
  # Loads json into specified class.
  #
  # e.g:
  #
  # class User
  #   serialize :data, JsonSerializer.new(DataObject)
  # end
  #
  # Will serialize any instance of DataObject into a json string.
  # Will unserialize any json string into an DataObject instance.
  # Params:
  # +klass+:: Class that parsed attributes will be initialized into
  def initialize(klass)
    @klass = klass
  end

  def dump(object)
    object.as_json
  end

  def load(hash)
    if hash.is_a? String
      hash = JSON.parse(hash)
    end

    @klass.new(hash)
  end
end
