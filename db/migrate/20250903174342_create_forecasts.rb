class CreateForecasts < ActiveRecord::Migration[7.2]
  def change
    create_table :forecasts do |t|
      t.references :zipcodes, null: false, foreign_key: true
      t.float :celcius
      t.float :farenheit
      t.float :celcius_high
      t.float :celcius_low
      t.float :farenheit_high
      t.float :farenheit_low
      t.string :description
      t.float :precipitation_probability
      t.string :service
      t.string :raw_data

      t.timestamps
    end
  end
end
