# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  email               :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  user                :string(255)      not null
#  agency_id           :integer
#  phone               :string(255)
#  first_name          :string(255)
#  last_name           :string(255)
#  groups              :string(1000)
#

class User < ActiveRecord::Base

  belongs_to :agency
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :trackable, :timeoutable

  enum role: { user_requested: 0, user_full: 1, admin: 2}
  has_many :email_messages
  has_many :mobile_app_users
  has_many :mobile_apps, through: :mobile_app_users
  
  has_many :gallery_users
  has_many :gallerys, through: :gallery_users

  paginates_per 200

  def cas_extra_attributes=(extra_attributes)
    puts extra_attributes.inspect
    extra_attributes.each do |name, value|
      case name
      when "Email-Address"
        self.email = value
      when "Org-Agency-Name"
        self.agency = Agency.where("name LIKE ?","%#{value}%").first
      when "Phone"
        self.phone = value
      when "First-Name"
        self.first_name = value
      when "Last-Name"
        self.last_name = value
      when "GroupList"
        self.groups = value
        if self.groups.include? ENV['REGISTRY_ADMIN_GROUP']
          self.role = 2
        elsif self.groups.include? ENV['REGISTRY_USER_GROUP']
          self.role = 1
        else
          self.role = 0
        end
      end
    end
  end

end
