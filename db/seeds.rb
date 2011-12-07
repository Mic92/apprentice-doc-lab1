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

ausbilderRole = Role.create(
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
  :admin  => false,
  :trainingyear => 1
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
  :code => 'Vor- und Zuname <u>[v]userforename[/v] [v]username[/v]</u> Ausbildungsabteilung:<u>[v]jobname[/v]</u><br />
  <b>Ausbildungsnachweis Nr. </b><u>[v]reportnumber[/v]</u> Monat <u>[v]reportmonth[/v] [v]reportyear[/v]</u> <u>[v]trainingyear[/v].</u> Ausbildungsjahr<br />

  <table width=100% border="1" style="border-collapse:collapse">
  <colgroup>
    <col width=10%>
      <col width=90%>
      </colgroup>
      <tr>
      <th>Wochen</th>
      <th>Ausgef&uuml;hrte Arbeiten, Unterricht</th>
      </tr>

      <tr>
      <td rowspan="7">1. Woche</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[0][0].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[0][1].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[0][2].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[0][3].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[0][4].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[0][5].text[e]</td>
      </tr>

      <tr>
      <td rowspan="7">2. Woche</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[1][0].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[1][1].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[1][2].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[1][3].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[1][4].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[1][5].text[e]</td>
      </tr>

      <tr>
      <td rowspan="7">3. Woche</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[2][0].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[2][1].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[2][2].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[2][3].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[2][4].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[2][5].text[e]</td>
      </tr>

      <tr>
      <td rowspan="7">4. Woche</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[3][0].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[3][1].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[3][2].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[3][3].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[3][4].text[e]</td>
      </tr>
      <tr>
      <td>&nbsp;[e]entry[3][5].text[e]</td>
      </tr>
      </table>

      <br /><br /><br />
      <b>Besondere Bemerkungen</b><br />
      <table width=100% border=\'1\' style="border-collapse:collapse">
      <colgroup>
        <col width=50%>
          <col width=50%>
          </colgroup>
          <tr>
          <td>Auszubildender</td>
          <td>Ausbildender bzw. Ausbilder</td>
          </tr>
          <tr>
          <td><br /><br /><br /></td>
          <td><br /><br /><br /></td>
          </tr>
          </table>
          <br />

          <b>F&uuml;r die Richtigkeit</b><br />
          <table width=100% border=\'1\' style="border-collapse:collapse">
          <colgroup>
            <col width=50%>
              <col width=50%>
              </colgroup>
              <tr>
              <td><br /><br />
              <u>[v]currentdate[/v]</u><br />
              Datum, Unterschrift des Auszubildenden
              </td>
              <td><br /><br />
              <u>[v]currentdate[/v]</u><br />
              Datum, Unterschrift des Ausbildenden bzw. Ausbilders
              </td>
              </tr>
              </table>'
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
  :template_id => template.id,
  :pw_expired_at => Time.now.utc,
  :pw_recovery_hash => 'fail'
)

ausbilder = User.create(
  :name     => 'Ausbilder',
  :forename => 'Ausbi',
  :email    => 'ausbilder@swt.de',
  :password => '12345678',
  :password_confirmation => '12345678',
  :role_id  => ausbilderRole.id,
  :business_id => business.id,
  :template_id => template.id,
  :pw_expired_at => Time.now.utc,
  :pw_recovery_hash => 'fail'
)

azubi = User.create(
  :name     => 'Auszubildender',
  :forename => 'Azubi',
  :email    => 'azubi@swt.de',
  :password => '12345678',
  :password_confirmation => '12345678',
  :role_id  => azubiRole.id,
  :business_id => business.id,
  :template_id => template.id,
  :pw_expired_at => Time.now.utc,
  :pw_recovery_hash => 'fail'
)

ausbilder.apprentices << azubi
