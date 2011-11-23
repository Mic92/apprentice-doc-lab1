class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :forename, :zipcode, :street, :city, :email, :hashed_password, :salt
  belongs_to :role
  belongs_to :business
  belongs_to :instructor, :class_name => "User", :foreign_key => "instructor_id"
  has_many :reports
  has_many :apprentices, :class_name => "User", :foreign_key => "instructor_id"
  
  
  before_save :encrypt_new_password
  
  
  def has_password?(submitted_pwd)				
    hashed_password == encrypt(submitted_pwd)
  end
  
  def self.authenticate(email, submitted_pwd)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_pwd)		
  end
  
  private

    def encrypt_new_password
      self.salt = make_salt unless has_password?(password)
      self.hashed_password = encrypt(password)
    end

    def encrypt(string)
      security_hash("#{salt}--#{string}")
    end

    def make_salt
      security_hash("#{Time.now.utc}--#{password}")
    end

    def security_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  end
  
end
