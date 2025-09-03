class AddLocalityToZipcode < ActiveRecord::Migration[7.2]
  def change
    add_column :zipcodes, :locality, :string
  end
end
