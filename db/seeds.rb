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
  :name     => 'The Company',
  :zipcode  => '01234',
  :street   => 'TheStreet 1',
  :city     => 'TheCity'
)

ihk = Ihk.create(
  :name => 'Dresden'
)

job = Job.create(
  :name => 'Fachinformatiker'
)

code = Code.create(
  :name => 'Code 1',
  :codegroup => PrintReportsHelper::WEEKLY,
  :code => 'Vor- und Zuname <u>[v]userforename[/v] [v]username[/v]</u> Ausbildungsabteilung:<u>[v]jobname[/v]</u><br />
  <b>Ausbildungsnachweis Nr. </b><u>[v]reportweekstart[/v]</u> Monat <u>[v]reportmonth[/v] [v]reportyear[/v]</u> <u>[v]trainingyear[/v].</u> Ausbildungsjahr<br />

  <table border="1" width=595px style="border-collapse:collapse;">
  <colgroup>
    <col width=10%>
      <col width=90%>
      </colgroup>
      <tr>
      <th>Wochen</th>
      <th>Ausgef&uuml;hrte Arbeiten, Unterricht</th>
      </tr>

      <tr>
      <td rowspan="6">1. Woche</td>
      </tr>
      <tr>
      <td>[e]entry[0][0].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[0][1].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[0][2].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[0][3].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[0][4].text[e]</td>
      </tr>

      <tr>
      <td rowspan="6">2. Woche</td>
      </tr>
      <tr>
      <td>[e]entry[1][0].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[1][1].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[1][2].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[1][3].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[1][4].text[e]</td>
      </tr>

      <tr>
      <td rowspan="6">3. Woche</td>
      </tr>
      <tr>
      <td>[e]entry[2][0].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[2][1].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[2][2].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[2][3].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[2][4].text[e]</td>
      </tr>

      <tr>
      <td rowspan="6">4. Woche</td>
      </tr>
      <tr>
      <td>[e]entry[3][0].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[3][1].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[3][2].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[3][3].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[3][4].text[e]</td>
      </tr>

      <tr>
      <td rowspan="6">5. Woche</td>
      </tr>
      <tr>
      <td>[e]entry[4][0].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[4][1].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[4][2].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[4][3].text[e]</td>
      </tr>
      <tr>
      <td>[e]entry[4][4].text[e]</td>
      </tr>
      </table>

      <br /><br /><br />
      <b>Besondere Bemerkungen</b><br />
      <table border=\'1\' width=595px style="border-collapse:collapse;">
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
          <table border=\'1\' width=595px style="border-collapse:collapse;">
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

code2 = Code.create(
  :name => 'Code 2',
  :codegroup => PrintReportsHelper::DAILY,
  :code => 'Vor- und Zuname <u>[v]userforename[/v] [v]username[/v]</u> Ausbildungsabteilung:<u>[v]jobname[/v]</u><br />
  <b>Ausbildungsnachweis Nr. </b><u>[v]reportweekstart[/v]</u> Monat <u>[v]reportmonth[/v] [v]reportyear[/v]</u> <u>[v]trainingyear[/v].</u> Ausbildungsjahr<br />

  <table border="1" width=595px style="border-collapse:collapse;">
  <colgroup>
    <col width=10%>
      <col width=80%>
      <col width=10%>
      </colgroup>
      <tr>
      <th>Tag</th>
      <th>Ausgef&uuml;hrte Arbeiten, Unterricht</th>
      <th>Dauer</th>
      </tr>

      <tr>
      <td rowspan="6">Montag</td>
      </tr>
      <tr>
      <td>[e]entry[0][0].text[e]</td>
      <td>[e]entry[0][0].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[0][1].text[e]</td>
      <td>[e]entry[0][1].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[0][2].text[e]</td>
      <td>[e]entry[0][2].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[0][3].text[e]</td>
      <td>[e]entry[0][3].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[0][4].text[e]</td>
      <td>[e]entry[0][4].duration_in_hours[e]</td>
      </tr>

      <tr>
      <td rowspan="6">Dienstag</td>
      </tr>
      <tr>
      <td>[e]entry[1][0].text[e]</td>
      <td>[e]entry[1][0].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[1][1].text[e]</td>
      <td>[e]entry[1][1].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[1][2].text[e]</td>
      <td>[e]entry[1][2].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[1][3].text[e]</td>
      <td>[e]entry[1][3].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[1][4].text[e]</td>
      <td>[e]entry[1][4].duration_in_hours[e]</td>
      </tr>

      <tr>
      <td rowspan="6">Mittwoch</td>
      </tr>
      <tr>
      <td>[e]entry[2][0].text[e]</td>
      <td>[e]entry[2][0].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[2][1].text[e]</td>
      <td>[e]entry[2][1].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[2][2].text[e]</td>
      <td>[e]entry[2][2].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[2][3].text[e]</td>
      <td>[e]entry[2][3].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[2][4].text[e]</td>
      <td>[e]entry[2][4].duration_in_hours[e]</td>
      </tr>

      <tr>
      <td rowspan="6">Donnerstag</td>
      </tr>
      <tr>
      <td>[e]entry[3][0].text[e]</td>
      <td>[e]entry[3][0].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[3][1].text[e]</td>
      <td>[e]entry[3][1].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[3][2].text[e]</td>
      <td>[e]entry[3][2].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[3][3].text[e]</td>
      <td>[e]entry[3][3].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[3][4].text[e]</td>
      <td>[e]entry[3][4].duration_in_hours[e]</td>
      </tr>
      <tr>

      <td rowspan="6">Freitag</td>
      </tr>
      <tr>
      <td>[e]entry[4][0].text[e]</td>
      <td>[e]entry[4][0].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[4][1].text[e]</td>
      <td>[e]entry[4][1].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[4][2].text[e]</td>
      <td>[e]entry[4][2].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[4][3].text[e]</td>
      <td>[e]entry[4][3].duration_in_hours[e]</td>
      </tr>
      <tr>
      <td>[e]entry[4][4].text[e]</td>
      <td>[e]entry[4][4].duration_in_hours[e]</td>
      </tr>
      </table>

      <br /><br /><br />
      <b>Besondere Bemerkungen</b><br />
      <table border=\'1\' width=595px style="border-collapse:collapse;">
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
          <table border=\'1\' width=595px style="border-collapse:collapse;">
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

template2 = Template.create(
  :name => 'Vorlage 2',
  :code_id => code2.id,
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
  :trainingyear => 1,
  :role_id  => azubiRole.id,
  :business_id => business.id,
  :template_id => template.id,
  :pw_expired_at => Time.now.utc,
  :pw_recovery_hash => 'fail'
)

azubi2 = User.create(
  :name     => 'Auszubildender',
  :forename => 'Azubi',
  :email    => 'azubi2@swt.de',
  :password => '12345678',
  :password_confirmation => '12345678',
  :trainingyear => 1,
  :role_id  => azubiRole.id,
  :business_id => business.id,
  :template_id => template2.id,
  :pw_expired_at => Time.now.utc,
  :pw_recovery_hash => 'fail'
)

ausbilder.apprentices << azubi
ausbilder.apprentices << azubi2

azubi.save
azubi2.save

report = azubi.reports.create(
  :reportnumber => 1,
  :period_start => Date.new(2011,12,5),
  :period_end => Date.new(2011,12,30)
)

report.build_status(:stype => Status.personal)
report.save

report.report_entries.create(
  :date => DateTime.new(2011,12,5,12,0,0),
  :duration_in_hours => 8,
  :text => 'Oberflaeche fuer Angebotsmodul entworfen'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,6,12,0,0),
  :duration_in_hours => 8,
  :text => 'Datenbankwartung beim Kunden'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,7,12,0,0),
  :duration_in_hours => 8,
  :text => 'Installation und Konfiguration eines PCs'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,8,12,0,0),
  :duration_in_hours => 8,
  :text => 'Realisierung der entworfenen Oberflaeche'
)  

report.report_entries.create(
  :date => DateTime.new(2011,12,9,12,0,0),
  :duration_in_hours => 8,
  :text => 'Arbeitsbesprechung und weiterarbeiten an der Anwendung'
)
###################################################################
report.report_entries.create(
  :date => DateTime.new(2011,12,12,12,0,0),
  :duration_in_hours => 8,
  :text => 'Implementierung von Tests'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,13,12,0,0),
  :duration_in_hours => 8,
  :text => 'Einarbeitung in Ruby'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,14,12,0,0),
  :duration_in_hours => 8,
  :text => 'Installation und Konfiguration von Rails mit Apache'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,15,12,0,0),
  :duration_in_hours => 8,
  :text => 'Einlesen in die Anwendungsentwicklung Rails'
)  

report.report_entries.create(
  :date => DateTime.new(2011,12,16,12,0,0),
  :duration_in_hours => 8,
  :text => 'Arbeitsbesprechung und erste Rails-Tests'
)
###################################################################
report.report_entries.create(
  :date => DateTime.new(2011,12,19,12,0,0),
  :duration_in_hours => 8,
  :text => 'Anlegen der Modelle in Rails'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,20,12,0,0),
  :duration_in_hours => 8,
  :text => 'Bestimmen der Beziehungen zwischen den Models'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,21,12,0,0),
  :duration_in_hours => 8,
  :text => 'Anlegen der Controller'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,22,12,0,0),
  :duration_in_hours => 8,
  :text => 'Konfigurieren der Routen und anfangen der Controller-Realisierung'
)  

report.report_entries.create(
  :date => DateTime.new(2011,12,23,12,0,0),
  :duration_in_hours => 8,
  :text => 'Arbeitsbesprechung und Implementierung der Views'
)
###################################################################
report.report_entries.create(
  :date => DateTime.new(2011,12,26,12,0,0),
  :duration_in_hours => 8,
  :text => '2. Weihnachtstag'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,27,12,0,0),
  :duration_in_hours => 8,
  :text => 'Urlaub'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,28,12,0,0),
  :duration_in_hours => 8,
  :text => 'Schreiben der Tests in Rails'
)

report.report_entries.create(
  :date => DateTime.new(2011,12,29,12,0,0),
  :duration_in_hours => 8,
  :text => 'Letzte Taetigkeiten am Rails-Programm'
)  

report.report_entries.create(
  :date => DateTime.new(2011,12,30,12,0,0),
  :duration_in_hours => 8,
  :text => 'Urlaub'
)
###################################################################
report = azubi2.reports.create(
  :reportnumber => 1,
  :period_start => Date.new(2012,1,2),
  :period_end => Date.new(2012,1,9)
)

report.build_status(:stype => Status.personal)
report.save

