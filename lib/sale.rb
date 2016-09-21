module FarMar
  class Sale < Loadable
    @data_path = 'support/sales.csv'
    attr_reader :id, :amount, :purchase_time, :vendor_id, :product_id
    def initialize(id, amount, purchase_time, vendor_id, product_id)
      @id = id
      @amount = amount
      @purchase_time = purchase_time
      @vendor_id = vendor_id
      @product_id = product_id
    end

    # The FarMar::Sale data, in order in the CSV, consists of:
    #
    # ID - (Fixnum) uniquely identifies the sale
    # Amount - (Fixnum) the amount of the transaction, in cents (i.e., 150 would be $1.50)
    # Purchase_time - (Datetime) when the sale was completed
    # Vendor_id - (Fixnum) a reference to which vendor completed the sale
    # Product_id - (Fixnum) a reference to which product was sold
    def self.from_csv(line)
      if line.length != 5
        raise ArgumentError.new("Invalid CSV: wrong number of arguments " +
        "(got #{line.length}, expected 5)")
      end
      # Note: Integer blows up on a non-int string, while to_i does not.
      puts ">>>>> DPR: parsing #{line}"
      return self.new(Integer(line[0]), Integer(line[1]), DateTime.parse(line[2]),
              Integer(line[3]), Integer(line[4]))
    end
  end
end
