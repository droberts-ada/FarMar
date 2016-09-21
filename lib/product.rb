module FarMar
  class Product < Loadable
    @data_path = 'support/products.csv'
    attr_reader :id, :name, :vendor_id
    def initialize(id, name, vendor_id)
      @id = id
      @name = name
      @vendor_id = vendor_id
    end

    # The FarMar::Product data, in order in the CSV, consists of:
    #
    # ID - (Fixnum) uniquely identifies the product
    # Name - (String) the name of the product (not guaranteed unique)
    # Vendor_id - (Fixnum) a reference to which vendor sells this product
    def self.from_csv(line)
      if line.length != 3
        raise ArgumentError.new("Invalid CSV: wrong number of arguments " +
        "(got #{line.length}, expected 3)")
      end
      # Note: Integer blows up on a non-int string, while to_i does not.
      return self.new(Integer(line[0]), line[1], Integer(line[2]))
    end

    def self.by_vendor(vendor_id)
      # TODO
    end

    def vendor
      # TODO
    end

    def sales
      # TODO
    end

    def number_of_sales
      # TODO
    end
  end
end
