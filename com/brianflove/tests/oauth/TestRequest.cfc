component extends="com.brianflove.tests.UnitTest" {
	
	variables.CONSUMER_KEY = "";
	variables.CONSUMER_SECRET = "";
	variables.API_URL = "";
	variables.API_METHOD = "GET";
	
	public void function testPlainTextSignature() {
		var request = new com.brianflove.oauth.Request();
		var consumer = new com.brianflove.oauth.Consumer();
		var token = new com.brianflove.oauth.Token();
		
		//setup consumer
		consumer.setSecret(variables.CONSUMER_SECRET);
		consumer.setKey(variables.CONSUMER_KEY);
		
		//setup request
		request.setMethod(variables.API_METHOD);
		request.setUrl(variables.API_URL);
		request.setConsumer(consumer);
		request.setToken(token);
		
		//use plain text signature method
		var signatureMethod = new com.brianflove.oauth.methods.PlainTextSignatureMethod();
		
		//sign request
		request.signWithSignatureMethod(signatureMethod=signatureMethod);
		
		//validate that oauth_signature parameter was created
		assertTrue("oauth_signature parameter is not defined using PLAINTEXT.", request.parameterIsDefined(key="oauth_signature"));
		if (not request.parameterIsDefined(key="oauth_signature")) {
			return;
		}
		
		//get oauth_signature parameter
		var signature = request.getParameter(key="oauth_signature");
		assertTrue("No signature length.", Len(signature));
	}
	
	public void function testHmacSha1Signature() {
		var request = new com.brianflove.oauth.Request();
		var consumer = new com.brianflove.oauth.Consumer();
		var token = new com.brianflove.oauth.Token();
		
		//setup consumer
		consumer.setSecret(variables.CONSUMER_SECRET);
		consumer.setKey(variables.CONSUMER_KEY);
		
		//setup request
		request.setMethod(variables.API_METHOD);
		request.setUrl(variables.API_URL);
		request.setConsumer(consumer);
		request.setToken(token);
		
		//use plain text signature method
		var signatureMethod = new com.brianflove.oauth.methods.HmacSha1SignatureMethod();
		
		//sign request
		request.signWithSignatureMethod(signatureMethod=signatureMethod);
		
		//validate that oauth_signature parameter was created
		assertTrue("oauth_signature parameter is not defined using HMAC-SHA1.", request.parameterIsDefined(key="oauth_signature"));
		if (not request.parameterIsDefined(key="oauth_signature")) {
			return;
		}
		
		//get oauth_signature parameter
		var signature = request.getParameter(key="oauth_signature");
		assertTrue("No signature length.", Len(signature));
	}
	
	public void function testAuthorizationHeader() {
		var request = new com.brianflove.oauth.Request();
		var consumer = new com.brianflove.oauth.Consumer();
		var token = new com.brianflove.oauth.Token();
		
		//setup consumer
		consumer.setSecret(variables.CONSUMER_SECRET);
		consumer.setKey(variables.CONSUMER_KEY);
		
		//setup request
		request.setMethod(variables.API_METHOD);
		request.setUrl(variables.API_URL);
		request.setConsumer(consumer);
		request.setToken(token);
		
		//use plain text signature method
		var signatureMethod = new com.brianflove.oauth.methods.HmacSha1SignatureMethod();
		
		//sign request
		request.signWithSignatureMethod(signatureMethod=signatureMethod);
		
		//get authorization header
		var header = request.toHeader();
		
		assertTrue("No header length.", Len(header));
	}
	
}