class AddInitialProjects < ActiveRecord::Migration[6.0]
  def change
    Project.create(name: 'VarejoFacil', active: true)
    Project.create(name: 'Milênio', active: true)
    Project.create(name: 'SysPDV', active: true)
    Project.create(name: 'Produto', active: true)
    Project.create(name: 'Design', active: true)
  end
end
