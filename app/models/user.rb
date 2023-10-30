class User < ApplicationRecord
    belongs_to :families, through: :family_members


end
