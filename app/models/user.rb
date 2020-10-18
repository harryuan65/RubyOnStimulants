# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  fb_uid                 :string
#  fb_token               :string
#  google_uid             :string
#  google_token           :string
#  name                   :string
#

class User < ApplicationRecord
  has_many :accounts, dependent: :destroy
  has_many :to_do_lists, dependent: :destroy
  has_many :articles
  has_many :comments
  has_many :user_word_ships, dependent: :destroy
  has_many :words, through: :user_word_ships, source: :word
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info

    user = User.where(:google_token => access_token.credentials.token, :google_uid => access_token.uid ).first
    if user
      return user
    else
      existing_user = User.where(:email => data["email"]).first
      if  existing_user
        existing_user.google_uid = access_token.uid
        existing_user.google_token = access_token.credentials.token
        existing_user.image_url = data["image"] if existing_user.image_url.nil?
        existing_user.save!
        return existing_user
      else
    # Uncomment the section below if you want users to be created if they don't exist
        user = User.create(
            name: data["name"],
            email: data["email"],
            image_url: data["image"],
            password: Devise.friendly_token[0,20],
            google_token: access_token.credentials.token,
            google_uid: access_token.uid
          )
      end
    end
  end

  def self.from_omniauth(auth)
    # Case 1: Find existing user by facebook uid
    user = User.find_by(fb_uid: auth.uid )
    if user
      user.fb_token = auth.credentials.token
      user.save!
      return user
    end
    # Case 2: Find existing user by email
    existing_user = User.find_by(email: auth.info.email )
    if existing_user
      existing_user.fb_uid = auth.uid
      existing_user.fb_token = auth.credentials.token
      existing_user.save!
      return existing_user
    end
    # Case 3: Create new password
    user = User.new
    user.fb_uid = auth.uid
    user.fb_token = auth.credentials.token
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name
    user.save!
    return user
  end
end
