require_relative 'spec_helper'

module FarMar
  class DummyLoadable < Loadable
    attr_reader :id
    def initialize(id, letter, nato)
      @id = id
      @letter = letter
      @nato = nato
    end
    def self.from_csv(line)
      self.new(line[0].to_i, line[1], line[2])
    end
  end

  describe CsvCollection do
    describe '#initialize' do
      it 'can load data from disk' do
        CsvCollection.new('spec/dummy_data_good.csv', DummyLoadable)
      end

      it 'loads all entries from CSV file' do
        CsvCollection.new('spec/dummy_data_good.csv', DummyLoadable).items.length.must_equal 5
      end

      it 'correctly indexes data' do
        items = CsvCollection.new('spec/dummy_data_good.csv', DummyLoadable)
        items.items.each do |id, item|
          item.id.must_equal id
        end

        items.items.wont_include 6
        items.items.wont_include 0
      end

      it 'raises an error on duplicate ids' do
        proc { CsvCollection.new('spec/dummy_data_bad.csv', DummyLoadable) }.must_raise IndexError
      end
    end
  end
end
