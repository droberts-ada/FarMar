# gems your project needs
require 'csv'
require 'date'

# our namespace module
module FarMar;
end

# all of our data classes that live in the module

require_relative './lib/loadable'
require_relative './lib/market'
require_relative './lib/vendor'
require_relative './lib/products'
require_relative './lib/sales'
