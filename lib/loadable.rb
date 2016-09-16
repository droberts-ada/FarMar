module FarMar
  class Loadable
    def self.all
    end

    def self.find
    end

    # Implement me!
    def self.from_csv
      raise NotImplementedException("You forgot to implement from_csv_line")
    end
  end
end
