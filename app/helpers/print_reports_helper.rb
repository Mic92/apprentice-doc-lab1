module PrintReportsHelper
  HOURLY = 1
  DAILY = 2
  WEEKLY = 3

  def init
    @displayCode = @rawCode
    @user = @report.user
    self.groupEntries

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

  def groupEntries
    @reportEntries = @report.report_entries ||= []
    @groupedEntries = []
    grouper = Hash.new
    
    dtStart = @report.period_start.to_datetime
    dtEnd = @report.period_end.to_datetime
    dtCur = dtStart

    # add empty values, to prevent wrong sorting
    while dtCur <= dtEnd
      offset = 0.0
      if @code.codegroup == DAILY
        key = dtCur.yday
        offset = 1.0 # add one day
      elsif @code.codegroup == WEEKLY
        key = dtCur.cweek
        offset = 7.0 # add seven days
      elsif @code.codegroup == HOURLY
        key = "#{dtCur.yday}-#{dtCur.hour}"
        offset = 1.0/24.0 # add one hour
      end
      grouper[key] = []
      dtCur += offset
    end
    
    #group each entry to the timeframe
    @reportEntries.each do |entry|
      dt = entry.date.to_datetime
      if @code.codegroup == DAILY
        key = dt.yday
      elsif @code.codegroup == WEEKLY
        key = dt.cweek
      elsif @code.codegroup == HOURLY
        key = "#{dt.yday}-#{dt.hour}"
      end      
      if grouper[key].nil?
        grouper[key] = []
      end
      grouper[key] << entry
    end
    @groupedEntries = grouper.values.to_a
  end

  # entry point of this class
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
      #check if value is like entries[<number>][<number>].<attribute>
      #TODO matching does not work correctly
      if splitVal.match('entry[/^\[\d\]*$/]')
        splitVal.strip!
        #split the number between the []
        entry = splitVal.split(/[\[\]\.]/)
        entryNo = entry[1].to_i
        entryGroup = entry[3].to_i
        entryValue = entry[5]
        value = self.entry(entryNo,entryGroup,entryValue)
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

  def entry(group, number, value)
    entriesGroup = @groupedEntries[group]
    if not entriesGroup.nil?
      entry = entriesGroup[number]
      if not entry.nil?
        entry.send(@entryFunctions[value])
      else
        ""
      end
    else
      ""
    end
  end
end
