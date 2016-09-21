module FarMar
  # Loadable represents a collection that can be loaded
  # from a CSV file on disk.
  #
  # Any class implementing this interface must provide the following:
  # - self.from_csv, to create a single instance of the loaded object
  #     from a line of CSV
  # - A readable attribute id, unique across all instances
  # - A class instance variable data_path, representing the path to the CSV file
  class Loadable
    # A note for the currious:
    # There are several potential ways we could pull the data_path variable
    # from the subclass, but this is the only one that actually works.
    # Other possible candidates include:
    #   - Use a constant, (DATA_PATH) defined in the subclass. Unfortunately,
    #     these constants are not visible here in the superclass.
    #   - Use a class variable (@@data_path), defined here and overridden by the
    #     subclass. This doesn't work because there is exactly one instance of the
    #     class variable, shared between all subclasses, and if one changes it
    #     (to say 'support/products.csv') then that change will affect all.
    # What we do instead is define a class method that gives us the path, and
    # which is overridden by the subclasses, similar to how from_csv works.
    class << self
      attr_reader :data_path
    end

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
      CSV.foreach(filename) do |line|
        item = from_csv(line)
        raise IndexError.new("Data includes duplciate ID") if items.key? item.id
        items[item.id] = item
      end
      return items
    end

    # Load the collection hash { item.id => item } from the path
    # defined by the implementing class.
    def self.all
      return self.load_csv(@data_path)
    end

    # Find an element by id in the collection hash.
    def self.find(id)
      return all[id]
    end
  end
end
