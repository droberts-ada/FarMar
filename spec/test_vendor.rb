require_relative 'spec_helper'

module FarMar
  describe Vendor do
    Vendor.data_path = 'spec/test_data/vendors.csv'
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
      before do
        use_production_data
      end

      it 'Can load production data' do
        Vendor.all.length.must_be :>, 0
      end
    end

    describe '#vendors' do
      before do
        use_test_data
      end

      it 'Returns a collection of vendors associated with this market' do
        market_id = 1
        vendors = Vendor.by_market(market_id)
        vendors.must_be_instance_of Hash
        vendors.length.must_equal 2
        vendors.each do |id, v|
          v.must_be_instance_of Vendor
          v.market_id.must_equal market_id
        end
      end

      it 'Returns an empty collection if there are no vendors for this market' do
        vendors = Vendor.by_market(3)
        vendors.must_be_instance_of Hash
        vendors.length.must_equal 0
      end

      it 'Returns an empty collection for a market that does not exist' do
        vendors = Vendor.by_market(50)
        vendors.must_be_instance_of Hash
        vendors.length.must_equal 0
      end
    end
  end
end
