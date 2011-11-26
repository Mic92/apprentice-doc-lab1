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

  belongs_to :report

  validates :report_id, :presence => true
  validates :date, :presence => true
  validates :duration_in_hours, :presence => true, :numericality => { :greater_than => 0 }
  validates :text, :presence => true
end
