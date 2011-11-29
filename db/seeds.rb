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

ihk = Ihk.create(
  :name => 'Dresden'
)

job = Job.create(
  :name => 'Fachinformatiker'
)

code = Code.create(
  :name => 'Code 1',
  :codegroup => 3,
  :code => 'Hallo [v]userforename[/v] [v]username[/v]<br /> 
  Woche 1:<br />
  [e]entry[0][0].text[e]<br />
  [e]entry[0][1].text[e]<br />
  [e]entry[0][2].text[e]<br />
  [e]entry[0][3].text[e]<br />

  Woche 2:<br />
  [e]entry[1][0].text[e]<br />
  [e]entry[1][1].text[e]<br />
  [e]entry[1][2].text[e]<br />
  [e]entry[1][3].text[e]<br />

  Woche 3:<br />

  [e]entry[2][0].text[e]<br />
  [e]entry[2][1].text[e]<br />
  [e]entry[2][2].text[e]<br />
  [e]entry[2][3].text[e]<br />'
)

template = Template.create(
  :name => 'Vorlage 1',
  :code_id => code.id,
  :job_id => job.id,
  :ihk_id => ihk.id
)

admin = User.create(
  :name     => 'Administrator',
  :forename => 'Admin',
  :email    => 'admin@swt.de',
  :password => '12345678',
  :password_confirmation => '12345678',
  :role_id  => adminRole.id,
  :business_id => business.id,
  :template_id => template.id
)

azubi = User.create(
  :name     => 'Auszubildender',
  :forename => 'Azubi',
  :email    => 'azubi@swt.de',
  :password => '12345678',
  :password_confirmation => '12345678',
  :role_id  => azubiRole.id,
  :business_id => business.id,
  :template_id => template.id
)
