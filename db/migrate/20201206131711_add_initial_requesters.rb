class AddInitialRequesters < ActiveRecord::Migration[6.0]
  def change
    Requester.create(name: 'Cláudio', active: true)
    Requester.create(name: 'Crisanto', active: true)
    Requester.create(name: 'Eduardo', active: true)
    Requester.create(name: 'Elisane', active: true)
    Requester.create(name: 'Felipe', active: true)
    Requester.create(name: 'Gabriela', active: true)
    Requester.create(name: 'Rafaela', active: true)
    Requester.create(name: 'Raymundo', active: true)
    Requester.create(name: 'Ricardo', active: true)
    Requester.create(name: 'Tanner', active: true)
  end
end
