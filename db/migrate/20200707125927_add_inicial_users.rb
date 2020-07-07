class AddInicialUsers < ActiveRecord::Migration[6.0]
  def change
    User.create(name: 'Adaiane Matos', login: 'adaiane', email: 'adaiane@cm.com', admin:'false', password: '123', password_confirmation: '123')
    User.create(name: 'Daniele Andrade', login: 'daniele', email: 'daniele@cm.com', admin:'false', password: '123', password_confirmation: '123')    
    User.create(name: 'Elcio Rodrigues', login: 'elcio', email: 'elcio@cm.com', admin:'false', password: '123', password_confirmation: '123')
    User.create(name: 'Elisane Moraes', login: 'elisane', email: 'elisane@cm.com', admin:'false', password: '123', password_confirmation: '123')
    User.create(name: 'Emanuel Lucas', login: 'emanuel', email: 'emanuel@cm.com', admin:'false', password: '123', password_confirmation: '123')
    User.create(name: 'Gilvan Reis', login: 'gilvan', email: 'gilvan@cm.com', admin:'false', password: '123', password_confirmation: '123')
    User.create(name: 'Givanildo Lima', login: 'givanildo', email: 'givanildo@cm.com', admin:'false', password: '123', password_confirmation: '123')
    User.create(name: 'Jocelio Otávio', login: 'jocelio', email: 'jocelio@cm.com', admin:'false', password: '123', password_confirmation: '123')
    User.create(name: 'Joel Xavier', login: 'joel', email: 'joel@cm.com', admin:'false', password: '123', password_confirmation: '123')
    User.create(name: 'Leonardo Braga', login: 'leonardo', email: 'leonardo@cm.com', admin:'false', password: '123', password_confirmation: '123')
    User.create(name: 'Osvaldo Barbosa', login: 'osvaldo', email: 'osvaldo@cm.com', admin:'true', password: '123', password_confirmation: '123')
    User.create(name: 'Pablo Monteiro', login: 'pablo', email: 'pablo@cm.com', admin:'true', password: '123', password_confirmation: '123')
    User.create(name: 'Romário Freitas', login: 'romario', email: 'romario@cm.com', admin:'false', password: '123', password_confirmation: '123')
    User.create(name: 'Taynara Penha', login: 'taynara', email: 'taynara@cm.com', admin:'false', password: '123', password_confirmation: '123')
  end
end
