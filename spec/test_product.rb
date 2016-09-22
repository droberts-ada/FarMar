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

    describe 'by_vendor' do
      before do
        use_test_data
      end

      it 'Returns all products for a vendor' do
        vendor_id = 1
        products = Product.by_vendor(vendor_id)
        products.must_be_instance_of Hash

        # Expect exactly 3, non-duplicate elements
        products.length.must_equal 3
        products.values.to_set.length.must_equal 3

        # Check that elements have right vendor id
        products.each do |id, product|
          product.vendor_id.must_equal vendor_id
        end
      end

      it 'Returns an empty set for a vendor with no products' do
        vendor_id = 3
        products = Product.by_vendor(vendor_id)
        products.must_be_instance_of Hash
        products.length.must_equal 0
      end

      it 'Returns an empty set for a non-extant vendor' do
        vendor_id = 50
        products = Product.by_vendor(vendor_id)
        products.must_be_instance_of Hash
        products.length.must_equal 0
      end
    end

    describe '#vendor' do
      before do
        use_test_data
      end

      it 'Returns the vendor associated with this product' do
        product = Product.find(1)
        product.must_be_instance_of Product
        vendor = product.vendor
        vendor.must_be_instance_of Vendor
        vendor.id.must_equal product.vendor_id
      end

      it 'Returns nil if the vendor associated with this product D.N.E.' do
        product = Product.find(5)
        product.must_be_instance_of Product
        product.vendor.nil?.must_equal true
      end
    end

    describe '#sales' do
      before do
        use_test_data
      end
    end

    describe '#number_of_sales' do
      before do
        use_test_data
      end
    end
  end
end
