# foresttofarm-development

This cookbook performs provisioning for a vagrant based development server to
enable local development on Forest to Farm.

The ``default.rb`` recipe acts primarily as a runlist including dependencies in
the necessary order, followed by the recipes in this cookbook in the proper
order. 

The ``php.rb`` recipe performs additional configuration for the PHP server.

The ``web.rb`` recipe configures the apache2 virtual host.

The ``database.rb`` recipe installs the mysql client and server, configures
them, imports the database schema, and then runs a script to import the data
from a csv file into the database.




