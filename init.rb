# Redmine plugin for Better Overviews
# Copyright (C) 2018    Massimo Rossello 
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'redmine'
require 'deface'

Rails.logger.info 'Better project overview'

plugin = Redmine::Plugin.register :redmine_better_overview do
  name 'Redmine Better Project Overview plugin'
  author 'Massimo Rossello'
  description 'Displays a better project overview'
  version '6.0.1'
  url 'https://github.com/maxrossello/redmine_better_overview.git'
  author_url 'https://github.com/maxrossello'
  requires_redmine :version_or_higher => '6.0.1'
end

# missing in first version of redmine_base_deface for Rails 6.1      
Dir.glob("#{Rails.root}/plugins/redmine_better_overview/app/overrides/**/*.deface").each do |path|
  Deface::DSL::Loader::load File.expand_path(path, __FILE__)
end

Rails.configuration.after_initialize do
    plugin.requires_redmine_plugin :redmine_base_deface, '6.0.1'
end

ProjectsController.send(:helper, :reports)
