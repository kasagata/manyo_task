class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :labels, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  before_destroy :check_admin_presence
  before_update :change_admin_check

  before_validation {
    if email
      email.downcase!
    end

    email = ""
  }

  private

  def check_admin_presence
    unless User.where(admin: true).where.not(id: id).exists? 
      errors.add(:base, '管理者が0人になるため削除できません')
      throw(:abort) 
    end
  end

  def change_admin_check
    return unless will_save_change_to_admin?
    unless User.where(admin: true).where.not(id: id).exists? 
      errors.add(:base, '管理者が0人になるため権限を変更できません')
      throw(:abort) 
    end
  end

  has_secure_password
end
