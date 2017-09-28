<!---
		This example implements a sign in with Twitter link
		https://dev.twitter.com/docs/auth/implementing-sign-twitter

		You must update the following static variables:
		- CONSUMER_KEY as provided by Twitter for your application
		- CONSUMER_SECRET as provided by Twitter for your application
--->
<cfsilent>
	<cfset CONSUMER_KEY = "">
	<cfset CONSUMER_SECRET = "">

	<cfset oAuthRequest = new com.brianflove.oauth.Request()>
	<cfset oAuthConsumer = new com.brianflove.oauth.Consumer()>
	<cfset oAuthToken = new com.brianflove.oauth.Token()>

	<!---setup consumer--->
	<cfset oauthConsumer.setSecret(CONSUMER_SECRET)>
	<cfset oauthConsumer.setKey(CONSUMER_KEY)>

	<!---setup request--->
	<cfset oAuthRequest.setMethod("GET")>
	<cfset oAuthRequest.setUrl("https://api.twitter.com/1.1/account/verify_credentials.json")>
	<cfset oAuthRequest.setConsumer(oAuthConsumer)>
	<cfset oAuthRequest.setToken(session.token)>

	<!---use HMAC-SHA1 signature method--->
	<cfset signatureMethod = new com.brianflove.oauth.methods.HmacSha1SignatureMethod()>

	<!---sign request--->
	<cfset oAuthRequest.signWithSignatureMethod(signatureMethod=signatureMethod)>

	<!---POST using request URL--->
	<cfset httpRequest = new Http()>
	<cfset httpRequest.setUrl(oAuthRequest.toUrl())>
	<cfset httpRequest.setMethod(oAuthRequest.getMethod())>
	<cfset httpRequest.addParam(type="header", name="Authorization", value=oAuthRequest.toHeader())>
	<cfset httpRequest.setCharset("utf-8")>
	<cfset httpResult = httpRequest.send().getPrefix()>

	<!---Parse JSON response--->
	<cfset credentials = DeserializeJson(httpResult.fileContent)>
</cfsilent>
<cfoutput>
	<h1>Hello #credentials.name#</h1>
	<p>Here is some data about you.</p>
	<ul>
		<li>Your Twitter id: #credentials.id#</li>
		<li>Your Twitter username: #credentials.screen_name#</li>
		<li>You have #credentials.followers_count# followers</li>
		<li>You have tweeted #credentials.statuses_count# times</li>
	</ul>
</cfoutput>
