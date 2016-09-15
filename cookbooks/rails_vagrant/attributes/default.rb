
#######################################
#   General Configuration
#######################################

# The root directory for Forest to Farm's source, a vagrant share directory.
default['rails_vagrant']['source_directory'] = '/srv/www/application'
default['rails_vagrant']['config_directory'] = '/srv/www/application/config'


#######################################
#   Apache2 Configuration 
#######################################

default['rails_vagrant']['server_name'] = 'foresttofarm.local'
default['rails_vagrant']['server_alias'] = 'www.foresttofarm.local'

default['rails_vagrant']['webmaster_email'] = 'webmaster@foresttofarm.org'
default['rails_vagrant']['document_root'] = '/srv/www/application/public'


#######################################
#   MySQL Database Configuration 
#######################################

# This code isn't intended for anything other than local development on a
# vagrant box connected only to a local private network.  It should never, ever
# be run on production servers, and if it is, it will likely break many things.
# Thus, we aren't going to go to any great lengths to choose secure passwords
# or encrypt them in data bags or anything like that.
default['rails_vagrant']['database']['root_password'] = 'password'
default['rails_vagrant']['database']['host'] = '127.0.0.1'

default['rails_vagrant']['database']['development']['name'] = 'local_foresttofarm'
default['rails_vagrant']['database']['development']['username'] = 'developer'
default['rails_vagrant']['database']['development']['password'] = 'developing'

default['rails_vagrant']['database']['test']['name'] = 'test_foresttofarm'
default['rails_vagrant']['database']['test']['username'] = 'tester'
default['rails_vagrant']['database']['test']['password'] = 'testing'

default['rails_vagrant']['database']['data_directory'] = '/srv/www/application/data/'
default['rails_vagrant']['database']['schema_file'] = 'schema.sql'
default['rails_vagrant']['database']['data_file'] = 'data.csv'
default['rails_vagrant']['database']['test_table'] = 'plants'

