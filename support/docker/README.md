JBoss BPM Suite & JBoss Fuse Serivce Works Integration Demo
===========================================================
This project fully automates the install of JBoss BPM Suite and on a separate EAP instance JBoss FSW products. It will demonstrate
the various use cases when working with these two products.

Below are the docker installation specific details to run this demo.

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
	
For Docker specific settings required to execute the demos, see the readme in the support/docker/Readme.md for details.

The following sections describe the Docker specific settings required to execute the demos within a docker container. Please utilize the instructions in the sections above for a full description on the execution of the demos and replacing the content specified in the sections below.


![Use Case SY to BPM](https://github.com/jbossdemocentral/bpms-fsw-integration-demo/blob/master/docs/demo-images/fsw-bpms-integration-2.png?raw=true)


Docker - Use Case 1: Design Time Governance  
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


Docker - Example 2: Using DTGov with the FSW Switchyard application project  
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

