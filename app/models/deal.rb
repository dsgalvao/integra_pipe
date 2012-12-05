class Deal < ActiveRecord::Base
  #a deal can have many itens
  has_many :items
end
