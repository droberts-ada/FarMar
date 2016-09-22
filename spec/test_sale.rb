require_relative 'spec_helper'

require_relative 'spec_helper'

module FarMar
  describe Sale do
    describe '#initialize' do
      it 'Can be created with valid data' do
        Sale.new(4, 30, DateTime.now, 4, 10).id.must_equal 4
      end
    end

    describe 'from_csv' do
      it 'Accepts well-formated CSV lines' do
        good_csv = [
          ['4', '30', DateTime.now.strftime, '4', '10']
        ]
        good_csv.each do |line|
          Sale.from_csv(line)
        end
      end

      it 'Rejects invalid CSV lines' do
        bad_csv = [
          ['non-numeric', '30', DateTime.now.strftime, '4', '10'],
          ['4', 'non-numeric', DateTime.now.strftime, '4', '10'],
          ['4', '30', 'not a date', '4', '10'],
          ['4', '30', DateTime.now.strftime, 'non-numeric', '10'],
          ['4', '30', DateTime.now.strftime, '4', 'non-numeric'],
          ['4', 'not enough fields'],
          ['4', 'this', 'test', 'tests', 'what', 'happens', 'when', 'there', 'are', 'too', 'many', 'fields']
        ]
        bad_csv.each do |line|
          proc { Sale.from_csv(line) }.must_raise ArgumentError, "Did not fail on CSV data #{line}"
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
        Sale.all.length.must_be :>, 0
      end
    end

    describe 'between' do
      before do
        use_test_data
      end

      # All dates in the test data are of form:
      # 201*-06-10 00:00:00 -0800
      it 'Returns sales within the range' do
        begin_time = DateTime.parse('2012-01-01 00:00:00 -0800')
        end_time = DateTime.parse('2014-01-01 00:00:00 -0800')
        sales = Sale.between(begin_time, end_time)
        sales.must_be_instance_of Hash

        # Should contain two unique sales
        sales.length.must_equal 2
        sales.values.to_set.length.must_equal 2

        # All sales should be in the expected range
        sales.each do |id, sale|
          sale.purchase_time.must_be :>=, begin_time
          sale.purchase_time.must_be :<=, end_time
        end
      end

      it 'Includes sales occurring on the begin time' do
        begin_time = DateTime.parse('2012-06-10 00:00:00 -0800')
        end_time = DateTime.parse('2013-01-01 00:00:00 -0800')
        sales = Sale.between(begin_time, end_time)
        sales.must_be_instance_of Hash
        sales.length.must_equal 1
        sales.values[0].purchase_time.must_equal begin_time
      end

      it 'Inclues sales occurring on the end time' do
        begin_time = DateTime.parse('2013-01-01 00:00:00 -0800')
        end_time = DateTime.parse('2013-06-10 00:00:00 -0800')
        sales = Sale.between(begin_time, end_time)
        sales.must_be_instance_of Hash
        sales.length.must_equal 1
        sales.values[0].purchase_time.must_equal end_time
      end

      it 'Requires dates in the right order' do
        begin_time = DateTime.parse('2014-01-01 00:00:00 -0800')
        end_time = DateTime.parse('2012-01-01 00:00:00 -0800')
        proc {
          sales = Sale.between(begin_time, end_time)
        }.must_raise ArgumentError
      end

      it 'Rejects two of the same date' do
        begin_time = DateTime.parse('2014-01-01 00:00:00 -0800')
        end_time = DateTime.parse('2014-01-01 00:00:00 -0800')
        proc {
          sales = Sale.between(begin_time, end_time)
        }.must_raise ArgumentError
      end

      it 'Returns an empty set if no sales in range' do
        begin_time = DateTime.parse('2100-01-01 00:00:00 -0800')
        end_time = DateTime.parse('2110-01-01 00:00:00 -0800')
        sales = Sale.between(begin_time, end_time)
        sales.must_be_instance_of Hash
        sales.length.must_equal 0
      end
    end

    describe '#vendor' do
      before do
        use_test_data
      end

      it 'Returns the vendor associated with this sale' do
        sale = Sale.find(1)
        sale.must_be_instance_of Sale
        vendor = sale.vendor
        vendor.must_be_instance_of Vendor
        vendor.id.must_equal sale.vendor_id
      end

      it 'Returns nil if the vendor associated with this sale D.N.E.' do
        sale = Sale.find(4)
        sale.must_be_instance_of Sale
        sale.vendor.nil?.must_equal true
      end
    end

    describe '#product' do
      before do
        use_test_data
      end

      it 'Returns the product associated with this sale' do
        sale = Sale.find(1)
        sale.must_be_instance_of Sale
        product = sale.product
        product.must_be_instance_of Product
        product.id.must_equal sale.product_id
      end

      it 'Returns nil if the product associated with this sale D.N.E.' do
        sale = Sale.find(5)
        sale.must_be_instance_of Sale
        sale.product.nil?.must_equal true
      end
    end
  end
end
