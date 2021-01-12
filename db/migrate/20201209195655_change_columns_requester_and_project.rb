class ChangeColumnsRequesterAndProject < ActiveRecord::Migration[6.0]
  def self.up
    # Correction of projects names
    execute 'UPDATE records SET project = \'VarejoFacil\' WHERE project = \'Varejofacil\''
    execute 'UPDATE records SET project = \'Milênio\' WHERE project = \'Milënio\''
    # Migrate values of requesters and projects to FK references
    execute 'UPDATE records JOIN requesters rq ON requester = rq.name SET requester_id = rq.id'
    execute 'UPDATE records JOIN projects p ON project = p.name SET project_id = p.id'
  end

  def self.def down 
    # do nothing
  end
end
