class ExpenditureAssignee < ApplicationRecord
    belongs_to :user
    belongs_to :expenditure
end
