# A collection can be loaded from disk

module FarMar
  class CsvCollection
    attr_reader :items
    def initialize(filename, type)
      @items = {}
      CSV.read(filename).each do |line|
        item = type.from_csv(line)
        raise IndexError.new("Data includes duplciate ID") if @items.key?item.id
        @items[item.id] = item
      end
    end
  end
end
