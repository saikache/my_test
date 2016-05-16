class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :user, :foreign_key => "asigned_to"

  validates :name, presence: true, uniqueness: true
  validates :project_id, presence: true

  STATUS = [['0%', '0'], ['50%', '50'], ['100%', '100']]
end
