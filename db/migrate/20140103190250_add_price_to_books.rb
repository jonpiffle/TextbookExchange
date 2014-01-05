class AddPriceToBooks < ActiveRecord::Migration
  def change
  	add_column :books, :price, :decimal, :precision => 8, :scale => 2
  end
end
