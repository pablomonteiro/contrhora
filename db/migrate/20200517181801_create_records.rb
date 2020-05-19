class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.string :project
      t.string :issue
      t.text :comment
      t.date :register
      t.string :hour_in
      t.string :hour_out
      t.string :requester
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
