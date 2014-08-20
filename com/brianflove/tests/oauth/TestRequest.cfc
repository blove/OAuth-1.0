component extends="com.brianflove.tests.UnitTest" {
	
	variables.CONSUMER_KEY = "";
	variables.CONSUMER_SECRET = "";
	
	public void function testPlainTextSignature() {
		var request = new com.brianflove.oauth.Request();
		var consumer = new com.brianflove.oauth.Consumer();
		var token = new com.brianflove.oauth.Token();
		
		//setup consumer
		consumer.setSecret(variables.CONSUMER_SECRET);
		consumer.setKey(variables.CONSUMER_KEY);
		
		//setup request
		request.setMethod("POST");
		request.setUrl("https://api.twitter.com/oauth/request_token");
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
		request.setMethod("POST");
		request.setUrl("https://api.twitter.com/oauth/request_token");
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
		request.setMethod("POST");
		request.setUrl("https://api.twitter.com/oauth/request_token");
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
	
	public void function testTwitterRequestToken() {
		var request = new com.brianflove.oauth.Request();
		var consumer = new com.brianflove.oauth.Consumer();
		var token = new com.brianflove.oauth.Token();
		
		//setup consumer
		consumer.setSecret(variables.CONSUMER_SECRET);
		consumer.setKey(variables.CONSUMER_KEY);
		
		//setup request
		request.setMethod("POST");
		request.setUrl("https://api.twitter.com/oauth/request_token");
		request.setConsumer(consumer);
		request.setToken(token);
		
		//use plain text signature method
		var signatureMethod = new com.brianflove.oauth.methods.HmacSha1SignatureMethod();
		
		//sign request
		request.signWithSignatureMethod(signatureMethod=signatureMethod);
		
		//get authorization header
		var header = request.toHeader();
		
		//GET using request URL
		var httpRequest = new Http();
		httpRequest.setUrl(request.getUrl());
		httpRequest.setMethod(request.getMethod());
		httpRequest.addParam(type="header", name="Authorization", value=request.toHeader());
		httpRequest.addParam(type="header", name="Content-Type", value="application/x-www-form-urlencoded");
		httpRequest.setCharset("utf-8");
		var httpResult = httpRequest.send().getPrefix();
		
		//validate status code of response
		var statusCode = httpResult.responseHeader.status_code;
		assertTrue("Incorrect status code: #statusCode#", (statusCode eq 200));
		
		//assert length of response
		assertTrue("No respone length", Len(httpResult.fileContent));
		
		//parse result
		var parameters = {};
		var pairs = ListToArray(httpResult.fileContent, "&");
		for (var pair in pairs) {
			var key = ListGetAt(pair, 1, "=");
			var value = ListGetAt(pair, 2, "=");
			parameters[key] = value;
		}
		
		//validate length of parsed result
		var keys = StructKeyArray(parameters);
		assertTrue("There are not field-value pairs in the response.", ArrayLen(keys));
		
		//validate oauth_token key
		var oauthToken = "";
		for (var key in keys) {
			if (key == "oauth_token") {
				oauthToken = parameters[key];
				break;
			}
		}
		assertTrue("The oauth_token field is not in the response.", Len(oauthToken));
	}
	
}