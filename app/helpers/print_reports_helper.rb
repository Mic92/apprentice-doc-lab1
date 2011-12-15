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
    @simpleFunctions['reportmonth'] = :reportmonth
    @simpleFunctions['reportyear'] = :reportyear
    @simpleFunctions['currentdate'] = :currentdate
    @simpleFunctions['trainingyear'] = :trainingyear
    @simpleFunctions['reportnumber'] = :reportnumber
    @simpleFunctions['reportweekstart'] = :reportweekstart
    @simpleFunctions['reportweekend'] = :reportweekend
    #...

    @entryFunctions = Hash.new
    @entryFunctions['text'] = :text
    @entryFunctions['date'] = :date
    @entryFunctions['duration_in_hours'] = :duration_in_hours
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

  def replaceNonEditableValues
    #replace simple values
    @simpleFunctions.each { |key, value|
      @displayCode.gsub!("[v]#{key}[/v]",self.send(value).to_s)
    }
  end
  
  def replaceEditableValues(formatMethod)
    #replace complex values
    @splitted = @displayCode.split("[e]")
    @displayCode.clear
    @splitted.each do |splitVal|
      value = splitVal
      #check if value is like entries[<number>][<number>].<attribute>
      if splitVal.match('entry\[[0-9]+\]\[[0-9]+\]\..*$')
        splitVal.strip!
        #split the number between the []
        entry = splitVal.split(/[\[\]\.]/)
        entryNo = entry[1].to_i
        entryGroup = entry[3].to_i
        entryValue = entry[5]
        value = self.entry(entryNo,entryGroup,entryValue)
        value = formatMethod.call(value,entryNo,entryGroup,entryValue)
      end
      @displayCode << value
    end
  end
  
  def displayValueFormat(value,entryNo,entryGroup,entryValue)
    "&nbsp;"+value.to_s
  end

  def editValueFormat(value,entryNo,entryGroup,entryValue)
    pream = "entry_#{entryNo}_#{entryGroup}"
    "<input id=\"#{pream}_#{entryValue}\" name=\"#{pream}[#{entryValue}]\" type=\"text\" style=\"width:95%;\" value=\"#{value}\" />"
  end
  
  # entry point of this class
  def handleRawCode
    self.init
    self.replaceNonEditableValues

    self.replaceEditableValues(method(:displayValueFormat))
  end

  # entry point of this class
  def editRawCode
    self.init
    self.replaceNonEditableValues
    
    self.replaceEditableValues(method(:editValueFormat))
  end

  def username
    @user.name ||= ''
  end

  def userforename
    @user.forename ||= ''
  end
  
  def trainingyear
    @user.trainingyear ||= ''
  end
  
  def reportnumber
    @report.reportnumber ||= ''
  end

  def jobname
    @user.template.job.name ||= ''
  end
  
  def reportmonth
    @report.period_start.strftime('%B')
  end
  
  def reportyear
    @report.period_start.year
  end
  
  def reportweekstart
    @report.period_start.cweek
  end

  def reportweekend
    @report.period_end.cweek
  end

  def currentdate
    DateTime.now.strftime('%d.%m.%Y')
  end

  def entry(group, number, value)
    entriesGroup = @groupedEntries[group]
    retVal = ""
    if not entriesGroup.nil?
      entry = entriesGroup[number]
      if not entry.nil?
        retVal = entry.send(@entryFunctions[value])
      end
    end
    retVal
  end
  
  def handleSubmittedReport(params)
    self.init
    
    puts @groupedEntries
    
    params.each { |key, value|
      if key.match('entry_[0-9]+_[0-9]+')
        entryPlace = key.split('_')
        entryNo = entryPlace[1].to_i
        entryGroup = entryPlace[2].to_i
        
        #entry = @groupedEntries[entryGroup][entryNo]
        entriesGroup = @groupedEntries[entryNo]
        if not entriesGroup.nil?
          entry = entriesGroup[entryGroup]
        end
        
        if entry.nil?
          entry = @report.report_entries.new

          dtStart = @report.period_start.to_datetime
          dtCur = dtStart + 8.hours
          newDate = DateTime.now
          if @code.codegroup == DAILY
            entry.duration_in_hours = 1.0
            newDate = dtCur + entryNo.days + entryGroup.hours
          elsif @code.codegroup == WEEKLY
            newDate = dtCur + entryNo.weeks + entryGroup.days
            entry.duration_in_hours = 8.0
          elsif @code.codegroup == HOURLY
            newDate = dtCur + entryNo.hours + entryGroup.minutes
            entry.duration_in_hours = 1.0/60.0
          end
          entry.date = newDate
        end

        value.each { |valKey, valValue|
          entryMeth = valKey+"="
          value = valValue
          # quick fix
          if valKey.eql?('duration_in_hours')
            value = value.to_i
            if value == 0
              value = 0.5
            end
          end
          entry.send(entryMeth, value)
        }
        entry.save
      end
    }
  end
end
