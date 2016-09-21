require_relative 'spec_helper'

module FarMar
  describe Market do
    describe '#initialize' do
      it 'Can be created with valid data' do
        Market.new(4, 'name', 'address', 'city', 'county', 'state', 'zip').id.must_equal 4
      end
    end

    describe 'from_csv' do
      it 'Accepts well-formated CSV lines' do
        good_csv = [
          ['4', 'name', 'address', 'city', 'county', 'state', 'zip']
        ]
        good_csv.each do |line|
          Market.from_csv(line)
        end
      end

      it 'Rejects invalid CSV lines' do
        bad_csv = [
          ['non-numeric', 'n', 'a', 'c', 'c', 's', 'z'],
          ['4', 'not', 'enough', 'fields'],
          ['4', 'this', 'test', 'tests', 'what', 'happens', 'when', 'there', 'are', 'too', 'many', 'fields']
        ]
        bad_csv.each do |line|
          proc { Market.from_csv(line) }.must_raise ArgumentError, "Did not fail on CSV data #{line}"
        end
      end
    end

    describe 'all' do
      it 'Should inherit the all method' do
        Market.all.length.must_be :>, 0
      end
    end
  end
end
