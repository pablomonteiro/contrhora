class User < ApplicationRecord
    validates_presence_of :name, :login, :email
    validates :admin, inclusion: { in: [ true, false ] }
    has_secure_password

    scope :active_users, -> {where(active: true)}

    def self.authenticate(email, password)
        User.active_users.find_by_email(email).try(:authenticate, password)
    end

    def all_users
        User.all
    end

    def self.find_user_by_name(name)
        user = User.active_users.find_by_name(name)
    end

end
