class User < ApplicationRecord
	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates(
      :email_id, :presence => true,
      :format => {with: URI::MailTo::EMAIL_REGEXP, :if => Proc.new { |u| !u.email_id.blank? }}
  	)
end
