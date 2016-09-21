require_relative 'spec_helper'

module FarMar
  class DummyLoadable < Loadable
    @data_path = 'spec/dummy_data_good.csv'

    def initialize(id, letter, nato_code)
      @id = id
      @letter = letter
      @nato_code = nato_code
    end

    def self.from_csv(line)
      self.new(line[0].to_i, line[1], line[2])
    end

    def self.verify(dummy)
      dummy.each do |id, item|
        item.id.must_equal id
      end

      (1..5).each do |id|
        dummy.must_include id
      end

      dummy.wont_include 6
      dummy.wont_include 0
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
        dummy = DummyLoadable.load_csv('spec/dummy_data_good.csv')
        DummyLoadable.verify(dummy)
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

    describe 'all' do
      it 'loads as expected from the default path' do
        dummy = DummyLoadable.all
        DummyLoadable.verify(dummy)
      end
    end

    describe 'find' do
      it 'Can find ids that exist' do
        (1..5).each do |id|
          DummyLoadable.find(id).id.must_equal id
        end
      end

      it 'Gets nil for ids that don\'t exist' do
        DummyLoadable.find(0).must_equal nil
        DummyLoadable.find(6).must_equal nil
      end
    end
  end
end
