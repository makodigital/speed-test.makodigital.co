class CreateSpeedTests < ActiveRecord::Migration[6.1]
  def change
    create_table :speed_tests do |t|
      t.string :url, null: false
      t.string :email, null: false
      t.string :gtmetrix_test_id
      t.string :gtmetrix_report_id
      t.string :gtmetrix_report_url
      t.binary :gtmetrix_report_data

      t.timestamps
    end
  end
end
