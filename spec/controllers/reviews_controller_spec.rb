# encoding: utf-8
#
# Copyright (C) 2011, Max Löwen <Max.Loewen@mailbox.tu-dresden.de>
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

describe ReviewsController do
  before(:each) do
    @apprentice = User.create valid_attributes_user.merge(:email => 'apprentis@mustermann.de')
    @role_a = Role.create valid_attributes_role_azubi
    @role_a.users << @apprentice
    @instructor = User.create valid_attributes_user.merge(:email => 'instructor@mustermann.de')
    @role_i = Role.create valid_attributes_role_ausbilder
    @role_i.users << @instructor
    @instructor.apprentices << @apprentice
    @report_p = @apprentice.reports.create valid_attributes_report
    @report_c = @apprentice.reports.create valid_attributes_report
    @report_r = @apprentice.reports.create valid_attributes_report
    @report_a = @apprentice.reports.create valid_attributes_report
    @status_p = @report_p.create_status valid_attributes_status.merge(:stype => Status.personal)
    @status_c = @report_c.create_status valid_attributes_status.merge(:stype => Status.commited)
    @status_r = @report_r.create_status valid_attributes_status.merge(:stype => Status.rejected)
    @status_a = @report_a.create_status valid_attributes_status.merge(:stype => Status.accepted)
  end

  describe "method tests for apprentice" do
    before(:each) do
      test_sign_in(@apprentice)
    end

    describe "POST 'create' #commit report" do
      it "should redirect to the reports page" do
        post 'create', :report_id => @report_p
        response.should redirect_to(reports_path)
      end

      it "should change status to commited" do
        expect {
          post 'create', :report_id => @report_p
        }.to change { Status.find(@report_p.status).updated_at }
        Report.find(@report_p).status.stype.should eq(Status.commited)
      end

      it "should have a flash message" do
        post 'create', :report_id => @report_p
        flash[:notice].should =~ /erfolgreich/i
      end

      it "should expand the comment if there is one" do
        @report_p.status.comment = 'testcomment'
        @report_p.status.save
        post 'create', :report_id => @report_p
        Report.find(@report_p).status.comment.should =~ /Dieser Bericht wurde damals aus folgendem Grund abgelehnt:\n/i
      end
      describe "report doesnt belong to current_user" do
        before(:each) do
          @apprentice_2 = User.create valid_attributes_user.merge(:email => 'apprentice_2@mustermann.de')
          @role_a.users << @apprentice_2
          @instructor.apprentices << @apprentice_2
          test_sign_in(@apprentice_2)
        end

        it "should require current_user to have this report" do
          post 'create', :report_id => @report_p
          response.should redirect_to(welcome_path)
        end

        it "should not change status" do
          expect {
            post 'create', :report_id => @report_p
          }.not_to change { Status.find(@report_p.status).updated_at }
        end
      end
    end

    describe "PUT 'update'" do
      it "should require matching users for 'update'" do
        put 'update', :id => @report_p
        response.should redirect_to(welcome_path)
      end
    end

    describe "delete 'destroy' #withdraw commit" do
      it "should redirect to the reports page" do
        delete 'destroy', :id => @report_c
        response.should redirect_to(reports_path)
      end

      it "should change status to personal" do
        expect {
          delete 'destroy', :id => @report_c
        }.to change { Status.find(@report_c.status).updated_at }
        Report.find(@report_c).status.stype.should eq(Status.personal)
      end

      it "should have a flash message" do
        delete 'destroy', :id => @report_c
        flash[:notice].should =~ /erfolgreich/i
      end

      describe "report doesnt belong to current_user" do
        before(:each) do
          @apprentice_2 = User.create valid_attributes_user.merge(:email => 'apprentice_2@mustermann.de')
          @role_a.users << @apprentice_2
          @instructor.apprentices << @apprentice_2
          test_sign_in(@apprentice_2)
        end

        it "should require current_user to have this report" do
          delete 'destroy', :id => @report_c
          response.should redirect_to(welcome_path)
        end

        it "should not change status" do
          expect {
            delete 'destroy', :id => @report_c
          }.not_to change { Status.find(@report_c.status).updated_at }
        end
      end
    end
  end

  describe "method tests for instructor" do
    before(:each) do
      test_sign_in(@instructor)
    end

    describe "POST 'create'" do
      it "should require matching users for 'create'" do
        post 'create', :report_id => @report_c
        response.should redirect_to(welcome_path)
      end
    end

    describe "PUT 'update' #reject report" do
      it "should redirect to the reports page" do
        put 'update', :id => @report_c, :status => { :comment => 'testcomment' }
        response.should redirect_to(reports_path)
      end

      it "should change status to rejected" do
        expect {
          put 'update', :id => @report_c, :status => { :comment => 'testcomment' }
        }.to change { Status.find(@report_c.status).updated_at }
        Report.find(@report_c).status.stype.should eq(Status.rejected)
      end

      it "should have a flash message" do
        put 'update', :id => @report_c, :status => { :comment => 'testcomment' }
        flash[:notice].should =~ /erfolgreich/i
      end

      describe "comment wasnt set" do
        it "should not change status" do
          expect {
            put 'update', :id => @report_c, :status => { :comment => '' }
          }.not_to change { Status.find(@report_c.status).updated_at }
        end

        it "should have a alert-flash message" do
          put 'update', :id => @report_c, :status => { :comment => '' }
          flash[:alert].should =~ /fehlgeschlagen/i
        end

        it "should redirect to the rejectcomment page" do
          put 'update', :id => @report_c, :status => { :comment => '' }
          response.should redirect_to(edit_review_path)
        end
      end

      describe "instructor hasn't this apprentice" do
        before(:each) do
          @instructor2 = User.create! valid_attributes_user.merge(:email => 'instructor2@mustermann.de')
          @role_i.users << @instructor2
          test_sign_in(@instructor2)
        end

        it "should be also able to change status" do
          expect {
            put 'update', :id => @report_c, :status => { :comment => 'testcomment' }
          }.to change { Status.find(@report_c.status).updated_at }
        end
      end
    end

    describe "delete 'destroy' #accept report" do
      it "should redirect to the reports page" do
        delete 'destroy', :id => @report_c
        response.should redirect_to(reports_path)
      end

      it "should change status to accepted" do
        expect {
          delete 'destroy', :id => @report_c
        }.to change { Status.find(@report_c.status).updated_at }
        Report.find(@report_c).status.stype.should eq(Status.accepted)
      end

      it "should have a flash message" do
        delete 'destroy', :id => @report_c
        flash[:notice].should =~ /erfolgreich/i
      end

      it "should delete the comment" do
        delete 'destroy', :id => @report_c
        Report.find(@report_c).status.comment.should eq('')
      end

      describe "instructor hasn't this apprentice" do
        before(:each) do
          @instructor2 = User.create! valid_attributes_user.merge(:email => 'instructor2@mustermann.de')
          @role_i.users << @instructor2
          test_sign_in(@instructor2)
        end

        it "should be also able to change status" do
          expect {
            delete 'destroy', :id => @report_c
          }.to change { Status.find(@report_c.status).updated_at }
        end
      end
    end
  end
end
