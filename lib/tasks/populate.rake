namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    create_sample_data
  end
end

def create_sample_data
  period_start = Time.utc(2009, 1, 1)
  period_end   = period_start + 1.year
  names = %w{Hans Paul Peter}
  3.times do |i|
    azubi = User.create(
     name:     names[i],
     forename: names[i],
     email:    "azubi#{i}@example.org",
     password: '12345678',
     password_confirmation: '12345678',
     role_id:  Role.find_by_name("Azubi").id,
     business_id: Business.first.id,
     template_id: Template.first.id,
     pw_expired_at: Time.now.utc,
     pw_recovery_hash: 'fail',
     zipcode: 12345,
     street: "Azubiallee #{i}",
     city: "Azubihausen",
     trainingbegin: Time.now.utc,
     trainingyear: 10
    )
    report = azubi.reports.build(
      period_start: period_start + i.year,
      period_end: period_end + i.year,
      reportnumber: (azubi.reports.count + 1)
    )
    report.save
    report.build_status(:stype => Status.personal).save
    3.times do |j|
      report.report_entries.build(
        date: period_start + j.days,
        duration_in_hours: (j+1),
        text: "Bla" * (j+1)
      ).save
    end
  end
end
