class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.integer :pipedrive_id
      t.integer :my_finance_id
      t.string :name
      t.string :segmento
      t.string :razao_social
      t.integer :fisica_juridica
      t.string :cpf_cnpj
      t.string :url
      t.string :email
      t.datetime :update_time

      t.timestamps
    end
  end
end
