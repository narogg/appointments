class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
     
  has_many :clients  
  has_many :appointments 
  has_many :locations
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user| 
      user.email = auth.info.email 
      user.password = Devise.friendly_token[0,20]
    end
  end
  
  def upcoming_appointments
    #appointments.order(appointment_time: :asc).select { |a| a.appointment_time > (DateTime.now) }
    appointments.where("appointment_time LIKE ?", "#{Date.today}%").order('appointment_time asc')
    #appointments.where("appointment_time >= ?", Time.zone.now.beginning_of_day)
    #appointments.find(:all, conditions: ["DATE(appointment_time) = ?", DateTime.now] )
    #Post.where("created_at >= ?", Time.zone.now.beginning_of_day)
    #appointments.where("appointment_time >= ?", DateTime.now)
  end
  
end
