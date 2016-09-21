require_relative 'spec_helper'

module FarMar
  class DummyLoadable < Loadable
    attr_reader :id

    def initialize(id, letter, nato_code)
      @id = id
      @letter = letter
      @nato_code = nato_code
    end

    def self.from_csv(line)
      self.new(line[0].to_i, line[1], line[2])
    end
  end

  describe Loadable do
    describe 'load_csv' do
      it 'can load data from disk' do
        DummyLoadable.load_csv('spec/dummy_data_good.csv')
      end

      it 'loads all entries from CSV file' do
        DummyLoadable.load_csv('spec/dummy_data_good.csv').length.must_equal 5
      end

      it 'correctly indexes data' do
        items = DummyLoadable.load_csv('spec/dummy_data_good.csv')
        items.each do |id, item|
          item.id.must_equal id
        end

        (1..5).each do |id|
          items.must_include id
        end

        items.wont_include 6
        items.wont_include 0
      end

      it 'raises an error on duplicate ids' do
        proc {
          DummyLoadable.load_csv('spec/dummy_data_bad.csv')
        }.must_raise IndexError
      end

      it 'wont allow a base Loadable to be loaded' do
        proc {
          Loadable.load_csv('spec/dummy_data_good.csv')
        }.must_raise NotImplementedError
      end

      it 'requires a valid path' do
        proc {
          Loadable.load_csv('does/not/exist.csv')
        }.must_raise Errno::ENOENT
      end
    end
  end
end
