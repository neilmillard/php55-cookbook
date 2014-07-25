#
# Author:: Adar Porat(<adar.porat@gmail.com>)
# Cookbook Name:: php55
# Attribute:: default
##
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node[:platform]
    
    when "amazon"
    # node.set['php']['packages'] = ['php55w', 'php55w-devel', 'php55w-cli', 'php55w-snmp', 'php55w-soap', 'php55w-xml', 'php55w-xmlrpc', 'php55w-process', 'php55w-mysqlnd', 'php55w-pecl-memcache', 'php55w-opcache', 'php55w-pdo', 'php55w-imap', 'php55w-mbstring']
    # we are going to use aws yum repo.
    node.set['mysql']['server']['packages'] = %w{mysql55-server}
    node.set['mysql']['client']['packages'] = %w{mysql55}
    
    # remove any existing php/mysql
    execute "yum remove -y php* mysql*"
    
    # get the metadata - not really needed
    execute "yum -q makecache"
    
    # manually install php 5.5....
    execute "yum install -y php55 php55-devel php55-cli php55-snmp php55-soap php55-xml php55-xmlrpc php55-process php55-mysqlnd php55-pecl-memcache php55-opcache php55-pdo php55-imap php55-mbstring"

  when "rhel", "fedora", "suse", "centos"
  # add the webtatic repository
  yum_repository "webtatic" do
    repo_name "webtatic"
    description "webtatic Stable repo"
    url "http://repo.webtatic.com/yum/el6/x86_64/"
    key "RPM-GPG-KEY-webtatic-andy"
    action :add
  end

  yum_key "RPM-GPG-KEY-webtatic-andy" do
    url "http://repo.webtatic.com/yum/RPM-GPG-KEY-webtatic-andy"
    action :add
  end
  
  node.set['php']['packages'] = ['php55w', 'php55w-devel', 'php55w-cli', 'php55w-snmp', 'php55w-soap', 'php55w-xml', 'php55w-xmlrpc', 'php55w-process', 'php55w-mysqlnd', 'php55w-pecl-memcache', 'php55w-opcache', 'php55w-pdo', 'php55w-imap', 'php55w-mbstring']
  node.set['mysql']['server']['packages'] = %w{mysql55-server}
  node.set['mysql']['client']['packages'] = %w{mysql55}
  
  include_recipe "php"

  when "debian"
    include_recipe "apt"
	apt_repository "wheezy-php55" do
		uri "#{node['php55']['dotdeb']['uri']}"
		distribution "#{node['php55']['dotdeb']['distribution']}-php55"
		components ['all']
		key "http://www.dotdeb.org/dotdeb.gpg"
		action :add
	end
	
	  include_recipe "php"
  end
