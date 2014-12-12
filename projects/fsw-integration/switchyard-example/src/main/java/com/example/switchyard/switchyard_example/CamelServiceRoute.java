package com.example.switchyard.switchyard_example;

import org.apache.camel.builder.RouteBuilder;

public class CamelServiceRoute extends RouteBuilder {

	/**
	 * The Camel route is configured via this method.  The from endpoint is required to be a SwitchYard service.
	 */
	public void configure() {
		// TODO Auto-generated method stub
		from("switchyard://IntakeService")
		.log("Received message for 'IntakeService' : ${body}")
		.bean(com.example.switchyard.switchyard_example.RestClientSimple4x.class,"startProcess");
	}

}
