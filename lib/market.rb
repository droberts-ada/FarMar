module FarMar
  class Market < Loadable
    @data_path = 'support/markets.csv'
    attr_reader :id, :name, :address, :city, :county, :state, :zip
    def initialize(id, name, address, city, county, state, zip)
      @id = id
      @name = name
      @address = address
      @city = city
      @county = county
      @state = state
      @zip = zip
    end

    # The FarMar::Market data, in order in the CSV, consists of:
    #
    # ID - (Fixnum) a unique identifier for that market
    # Name - (String) the name of the market (not guaranteed unique)
    # Address - (String) street address of the market
    # City - (String) city in which the market is located
    # County - (String) county in which the market is located
    # State - (String) state in which the market is located
    # Zip - (String) zipcode in which the market is located
    def self.from_csv(line)
      if line.length != 7
        raise ArgumentError.new("Invalid CSV: wrong number of arguments " +
                "(got #{line.length}, expected 7)")
      end
      # Note: Integer blows up on a non-int string, while to_i does not.
      return self.new(Integer(line[0]), line[1], line[2], line[3], line[4], line[5], line[6])
    end
  end
end
