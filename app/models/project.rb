class Project < ActiveRecord::Base
  has_many :tasks


  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }


  before_save :cap


  def cap
    self.name = self.name.capitalize
  end


end