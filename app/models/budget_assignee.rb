class BudgetAssignee < ApplicationRecord
  belongs_to :budget
  belongs_to :user

  def individual(total)
    total * self.percentage / 100
  end
end
