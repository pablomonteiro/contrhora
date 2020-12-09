class CreateReferencesProjectAndRequesters < ActiveRecord::Migration[6.0]
  def self.up

    add_reference :records, :project, foreign_key: true
    add_reference :records, :requester, foreign_key: true
    
  end
  def self.def down 
    # do nothing
  end
end
