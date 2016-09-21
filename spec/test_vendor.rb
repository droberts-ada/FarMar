require_relative 'spec_helper'

module FarMar
  describe Vendor do
    describe '#initialize' do
      it 'Can be created with valid data' do
        Vendor.new(4, 'name', 4, 10).id.must_equal 4
      end
    end

    describe 'from_csv' do
      it 'Accepts well-formated CSV lines' do
        good_csv = [
          ['4', 'name', '4', '10']
        ]
        good_csv.each do |line|
          Vendor.from_csv(line)
        end
      end

      it 'Rejects invalid CSV lines' do
        bad_csv = [
          ['non-numeric', 'name', '4', '10'],
          ['4', 'name', 'non-numeric', '10'],
          ['4', 'name', '4', 'non-numeric'],
          ['4', 'not enough fields'],
          ['4', 'this', 'test', 'tests', 'what', 'happens', 'when', 'there', 'are', 'too', 'many', 'fields']
        ]
        bad_csv.each do |line|
          proc { Vendor.from_csv(line) }.must_raise ArgumentError, "Did not fail on CSV data #{line}"
        end
      end
    end

    # Because all and find are implemented by and tested through
    # Loadable, they are not tested extensively here.
    describe 'all' do
      it 'Should inherit the all method' do
        Vendor.all.length.must_be :>, 0
      end
    end
  end
end
