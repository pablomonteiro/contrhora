class AddActiveAndRedefinePasswordToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :active, :boolean, default: true
    add_column :users, :redefine_password, :boolean, default: true
  end
end
