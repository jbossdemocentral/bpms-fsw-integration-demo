JBoss BPM Suite & JBoss Fuse Serivce Works Integration Demo
===========================================================
This project fully automates the install of JBoss BPM Suite and on a separate EAP instance JBoss FSW products. It will demonstrate
the various use cases when working with these two products.

![Use Case SY to BPM](https://github.com/jbossdemocentral/bpms-fsw-integration-demo/blob/master/docs/demo-images/fsw-bpms-integration-2.png?raw=true)

There are two options available to you for using this demo; local and Docker.


Option 1 - Install to your machine
----------------------------------
1. [Download and unzip.](https://github.com/jbossdemocentral/bpms-fsw-integration-demo/archive/master.zip)

2. Add products to installs directory.

3. Run 'init.sh' or 'init.bat' file. 'init.bat' must be run with Administrative privileges.

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


Option 2 - Generate docker install
----------------------------------
The following steps can be used to configure and run the demo in a docker container

1. [Download and unzip.](https://github.com/jbossdemocentral/bpms-fsw-integration-demo/archive/master.zip). 

2. Add products to installs directory.

3. Build demo image

	```
	docker build -t jbossdemocentral/bpms-fsw-integration-demo .
	```

4. Start demo container

	```
	docker run --it -p 8080:8080 -p 9990:9990 -p 9999:9999 -p 8180:8180 -p 10090:10090 -p 10099:10099 jbossdemocentral/bpms-fsw-integration-demo
	``` 
	
The following sections describe the Docker specific settings required to execute the demos within a docker container. Please utilize the instructions in the sections above for a full description on the execution of the demos and replacing the content specified in the sections below.



Use Case 1: Design Time Governance  
----------------------------------
The First Use Case is using Design Time Governance for Service Life Cycle Management. This will be split into two examples:  

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

   Build and deploy the process project.

   $ mvn deploy -f projects/fsw-integration/switchyard-example/pom.xml
   
      Login to http://localhost:8180/business-central  (u:erics / p:bpmsuite1!).
      
      The example of promoting through dev to qa to stage to prod is an example of using
   a local filesystem for this demo.  Move the Switchyard example to Production to deploy  
   to the running server instance.  A sym link in the init script ties /tmp/prod/fsw to the server deployments.  

       $ ls /tmp/dev/fsw

         switchyard-example-0.0.1-SNAPSHOT.jar
       
       $ ls /tmp/qa/fsw

         switchyard-example-0.0.1-SNAPSHOT.jar
         
       $ ls /tmp/stage/fsw (When this task is complete the SY application is deployed to production)

         switchyard-example-0.0.1-SNAPSHOT.jar
         
       $ ls /tmp/prod/fsw

         switchyard-example-0.0.1-SNAPSHOT.jar
   ```


Use Case 2: Call BPM Process From Switchyard App
------------------------------------------------
The Switchyard application will start a BPM process through the JBoss BPM Suite REST API from a Fuse camel route.
  
   ```
   Login to http://localhost:8180/business-central  (u:erics / p:bpmsuite1!).

   You can verify the process is started in business central.
   
   Example 1 - Run the test at the command line
   
   mvn test -f ./projects/fsw-integration/switchyard-example/pom.xml  
   
   Example 2 - Run the test through JBDS

   Step 1: Import the switchyard project into JBDS.
   
   Step 2: Run the Unit Test, TestIntakeServiceTest, By selecting it in Project explorer and selecting run junit test.
   
   Example 3 - Run the test through SOAPUI using http://localhost:8080/IntakeService/IntakeService?wsdl
	An example SOAPUI project is at support/FSWBPMS-soapui-project.xml.  Use the request and send any message in the request.
   
   ```

Use Case 3: Call Switchyard App from BPM process
------------------------------------------------
The BPM process will call the Switchyard application through a SOAP based service.
  
   ```
   Login to http://localhost:8180/business-central  (u:erics / p:bpmsuite1!).

   Start the Business Process to start the Switchyard Application which in turn will start the Custoemr Evaluation process.  
   The Switchyard endpoint is http://localhost:8080/IntakeService/IntakeService?wsdl
   TO DO: Eric create a separate business process to call the SOAP service which starts the Camel route to cll the customer evaluation process.

   ```

Use Case 1: Design Time Governance  
----------------------------------

Deploy the DTGOV workflows by running the following command within the Docker container:

    /opt/jboss/fsw/jboss-eap-6.1/bin/s-ramp.sh -f /opt/jboss/support/sramp-dtgovwf-upload.txt

   Login to http://&lt;DOCKER_HOST&gt;:8180/business-central  (u:erics / p:bpmsuite1!).

   Login to http://&lt;DOCKER_HOST&gt;:8080/s-ramp-ui         (u:erics / p:jbossfsw1!)

Run the following command within the Docker container to deploy the sample project to the s-ramp repository:

    mvn deploy -f /opt/jboss/projects/customer/evaluation/pom.xml

When prompted, enter the s-ramp username and password (u:erics/p:jbossfsw1!)

Promote the project to the different environments by claiming and completing tasks found within s-ramp:

        http://&lt;DOCKER_HOST&gt;:8080            u:erics/p:jbossfsw1!       


Example 2 - Using DTGov with the FSW Switchyard application project  
-------------------------------------------------------------------

Deploy the project from within the Docker container (it is recommended unit tests be skipped when running in a docker container.

    mvn deploy -f /opt/jboss/projects/fsw-integration/switchyard-example/pom.xml -Dmaven.test.skip=true

When prompted, enter the s-ramp username and password (u:erics/p:jbossfsw1!)

Build and deploy the demo in the BPMS suite 

    http://&lt;DOCKER_HOST&gt;:8180/business-central  (u:erics / p:bpmsuite1!).

  
Example 1 - Run the test at the command line

The process can be verified from the host

    mvn test -f ./projects/fsw-integration/switchyard-example/pom.xml -Dintegration.host=&lt;DOCKER_HOST&gt; 

Example 2 - Run the test through JBDS

   Step 1: Import the switchyard project into JBDS on the host
   
   Step 2: Run the Unit Test, TestIntakeServiceTest. Since the BPMS platform is located within Docker, the location must be specified. This can be done by modifying the unit test or passing a System Property
   
* Modify the Unit test
	* In the method annotated with the `BeforeDeploy`, replace localhost with &lt;DOCKER_HOST&gt;  
* Pass in a System Property when running the unit test
	* Select test in Project explorer and selecting run -> Run Configurations. Select new JUnit test. Add appropriate parameters to run a single test TestIntakeServiceTest and add the VM Arguments `-Dintegration.host=192.168.59.103` on the Arguments tab

   Example 3 - Run the test through SOAPUI.
   
Load the sample SOAPUI project and modify the destination 
 
    http://&lt;DOCKER_HOST&gt;:8080/IntakeService/IntakeService


Notes
-----
The s-ramp process includes an email node that will not work unless you have smtp configured (process will continue without SMTP). 
An easy tool to help run this is a [single java jar project called FakeSMTP](http://nilhcem.github.io/FakeSMTP).


Supporting Articles
-------------------
[5 Handy Tips From JBoss BPM Suite For Release 6.0.3](http://www.schabell.org/2014/10/5-handy-tips-from-jboss-bpmsuite-release-603.html)

[New integration scenarios highlighted in JBoss BPM Suite & JBoss FSW integration demo](http://www.schabell.org/2014/08/new-integration-scenarios-bpmsuite-fsw-demo.html)


Released versions
-----------------
See the tagged releases for the following versions of the product:

- v1.3 - Added optional generation of docker installation.

- v1.2 - moved to JBoss Demo Central, updated windows init.bat support (issue #6), removed switchyard snapshot usage (issue #7),
	modified DTGov deployment locations to /tmp/{product}/{artifact} (issue #4), fixed switchyard app build (issues #1).

- v1.1 - JBoss BPM Suite 6.0.3 installer, JBoss Fuse Service Works 6.0.0 installer, customer demo installed and two governance
	workflows deployed for each product.

- v1.0 - JBoss BPM Suite 6.0.3 installer, JBoss Fuse Service Works 6.0.0 installer, S-RAMP, DTGov, and customer demo installed.


[![Video Demo Run](https://github.com/jbossdemocentral/bpms-fsw-integration-demo/blob/master/docs/demo-images/video-demo-run.png?raw=true)](http://vimeo.com/ericschabell/bpms-fsw-integration-demo-installation-governance)

![Process FSW](https://github.com/jbossdemocentral/bpms-fsw-integration-demo/blob/master/docs/demo-images/dtgov-process-fsw.png?raw=true)

![Process BPMS](https://github.com/jbossdemocentral/bpms-fsw-integration-demo/blob/master/docs/demo-images/dtgov-process-bpms.png?raw=true)

![Artifacts](https://github.com/jbossdemocentral/bpms-fsw-integration-demo/blob/master/docs/demo-images/sramp-artifacts.png?raw=true)

![Email S-RAMP Service](https://github.com/jbossdemocentral/bpms-fsw-integration-demo/blob/master/docs/demo-images/sramp-email-notify.png?raw=true)

