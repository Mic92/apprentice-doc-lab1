# encoding: utf-8
#--
# Copyright (C) 2011, Dominik Cermak <d.cermak@arcor.de>
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
#--

# == Eintrag
#
# <b>Attribute:</b>
# * Datum: date
# * Dauer in Stunden: duration_in_hours
# * Text: text
#
# <b>Assoziation (gehört zu)</b>
# * einem Report : report
class ReportEntry < ActiveRecord::Base
  attr_accessible :date, :duration_in_hours, :text

  belongs_to :report, :counter_cache => true

  validates :report_id, :presence => true
  validates :date, :presence => true
  validates_uniqueness_of :date, scope: :report_id, if: lambda { date_changed? }

#  validates :duration_in_hours, :presence => true
  validates :text, :presence => true

  validate :is_in_report_period

#  validate :duration_in_hours_greater_than_zero

  private
    def duration_in_hours_greater_than_zero
      if duration_in_hours
        errors[:base] << 'Dauer muss größer als 0 sein' if duration_in_hours <= 0
      end
    end

    def is_in_report_period
      unless date >= report.period_start && date <= report.period_end
        errors.add(:date, 'muss im Zeitraum des Berichts liegen')
      end
    end
end
