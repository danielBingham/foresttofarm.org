
#######################################
#   General Configuration
#######################################

# The root directory for Forest to Farm's source, a vagrant share directory.
default['foresttofarm.org']['source_directory'] = '/srv/www/foresttofarm.org'
default['foresttofarm.org']['config_directory'] = '/srv/www/foresttofarm.org/app/config'
default['foresttofarm.org']['secret_key'] = 'abcdefghijklmnop'

#######################################
#   PHP Configuration
#######################################

default['foresttofarm.org']['php']['config_file_path'] = '/etc/php5/apache2/php.ini'

# This is necessary to fix an issue in the php-mcrypt cookbook.  For some
# reason it didn't seem to gain access to this value from the php cookbook. I'm
# not sure if it was getting overriden somewhere or if recipes just don't
# necessarily gain access to each other's attributes, but for whatever reason,
# this fixed it.
override['php']['ext_conf_dir'] = '/etc/php5/mods-available'


#######################################
#   Apache2 Configuration 
#######################################

default['foresttofarm.org']['site_name'] = 'foresttofarm.org'
default['foresttofarm.org']['server_name'] = 'foresttofarm.local'

# Note: server_aliases must be an array
default['foresttofarm.org']['server_aliases'] = ['www.foresttofarm.local'] 
default['foresttofarm.org']['document_root'] = '/srv/www/foresttofarm.org/public/'


#######################################
#   MySQL Database Configuration 
#######################################

# This code isn't intended for anything other than local development on a
# vagrant box connected only to a local private network.  It should never, ever
# be run on production servers, and if it is, it will likely break many things.
# Thus, we aren't going to go to any great lengths to choose secure passwords
# or encrypt them in data bags or anything like that.
default['foresttofarm.org']['database']['root_password'] = 'password'
default['foresttofarm.org']['database']['host'] = '127.0.0.1'

default['foresttofarm.org']['database']['name'] = 'local_foresttofarm'

default['foresttofarm.org']['database']['username'] = 'developer'
default['foresttofarm.org']['database']['password'] = 'developing'

default['foresttofarm.org']['database']['data_directory'] = '/srv/www/foresttofarm.org/data/'
default['foresttofarm.org']['database']['schema_file'] = 'schema.sql'

default['foresttofarm.org']['database']['data_file'] = 'data.csv'
