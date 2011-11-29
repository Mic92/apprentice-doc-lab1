# encoding: utf-8
#
# Copyright (C) 2011,
# Sascha Peukert <sascha.peukert@gmail.com>
# Marcus Hänsch >haensch.marcus@googlemail.com>
#
# This file is part of ApprenticeDocLab1, an application written for
# buschmais GbR <http://www.buschmais.de/>.
#
# ApprenticeDocLab1 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# ApprenticeDocLab1 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ApprenticeDocLab1.  If not, see <http://www.gnu.org/licenses/>.

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :forename, :zipcode, :street, :city, :email, :password, :password_confirmation, :role_id
  belongs_to :role
  belongs_to :business
  belongs_to :instructor, :class_name => "User", :foreign_key => "instructor_id"
  has_many :reports
  has_many :apprentices, :class_name => "User", :foreign_key => "instructor_id"
  belongs_to :template

  validates :role_id, :name, :forename, :presence => true
  validates :email, :uniqueness => true, :presence => true,
            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i },
            :length => { :in => 5..40}


  validates :password, :confirmation => true, :length => { :in => 8..40 }, :presence => true, :if => :password_required?
  validates :password_confirmation, :presence => true, :if => :password_required?

  before_save :encrypt_new_password, :if => :password_required?


  def has_password?(submitted_pwd)
    hashed_password == encrypt(submitted_pwd)
  end

  def self.authenticate(email, submitted_pwd)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_pwd)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil  #If-Else Operator
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

    def password_required?
      hashed_password.blank? || password.present?
    end
end
