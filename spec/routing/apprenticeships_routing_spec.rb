# encoding: utf-8
#
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

require 'spec_helper'

describe ApprenticeshipsController do
  describe "routing" do
    it "routes to #index" do
      get('/apprenticeships').should route_to('apprenticeships#index')
    end

    it "routes to #create" do
      post('/apprenticeships').should route_to('apprenticeships#create')
    end

    it "routes to #destroy" do
      delete('/apprenticeships/1').should route_to('apprenticeships#destroy', :id => '1')
    end
  end
end
