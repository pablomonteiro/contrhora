class Requester < ApplicationRecord

    has_many :records, dependent: :destroy

    scope :actives, -> {where(active: true)}

end
