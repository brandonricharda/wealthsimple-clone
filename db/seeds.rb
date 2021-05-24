# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Asset.create(:ticker => "CASH", :price => 1, :riskiness => 1)
Asset.create(:ticker => "BONDS", :price => 1, :riskiness => 2)
Asset.create(:ticker => "GOLD", :price => 1, :riskiness => 3)
Asset.create(:ticker => "VTI", :price => 1, :riskiness => 4)
Asset.create(:ticker => "SPY", :price => 1, :riskiness => 5)