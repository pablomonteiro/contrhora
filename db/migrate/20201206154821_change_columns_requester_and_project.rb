class ChangeColumnsRequesterAndProject < ActiveRecord::Migration[6.0]
  def self.up
    #add_column :records, :requester_id, :bigint, null: false
    #add_column :records, :project_id, :bigint, null: false

    add_reference :records, :project, foreign_key: true
    add_reference :records, :requester, foreign_key: true


    Record.all.each do |r|
      requester = Requester.find_by_name(r.requester)
      project = Project.find_by_name(r.project)
      r.update_attributes(requester_id: requester.id, 
                          project_id: project.id)
    end

    remove_column :records, :project
    remove_column :records, :requester
  end
  def self.def down 
    # do nothing
  end
end
