require_relative 'spec_helper'

module FarMar
  describe Product do
    describe '#initialize' do
      it 'Can be created with valid data' do
        Product.new(4, 'name', 10).id.must_equal 4
      end
    end

    describe 'from_csv' do
      it 'Accepts well-formated CSV lines' do
        good_csv = [
          ['4', 'name', '10']
        ]
        good_csv.each do |line|
          Product.from_csv(line)
        end
      end

      it 'Rejects invalid CSV lines' do
        bad_csv = [
          ['non-numeric', 'n', '10'],
          ['4', 'n', 'non-numeric'],
          ['4', 'not enough fields'],
          ['4', 'this', 'test', 'tests', 'what', 'happens', 'when', 'there', 'are', 'too', 'many', 'fields']
        ]
        bad_csv.each do |line|
          proc { Product.from_csv(line) }.must_raise ArgumentError, "Did not fail on CSV data #{line}"
        end
      end
    end

    # Because all and find are implemented by and tested through
    # Loadable, they are not tested extensively here.
    describe 'all' do
      before do
        use_production_data
      end

      it 'Can load production data' do
        Product.all.length.must_be :>, 0
      end
    end
  end
end
