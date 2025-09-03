class CreateZipcodes < ActiveRecord::Migration[7.2]
  def change
    create_table :zipcodes do |t|
      t.string :zip
      t.float :lat
      t.float :long

      t.timestamps
    end
  end
end
