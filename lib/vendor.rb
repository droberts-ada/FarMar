module FarMar
  class Vendor < Loadable
    @data_path = 'support/vendors.csv'
    attr_reader :id, :name, :employees, :market_id
    def initialize(id, name, employees, market_id)
      @id = id
      @name = name
      @employees = employees
      @market_id = market_id
    end

    # The FarMar::Vendor data, in order in the CSV, consists of:
    #
    # ID - (Fixnum) uniquely identifies the vendor
    # Name - (String) the name of the vendor (not guaranteed unique)
    # No. of Employees - (Fixnum) How many employees the vendor has at the market
    # Market_id - (Fixnum) a reference to which market the vendor attends
    def self.from_csv(line)
      if line.length != 4
        raise ArgumentError.new("Invalid CSV: wrong number of arguments " +
        "(got #{line.length}, expected 4)")
      end
      # Note: Integer blows up on a non-int string, while to_i does not.
      return self.new(Integer(line[0]), line[1], Integer(line[2]), Integer(line[3]))
    end
  end
end
