module PrintReportsHelper

  def init
    @displayCode = @rawCode
    @user = @report.user
    @reportEntries = @report.report_entries ||= []
    @simpleFunctions = Hash.new
    @simpleFunctions['username'] = :username
    @simpleFunctions['userforename'] = :userforename
    @simpleFunctions['jobname'] = :jobname
    #...

    @entryFunctions = Hash.new
    @entryFunctions['text'] = :text
    @entryFunctions['date'] = :date
    @entryFunctions['durations_in_hours'] = :durations_in_hours
  end

  def handleRawCode
    self.init
    #replace simple values
    @simpleFunctions.each { |key, value|
      @displayCode.gsub!("[v]#{key}[/v]",self.send(value))
    }

    #replace complex values
    @splitted = @displayCode.split("[e]")
    @displayCode.clear
    @splitted.each do |splitVal|
      value = splitVal
      #check if value is like entries[<number>]
      if splitVal.match('entry[/^\[\d\]*$/]')
        splitVal.strip!
        #split the number between the []
        entry = splitVal.split(/[\[\]\.]/)
        entryNo = entry[1].to_i
        entryValue = entry[3]
        value = self.entry(entryNo,entryValue)
      end
      @displayCode << value
    end
  end

  def username
    @user.name ||= ''
  end

  def userforename
    @user.forename ||= ''
  end

  def jobname
    @user.template.job.name ||= ''
  end

  def entry(number, value)
    entry = @reportEntries[number]
    if entry
      entry.send(@entryFunctions[value])
    else
      ''
    end
  end
end
