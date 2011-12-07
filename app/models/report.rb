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
#++

# == Bericht
#
# <b>Attribute:</b>
# * Anfangsdatum: period_start
# * Enddatum: period_end
#
# <b>Assoziationen (hat):</b>
# * beliebig viele Einträge: report_entries
# * einen Status : status
#
# <b>Assoziation (gehört zu):</b>
# * einem User : user
class Report < ActiveRecord::Base
  attr_accessible :period_start, :period_end, :reportnumber

  belongs_to :user
  has_many :report_entries, :dependent => :destroy
  has_one :status, :dependent => :destroy

  validates :period_start, :presence => true
  validates :period_end, :presence => true
  validates :user_id, :presence => true

  validate :period_end_after_period_start

  private
    def period_end_after_period_start
      if period_start and period_end
        errors.add(:period_end, 'Bis: muss nach Von: liegen.') if period_end < period_start
      end
    end
end
