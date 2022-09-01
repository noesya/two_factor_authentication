class User < ActiveRecord::Base
  devise :two_factor_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one_time_password

  def send_two_factor_authentication_code(code, delivery_method)
    SMSProvider.send_message(to: phone_number, body: code)
  end

  def phone_number
    '14159341234'
  end
end
