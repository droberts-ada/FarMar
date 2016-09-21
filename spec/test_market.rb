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

    # Because all and find are implemented by and tested through
    # Loadable, they are not tested extensively here.
    describe 'all' do
      before do
        use_production_data
      end

      it 'Can load production data' do
        Market.all.length.must_be :>, 0
      end
    end

    describe '#vendors' do
      before do
        use_test_data
      end

      let (:markets) { Market.all }
      it 'Returns a collection of vendors associated with this market' do
        vendors = markets[0].vendors
        vendors.must_be_instance_of Array
        vendors.length.must_equal 2
        vendors.each do |v|
          v.must_be_instance_of Vendor
          v.market_id.must_equal markets[0].id
        end
      end

      it 'Returns an empty collection if there are no vendors for this market' do
        vendors = markets[2].vendors
        vendors.must_be_instance_of Array
        vendors.length.must_equal 0
      end
    end
  end
end
