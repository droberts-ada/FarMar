module FarMar
  class Loadable
    # Implement me!
    def self.from_csv(line)
      raise NotImplementedError.new("You forgot to implement from_csv")
    end

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
