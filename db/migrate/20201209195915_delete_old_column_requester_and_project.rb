class DeleteOldColumnRequesterAndProject < ActiveRecord::Migration[6.0]
  def self.up
    remove_column :records, :project
    remove_column :records, :requester
  end
  def self.down
  end
end
