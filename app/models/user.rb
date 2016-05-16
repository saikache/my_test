class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :set_role


  def self.all_users
    where(role: 'user').collect{|user| [user.email, user.id]}
    # self.collect{|user| [user.email, user.id]}
  end



  def set_role
    if self.email.split('@')[1].split('.')[0] == 'yahoo'
      self.role = 'admin'
    else
      self.role = 'user'
    end
  end
end
