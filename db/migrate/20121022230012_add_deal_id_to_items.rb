class AddDealIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :deal_id, :integer

  end
end
