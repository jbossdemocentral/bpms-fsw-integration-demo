JBoss BPM Suite & JBoss Fuse Serivce Works Integration Demo
===========================================================
This project fully automates the install of JBoss BPM Suite and on a separate EAP instance JBoss FSW products. It will demonstrate
the various use cases when working with these two products.


Quickstart
----------

1. [Downloadn and unzip.](https://github.com/eschabell/bpms-fsw-integration-demo/archive/master.zip)

2. Add products to installs directory.

3. Run 'init.sh' or 'init.bat'.

Follow the instructions on the screen to start JBoss BPM Suite server and JBoss Fuse Service Works server.

   ```
   Login to http://localhost:8180/business-central  (u:erics / p:bpmsuite1!).

   Login to http://localhost:8080/s-ramp-ui         (u:erics / p:jbossfsw1!)

   As a developer you have a modified project pom.xml (found in projects/customer)
   which includes an s-ramp wagon and s-ramp repsitory locations for transporting any
   artifacts we build with 'mvn deploy'.

        $ mvn deploy -f projects/customer/evaluation/pom.xml

   The cusotmer project now has been deployed in s-ramp repository where you can view
   the artifacts and see that the governance process in the s-ramp was automatically
   started. Claim the approval task in dashboard available in your browser and see the
   rewards artifact deployed in /tmp/dev copied to /tmp/qa upon approval:

        http://localhost:8080/s-ramp-ui            u:erics/p:jbossfsw1!       

   The example of promoting through dev to qa to stage to prod is an example of using
   a local filesystem for this demo.

       $ ls /tmp/dev/

         evaluation-1.0.jar
       
       $ ls /tmp/qa/

         evaluation-1.0.jar
   ```


Notes
-----
The s-ramp process includes an email node that will not work unless you have smtp configured (process will continue without SMTP). 
An easy tool to help run this is a [single java jar project called FakeSMTP](http://nilhcem.github.io/FakeSMTP).


Supporting Articles
-------------------
None yet...


Released versions
-----------------

See the tagged releases for the following versions of the product:

- v1.0 - JBoss BPM Suite 6.0.2 installer, JBoss Fuse Service Works 6.0.0 installer, S-RAMP, DTGov, and customer demo installed.


![Process](https://github.com/eschabell/bpms-fsw-integration-demo/blob/master/docs/demo-images/dtgov-process.png?raw=true)
![Artifacts](https://github.com/eschabell/bpms-fsw-integration-demo/blob/master/docs/demo-images/sramp-artifacts.png?raw=true)
![Deploy S-RAMP Process](https://github.com/eschabell/bpms-fsw-integration-demo/blob/master/docs/demo-images/sramp-process-upload.png?raw=true)
![Email S-RAMP Service](https://github.com/eschabell/bpms-fsw-integration-demo/blob/master/docs/demo-images/sramp-email-notify.png?raw=true)

