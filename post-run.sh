DEMODIR="/home/kpeeples/demos/fsw-simple-demo"
echo "Compile and Deploy Projects"
echo "Install Information Processor from quickstarts/overlord/rtgov/ordermgmt/ip"
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/ip; mvn -s $DEMODIR/support/settings.xml clean jboss-as:deploy)
echo "Install Orders Management from quickstarts/overlord/rtgov/ordermgmt/app"
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/app; mvn -s $DEMODIR/support/settings.xml clean jboss-as:deploy)
echo "Test Order Management app"
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/app; mvn exec:java -Dreq=order1)
read -p "Press [Enter] key to continue...Order Management Test for order1 valid Butter Order from Fred...Now Let's test the Policy Enforcement"
read -p "Press [Enter] key to continue...First Synchronous Enforcement...2 request within 2 seconds will generate error"
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/policy/sync; mvn -s $DEMODIR/support/settings.xml clean jboss-as:deploy)
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/app; mvn exec:java -Dreq=order1 -Dcount=2)
read -p "Press [Enter] key to continue...Error should display for 2 request within 2 seconds...next Asynchronous Enforcement"
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/policy/async; mvn -s $DEMODIR/support/settings.xml clean jboss-as:deploy)
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/app; mvn exec:java -Dreq=order1)
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/app; mvn exec:java -Dreq=order1)
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/app; mvn exec:java -Dreq=order1)
read -p "Press [Enter] key to continue...Customer Suspended after 3 attempts, greater than 250"
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/app; mvn exec:java -Dreq=fredpay)
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/app; mvn exec:java -Dreq=order1)
read -p "Press [Enter] key to continue...After payment the next order should work ...SLA Monitoring"
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/sla/epn; mvn -s $DEMODIR/support/settings.xml clean jboss-as:deploy)
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/sla/monitor; mvn -s $DEMODIR/support/settings.xml clean jboss-as:deploy)
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/app; mvn exec:java -Dreq=order3)
read -p "Press [Enter] key to continue...The SLA Violation can be detected through REST or JMX....Now SLA Reporting"
curl -v -i --user fswAdmin:redhat1! -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d '{ "collection": "Situations" }' http://localhost:8080/overlord-rtgov/acm/query
read -p "\nPress [Enter] key to continue...Response from REST call"
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/sla/report; mvn -s $DEMODIR/support/settings.xml clean jboss-as:deploy)
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/app; mvn exec:java -Dreq=order1)
(cd installed/fsw/jboss-eap-6.1/quickstarts/overlord/rtgov/ordermgmt/app; mvn exec:java -Dreq=order3)
read -p "Press [Enter] key to continue...To generate the report the GET request should be sent"
firefox "http://localhost:8080/overlord-rtgov/report/generate?report=SLAReport&startDay=1&startMonth=1&startYear=2014&endDay=31&endMonth=12&endYear=2014&maxResponseTime=400&averagedDuration=450"
read -p "Press [Enter] key to continue..The report should have been generated"
