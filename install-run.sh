echo "Running FSW Install Script"
#java -jar <installer> /path/to/auto-install.xml -variablefile  /path/to/properties/file/containing/passwords 
java -jar distros/jboss-fsw-installer-6.0.0.GA-redhat-4.jar support/InstallationScript.xml -variablefile support/InstallationScript.xml.variables
echo "Update overlord-rtgov.properties for collection enabled"
cp -vf installed/fsw/jboss-eap-6.1/standalone/configuration/overlord-rtgov.properties installed/fsw/jboss-eap-6.1/standalone/configuration/backup-overlord-rtgov.properties
cp -vf support/overlord-rtgov.properties installed/fsw/jboss-eap-6.1/standalone/configuration/overlord-rtgov.properties
echo "Start Server"
installed/fsw/jboss-eap-6.1/bin/standalone.sh -c standalone-full.xml
