class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :unique_id
      t.integer :pipe_deal_id
      t.integer :order_nr
      t.integer :product_id
      t.decimal :item_price
      t.decimal :sum
      t.string :currency
      t.string :name
      t.integer :quantity
      t.string :product_code

      t.timestamps
    end
  end
end
