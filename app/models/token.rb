class Token < ApplicationRecord
  belongs_to :user
  before_create :generate_token

    def is_valid?
        DateTime.now < self.expires_at
    end	

    private
        def generate_token
            begin
                self.token = SecureRandom.hex
            end	while Token.where(token: self.token).any?	
            self.expires_at ||= 1.month.from_now
    end
end
