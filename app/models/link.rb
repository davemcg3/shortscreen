class Link < ApplicationRecord
  MAX_RETRIES = 10 # eventually this will choke when we have lots of links but it's going to be awhile

  before_validation :verify_or_add_codes

  validates(:destination, presence: true)
  validates(:short_code, presence: true)
  validates(:admin_code, presence: true)

  scope :active, -> { where(expired_at: nil) }

  def verify_or_add_codes
    codes = [:short_code, :admin_code]
    codes.each do |code|
      next if self[code].present?
      MAX_RETRIES.times do # this is for handling collisions
        new_code = self.class.generate_code
        break self[code] = new_code if self.class.where("#{code} = ?", new_code).empty?
      end
    end
  end

  def self.generate_code
    SecureRandom.hex(3) # generates a 6 digit hex code, 16^6 = 16,777,216 possible tokens
  end
end
