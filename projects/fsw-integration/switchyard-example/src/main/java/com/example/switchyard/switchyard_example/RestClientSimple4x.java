package com.example.switchyard.switchyard_example;

import org.apache.http.HttpEntity;
import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.ContextAwareAuthScheme;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.AuthCache;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.protocol.ClientContext;
import org.apache.http.impl.auth.BasicScheme;
import org.apache.http.impl.client.BasicAuthCache;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.util.EntityUtils;

/**
 * Starting an instance of the process, without submitting any variables in a map.
 * 
 */
public class RestClientSimple4x {
    private static final String BASE_URL = "http://localhost:8180/business-central/rest/";
    //private static final String AUTH_URL = "http://localhost:8180/business-central/org.kie.workbench.KIEWebapp/j_security_check";
    private static final String DEPLOYMENT_ID = "customer:evaluation:1.0";
    private static final String PROCESS_DEF_ID = "customer.evaluation";
    
    private static String username = "erics";
    private static String password = "bpmsuite1!";

    public static void main(String[] args) throws Exception {
    	System.out.println("Starting process instance: " + DEPLOYMENT_ID);
    	// start a process instance with no variables.
        startProcess();
    	System.out.println("Completed process instance: " + DEPLOYMENT_ID);
    }

   public static String startProcess() throws Exception {
       String returnValue ="";
       String newInstanceUrl = BASE_URL + "runtime/" + DEPLOYMENT_ID + "/process/" + PROCESS_DEF_ID + "/start";
       HttpHost targetHost = new HttpHost("localhost",8180,"http");
       
       DefaultHttpClient httpclient = new DefaultHttpClient();
       httpclient.getCredentialsProvider().setCredentials(
	    new AuthScope(targetHost.getHostName(), targetHost.getPort()),
	    new UsernamePasswordCredentials(username, password));

       try {
           // Create AuthCache instance
           AuthCache authCache = new BasicAuthCache();
           // Generate BASIC scheme object and add it to the local
           // auth cache
           BasicScheme basicAuth = new BasicScheme();
           authCache.put(targetHost, basicAuth);
           // Add AuthCache to the execution context
           BasicHttpContext localContext = new BasicHttpContext();
           localContext.setAttribute(ClientContext.AUTH_CACHE, authCache);
           HttpPost httppost = new HttpPost(newInstanceUrl);
           System.out.println("Executing request " + httppost.getRequestLine() + " to target " + targetHost);
               HttpResponse response = httpclient.execute(targetHost, httppost, localContext);
               try {
                   System.out.println("----------------------------------------");
                   System.out.println(response.getStatusLine());
                   returnValue=EntityUtils.toString(response.getEntity());
                   System.out.println(returnValue);
                   System.out.println("----------------------------------------");
               } finally {              
                   //response.close();
               }
       } finally {
           //httpclient.close();
       }
        return returnValue;
    }


}
