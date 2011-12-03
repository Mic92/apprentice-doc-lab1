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

describe "apprenticeships/index.html.erb" do
  before(:each) do
    @apprentice1 = mock_model(User, :name => 'Azubi',
                             :forename => 'One')
    @apprentice2 = mock_model(User, :name => 'Azubi',
                             :forename => 'Two')
    @apprentice3 = mock_model(User, :name => 'Azubi',
                             :forename => 'Three')
    @apprentice4 = mock_model(User, :name => 'Azubi',
                             :forename => 'Three')
    assign(:own_apprentices, [ @apprentice1, @apprentice2 ])
    assign(:free_apprentices, [ @apprentice3, @apprentice4 ])
  end

  it "should display the names of the apprentices assingned to the user" do
    render
    rendered.should include(@apprentice1.name, @apprentice2.name,
                            @apprentice1.forename, @apprentice2.forename)
  end

  it "should have links to delete the assignment" do
    render
    rendered.should include("href=\"#{apprenticeship_path(@apprentice1.id)}\"",
                            "href=\"#{apprenticeship_path(@apprentice2.id)}\"",
                            'data-method="delete"')
  end

  it "should display apprentices not assigned to anybody" do
    render
    rendered.should include(@apprentice3.name, @apprentice4.name,
                            @apprentice3.forename, @apprentice4.forename)
  end

  it "should have links to assign free apprentices" do
    render
    rendered.should include("href=\"#{apprenticeships_path(:apprentice_id => @apprentice3.id)}\"",
                            "href=\"#{apprenticeships_path(:apprentice_id => @apprentice4.id)}\"",
                            'data-method="post"')
  end
end
