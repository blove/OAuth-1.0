<!---
		This example implements a sign in with Twitter link
		https://dev.twitter.com/docs/auth/implementing-sign-twitter
		
		You must update the following static variables:
		- CONSUMER_KEY as provided by Twitter for your application
		- CONSUMER_SECRET as provided by Twitter for your application
		- CALLBACK to the twitter_callback.cfm file running in this folder on your web server
--->

<cfsilent>
	<cfset CONSUMER_KEY = "">
	<cfset CONSUMER_SECRET = "">
	<cfset CALLBACK = "http://localhost/OAuth/examples/twitter_callback.cfm">
</cfsilent>

<cfif StructKeyExists(url, "signin") AND IsBoolean(url.signin) AND url.signin>
	<cfset oAuthRequest = new com.brianflove.oauth.Request()>
	<cfset oAuthConsumer = new com.brianflove.oauth.Consumer()>
	<cfset oAuthToken = new com.brianflove.oauth.Token()>
	
	<!---setup consumer--->
	<cfset oauthConsumer.setSecret(CONSUMER_SECRET)>
	<cfset oauthConsumer.setKey(CONSUMER_KEY)>
	
	<!---setup request--->
	<cfset oAuthRequest.setMethod("POST")>
	<cfset oAuthRequest.setUrl("https://api.twitter.com/oauth/request_token")>
	<cfset oAuthRequest.setCallback(CALLBACK)>
	<cfset oAuthRequest.setConsumer(oAuthConsumer)>
	<cfset oAuthRequest.setToken(oAuthToken)>
	
	<!---use HMAC-SHA1 signature method--->
	<cfset signatureMethod = new com.brianflove.oauth.methods.HmacSha1SignatureMethod()>
	
	<!---sign request--->
	<cfset oAuthRequest.signWithSignatureMethod(signatureMethod=signatureMethod)>
	
	<!---POST using request URL--->
	<cfset httpRequest = new Http()>
	<cfset httpRequest.setUrl(oAuthRequest.getUrl())>
	<cfset httpRequest.setMethod(oAuthRequest.getMethod())>
	<cfset httpRequest.addParam(type="header", name="Authorization", value=oAuthRequest.toHeader())>
	<cfset httpRequest.setCharset("utf-8")>
	<cfset httpResult = httpRequest.send().getPrefix()>
	
	<!---Verify status code--->
	<cfif httpResult.responseHeader.status_code neq 200>
		<p>There was an error. The status code indicates that there was an error obtaining the request token.</p>
		<cfabort>
	</cfif>
	
	<!---Verify result--->
	<cfif not Len(httpResult.fileContent)>
		<p>There was an error. No response content was returned.</p>
		<cfabort>
	</cfif>
	
	<!---parse result--->
	<cfset parameters = {}>
	<cfset pairs = ListToArray(httpResult.fileContent, "&")>
	<cfloop array="#pairs#" index="pair">
		<cfset key = ListGetAt(pair, 1, "=")>
		<cfset value = ListGetAt(pair, 2, "=")>
		<cfset parameters[key] = value>
	</cfloop>
	
	<!---Verify oauth_token--->
	<cfif not StructKeyExists(parameters, "oauth_token")>
		<p>There was an error. Token was not returned.</p>
		<cfabort>
	</cfif>
	
	<!---Verify callback_confirmed--->
	<cfif not StructKeyExists(parameters, "oauth_callback_confirmed") OR (StructKeyExists(parameters, "oauth_callback_confirmed") AND not IsBoolean(parameters.oauth_callback_confirmed)) OR (StructKeyExists(parameters, "oauth_callback_confirmed") AND IsBoolean(parameters.oauth_callback_confirmed) AND not parameters.oauth_callback_confirmed)>
		<p>There was an error. The callback was not confirmed.</p>
		<cfabort>
	</cfif>
	
	<!---Store request token key and secret--->
	<cfset oAuthToken.setKey(parameters.oauth_token)>
	<cfif StructKeyExists(parameters, "oauth_token_secret")>
		<cfset oAuthToken.setSecret(parameters.oauth_token_secret)>
	</cfif>
	
	<!---Store Token instance for the user's session--->
	<cfset session.token = oAuthToken>
	
	<!---Redirect user to authenticate with Twitter--->
	<cflocation url="https://api.twitter.com/oauth/authenticate?oauth_token=#parameters.oauth_token#" statuscode="302" addtoken="false">
</cfif>

<h1>Sign in with Twitter</h1>
<cfif Len(CONSUMER_KEY) AND Len(CONSUMER_SECRET)>
	<a href="twitter.cfm?signin=1"><img src="https://dev.twitter.com/sites/default/files/images_documentation/sign-in-with-twitter-gray.png" /></a>
<cfelse>
	<p>To configure this demo you must have a registered application with Twitter.  Here are the necessary steps.</p>
	<ol>
		<li>Sign into the <a href="https://dev.twitter.com" target="_blank">Twitter Developer website</a>.</li>
		<li>Go to <a href="https://apps.twitter.com/" target="_blank">Application Management</a> and then click on <strong>Create New App</strong>.</li>
		<li>Note, you <strong>must</strong> provide a <strong>Callback URL</strong>.  Don't worry about getting it right, it's just a placeholder.  We will customize our request to specify the callback URL.  Further, it will not let you enter <em>localhost</em>, just enter something that is a valid domain.  The callback URL provided here is pretty meaningless but is required.</li>
		<li>After your application is created, copy and paste the <strong>Consumer Key</strong> and <strong>Consumer Secret</strong> values from the <strong>API Keys</strong> page into the example files: twitter.cfm, twitter_callback.cfm and twitter_verify_credentials.cfm.</li>
		<li>Next, go to the <strong>Settings</strong> for your application and check the <strong>Allow this application to be used to Sign in with Twitter</strong> checkbox, and click on <strong>Update settings</strong>.</li>
		<li>Finally, reload this page and click on the Sign In with Twitter button.</li>
	</ol>
</cfif>