# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

adminRole = Role.create(
  :name   => 'Administrator',
  :level  => 1,
  :read   => true,
  :commit => true,
  :export => true,
  :check  => true,
  :modify => true,
  :admin  => true
)

Role.create(
  :name   => 'Ausbilder',
  :level  => 2,
  :read   => true,
  :commit => false,
  :export => true,
  :check  => true,
  :modify => true,
  :admin  => false
)

azubiRole = Role.create(
  :name   => 'Azubi',
  :level  => 3,
  :read   => true,
  :commit => true,
  :export => true,
  :check  => false,
  :modify => false,
  :admin  => false
)

business = Business.create(
  :name     => 'Buschmais',
  :zipcode  => '01234',
  :street   => 'TheStreet 1',
  :city     => 'Dresden'
)

admin = User.create(
  :name     => 'Administrator',
  :forename => 'Admin',
  :email    => 'admin@swt.de',
  :password => '12345678',
  :password_confirmation => '12345678',
  :role_id  => adminRole.id,
  :business_id => business.id
)

azubi = User.create(
  :name     => 'Auszubildender',
  :forename => 'Azubi',
  :email    => 'azubi@swt.de',
  :password => '12345678',
  :password_confirmation => '12345678',
  :role_id  => azubiRole.id,
  :business_id => business.id
)
