# Redmine - project management software
# Copyright (C) 2006-2017  Jean-Philippe Lang
#
# Redmine plugin for Better Overviews
# Copyright (C) 2018    Massimo Rossello 
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.expand_path('../../test_helper', __FILE__)

class ProjectsControllerTest < Redmine::ControllerTest
  fixtures :projects, :custom_fields, :custom_values,
           :users, :roles, :members, :member_roles

  def setup
    @request.session[:user_id] = nil
    Setting.default_language = 'en'
  end

  def test_show_should_display_description_in_a_box
    get :show, :params => {
        :id => 'ecookbook'
      }
    assert_response :success

    assert_select '.box p', :text => /Recipes management application/
  end

  def test_show_should_display_homepage_in_a_box
    get :show, :params => {
        :id => 'ecookbook'
      }
    assert_response :success

    assert_select '.box h3', :text => /Homepage/
    assert_select '.homepage a'
  end

  def test_show_should_display_visible_custom_fields_in_a_box
    cf = ProjectCustomField.find_by_name('Development status')
    cf.update_attribute :visible, true
    get :show, :params => {
        :id => 'ecookbook'
      }
    assert_response :success

    assert_select ".box h3.cf_#{cf.id}", :text => /#{cf.name}/
    assert_select '.custom.box', :text => /Stable/
  end

  def test_show_should_not_display_blank_custom_fields_with_multiple_values
    f1 = ProjectCustomField.generate! :field_format => 'list', :possible_values => %w(Foo Bar), :multiple => true
    f2 = ProjectCustomField.generate! :field_format => 'list', :possible_values => %w(Baz Qux), :multiple => true
    project = Project.generate!(:custom_field_values => {f2.id.to_s => %w(Qux)})

    get :show, :params => {
        :id => project.id
      }
    assert_response :success

    assert_select 'h3', :text => /#{f1.name}/, :count => 0
    assert_select 'h3', :text => /#{f2.name}/
  end

  def test_show_should_display_visible_child_projects_in_a_box
    get :show, :params => {
        :id => 'ecookbook'
      }
    assert_response :success

    assert_select '.box h3', :text => /#{I18n.t(:label_subproject_plural)}/
    assert_select '.projects .list a', :text => /eCookbook Subproject 1/
    assert_select '.projects .list a', :text => /eCookbook Subproject 2/
    assert_select '.projects .list a', :text => /Private child of eCookbook/, :count => 0
  end

  def test_show_should_display_users_private_child_projects_in_a_box
    @request.session[:user_id] = 2 # manager who is a member of the private subproject
    get :show, :params => {
        :id => 'ecookbook'
      }
    assert_response :success

    assert_select '.box h3', :text => /#{I18n.t(:label_subproject_plural)}/
    assert_select '.projects .list a', :text => /eCookbook Subproject 1/
    assert_select '.projects .list a', :text => /eCookbook Subproject 2/
    assert_select '.projects .list a', :text => /Private child of eCookbook/
  end

end
