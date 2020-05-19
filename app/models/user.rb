class User < ApplicationRecord
    validates_presence_of :name, :login, :email
    validates :admin, inclusion: { in: [ true, false ] }
    has_secure_password

    def self.authenticate(email, password)
        User.find_by_email(email).try(:authenticate, password)
    end

end
