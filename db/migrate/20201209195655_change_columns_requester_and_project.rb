class ChangeColumnsRequesterAndProject < ActiveRecord::Migration[6.0]
  def self.up
    # Correction of projects names
    execute 'UPDATE RECORDS SET project = \'VarejoFacil\' WHERE project = \'Varejofacil\''
    execute 'UPDATE RECORDS SET project = \'Milênio\' WHERE project = \'Milënio\''
    # Migrate values of requesters and projects to FK references
    execute 'UPDATE RECORDS JOIN REQUESTERS RQ ON REQUESTER = RQ.NAME SET REQUESTER_ID = RQ.ID'
    execute 'UPDATE RECORDS JOIN PROJECTS P ON PROJECT = P.NAME SET PROJECT_ID = P.ID'
  end

  def self.def down 
    # do nothing
  end
end
