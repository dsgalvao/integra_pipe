class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.integer :pipedrive_id
      t.integer :public_id
      t.integer :company_id
      t.integer :user_id
      t.string :user_email
      t.string :person_name
      t.string :org_name
      t.string :title
      t.decimal :value
      t.string :currency
      t.integer :products_count
      t.string :feira_id

      t.timestamps
    end
  end
end
