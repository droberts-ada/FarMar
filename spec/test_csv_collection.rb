require_relative 'spec_helper'

module FarMar
  class DummyLoadable < Loadable
    def initialize(id, letter, nato)
      @id = id
      @letter = letter
      @nato = nato
    end
    def self.load_from_csv(line)
      self.new(line[0].to_i, line[1], line[2])
    end
  end

  describe CsvCollection do
    describe '#initialize' do
      it 'can load data from disk' do
        CsvCollection.new('spec/dummy_data_good.csv', DummyLoadable)
      end

      it 'correctly indexes data' do
        items = CsvCollection.new('spec/dummy_data_good.csv', DummyLoadable)
        items.items.each do |id, item|
          item.id.must_equal id
        end
      end

      it 'raises an error on duplicate ids' do
        CsvCollection.new('spec/dummy_data_bad.csv', DummyLoadable).must_raise(IndexError)
      end
    end
  end
end
