/**
 * 
 */
package com.example.switchyard.switchyard_example;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.switchyard.component.test.mixins.cdi.CDIMixIn;
import org.switchyard.component.test.mixins.http.HTTPMixIn;
import org.switchyard.test.BeforeDeploy;
import org.switchyard.test.Invoker;
import org.switchyard.test.ServiceOperation;
import org.switchyard.test.SwitchYardRunner;
import org.switchyard.test.SwitchYardTestCaseConfig;
import org.switchyard.test.SwitchYardTestKit;
import org.switchyard.test.mixins.PropertyMixIn;

/**
 * @author kpeeples
 *
 */
@RunWith(SwitchYardRunner.class)
@SwitchYardTestCaseConfig(config = SwitchYardTestCaseConfig.SWITCHYARD_XML, mixins = {
		CDIMixIn.class, HTTPMixIn.class, PropertyMixIn.class })
public class TestIntakeServiceTest {

	private SwitchYardTestKit testKit;
	private CDIMixIn cdiMixIn;
	private HTTPMixIn httpMixIn;
	@ServiceOperation("IntakeService")
	private Invoker service;
	private PropertyMixIn properties;

	private String host = "localhost";

	@BeforeDeploy
	public void setProperty() {
		properties.set("integration.host", host);
	}

	@Test
	public void testNewOperation() throws Exception {
		String resultstr="FAILED";
	    try {
		  Object message = "test";
		  Object result = service.operation("NewOperation").sendInOut(message).getContent(Object.class);
		  resultstr = (String) result;
		  System.out.println(">>>"+resultstr+"<<<");
		  Assert.assertTrue(resultstr.contains("SUCCESS"));
	    }
	    catch (Exception e)
	    {
		  System.out.println("Exception Message: " + e.getMessage());
		  Assert.assertFalse(resultstr.contains("FAILED"));
	    }
	}

}
