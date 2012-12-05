class Item < ActiveRecord::Base
  #every item is linked to a deal, through deal_id
  belongs_to :deal
end
