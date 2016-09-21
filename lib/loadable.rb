module FarMar
  # Loadable represents a collection that can be loaded
  # from a CSV file on disk.
  # Any class implementing this interface must provide the following:
  # - self.from_csv, to create a single instance of the loaded object
  #     from a line of CSV
  # - A readable attribute id, unique across all instances
  class Loadable
    # Create a single instance of this object from a line
    # of CSV, i.e. an array.
    # Implement me!
    def self.from_csv(line)
      raise NotImplementedError.new("You forgot to implement from_csv")
    end

    # Load all objects from the given CSV file.
    # Returns a hash { item.id => item }
    def self.load_csv(filename)
      items = {}
      CSV.read(filename).each do |line|
        item = from_csv(line)
        raise IndexError.new("Data includes duplciate ID") if items.key? item.id
        items[item.id] = item
      end
      return items
    end
  end
end
