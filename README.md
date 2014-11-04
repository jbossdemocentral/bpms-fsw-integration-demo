JBoss BPM Suite & JBoss Fuse Serivce Works Integration Demo
===========================================================
This project fully automates the install of JBoss BPM Suite and on a separate EAP instance JBoss FSW products. It will demonstrate
the various use cases when working with these two products.

![Use Case SY to BPM](https://github.com/eschabell/bpms-fsw-integration-demo/blob/master/docs/demo-images/fsw-bpms-integration-2.png?raw=true)

Quickstart
----------

1. [Download and unzip.](https://github.com/eschabell/bpms-fsw-integration-demo/archive/master.zip)

2. Add products to installs directory.

3. Run 'init.sh' or 'init.bat'.

4. Copy this code snippet into your ~/.m2/settings.xml (authorization for s-ramp repository):

   ```
   <!-- Added for BPM Suite Governance demo -->
   <servers>
   		<server>
          <id>local-sramp-repo</id>
          <username>erics</username>
          <password>jbossfsw1!</password>
      </server>
   </servers>
   ```

Follow the instructions on the screen to start JBoss BPM Suite server and JBoss Fuse Service Works server.


Use Case 1: Design Time Governance  
----------------------------------

The First Use Case is using Design Time Governance for Service Life Cycle Management.  This will be split into two examples:  

   ```
   Example 1 - Using DTGov with the BPM Customer Evaluation project  
   ----------------------------------------------------------------

   Login to http://localhost:8180/business-central  (u:erics / p:bpmsuite1!).

   Login to http://localhost:8080/s-ramp-ui         (u:erics / p:jbossfsw1!)

   As a developer you have a modified project pom.xml (found in projects/customer)
   which includes an s-ramp wagon and s-ramp repository locations for transporting any
   artifacts we build with 'mvn deploy'.

        $ mvn deploy -f projects/customer/evaluation/pom.xml

   The customer project now has been deployed in s-ramp repository where you can view
   the artifacts and see that the governance process in the s-ramp was automatically
   started. Claim the approval task in dashboard available in your browser and see the
   rewards artifact deployed in /tmp/dev copied to /tmp/qa upon approval:

        http://localhost:8080/s-ramp-ui            u:erics/p:jbossfsw1!       

   The example of promoting through dev to qa to stage to prod is an example of using
   a local filesystem for this demo.

       $ ls /tmp/dev/bpms

         evaluation-1.0.jar
       
       $ ls /tmp/qa/bpms

         evaluation-1.0.jar
   ```

   ```
   Example 2 - Using DTGov with the FSW Switchyard application project  
   -------------------------------------------------------------------
 
   Login to http://localhost:8180/business-central  (u:erics / p:bpmsuite1!).

   Build and deploy the process project.

   $ mvn deploy -f projects/fsw-integration/switchyard-example/pom.xml
   
    The example of promoting through dev to qa to stage to prod is an example of using
   a local filesystem for this demo.

       $ ls /tmp/dev/fsw

         switchyard-example-0.0.1-SNAPSHOT.jar
       
       $ ls /tmp/qa/fsw

         switchyard-example-0.0.1-SNAPSHOT.jar
   ```


Use Case 2: Call BPM Process From Switchyard App
------------------------------------------------
The Switchyard application will start a BPM process through the JBoss BPM Suite REST API from a Fuse camel route.
  
   ```
   Login to http://localhost:8180/business-central  (u:erics / p:bpmsuite1!).

   Build and deploy the process project.

   Step 1: Import the switchyard project into JBDS.
   
   Step 2: Run the Unit Test, TestIntakeServiceTest, By selecting it in Project explorer and selecting run junit test.
   
   TO DO: 
   
   1. We should be able to use a SOAP Client such as SOAPUI to call the deployed SY App.  There is an issue  
   with the httpclient on upgrading to 4.2 from 3.1.  Cookies/authentication are required with the BPMS REST API.  
   So the SY App gives a class loader error at the moment.  
   ```

Use Case 3: Call Switchyard App from BPM process
------------------------------------------------
The BPM process will call the Switchyard application through a SOAP based service.
  
   ```
   Login to http://localhost:8180/business-central  (u:erics / p:bpmsuite1!).

   Build and deploy the process project.

   TODO: FSW Switchyard app instructions (Kenny) 
   ```


Notes
-----
The s-ramp process includes an email node that will not work unless you have smtp configured (process will continue without SMTP). 
An easy tool to help run this is a [single java jar project called FakeSMTP](http://nilhcem.github.io/FakeSMTP).


Supporting Articles
-------------------
[New integration scenarios highlighted in JBoss BPM Suite & JBoss FSW integration demo](http://www.schabell.org/2014/08/new-integration-scenarios-bpmsuite-fsw-demo.html)
How to Guide within the repository  

Released versions
-----------------

See the tagged releases for the following versions of the product:

- v1.1 - JBoss BPM Suite 6.0.3 installer, JBoss Fuse Service Works 6.0.0 installer, customer demo installed and two governance
	workflows deployed for each product.

- v1.0 - JBoss BPM Suite 6.0.3 installer, JBoss Fuse Service Works 6.0.0 installer, S-RAMP, DTGov, and customer demo installed.


[![Video Demo Run](https://github.com/eschabell/bpms-fsw-integration-demo/blob/master/docs/demo-images/video-demo-run.png?raw=true)](http://vimeo.com/ericschabell/bpms-fsw-integration-demo-installation-governance)
![Process FSW](https://github.com/eschabell/bpms-fsw-integration-demo/blob/master/docs/demo-images/dtgov-process-fsw.png?raw=true)
![Process BPMS](https://github.com/eschabell/bpms-fsw-integration-demo/blob/master/docs/demo-images/dtgov-process-bpms.png?raw=true)
![Artifacts](https://github.com/eschabell/bpms-fsw-integration-demo/blob/master/docs/demo-images/sramp-artifacts.png?raw=true)
![Email S-RAMP Service](https://github.com/eschabell/bpms-fsw-integration-demo/blob/master/docs/demo-images/sramp-email-notify.png?raw=true)

