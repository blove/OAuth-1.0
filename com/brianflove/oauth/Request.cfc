component accessors="true" {
	
	property type="com.brianflove.oauth.Consumer" name="consumer";
	property type="string" name="method";
	property type="string" name="nonce";
	property type="numeric" name="timestamp";
	property type="com.brianflove.oauth.Token" name="token";
	property type="string" name="url";
	property type="string" name="version";
	
	/**
	* @hint Constructor.
	*/
	public Request function init() {
		//set the version to the default string
		setVersion("1.0");
		
		//create an empty struct to hold the parameters
		variables.parameters = {};
		
		return this;
	}
	
	/**
	* @hint Retreive a parameter value.
	*/
	public string function getParameter(required string key) {
		if (not parameterIsDefined(key=arguments.key)) {
			throw(message="The parameter is not defined." detail="#arguments.key# is an invalid parameter key.");
		}
		return variables.parameters[arguments.key];
	}
	
	/**
	* @hint Adds a parameter to the request.
	*/
	public void function addParameter(required string key, required string value) {
		variables.parameters[arguments.key] = arguments.value;
	}
	
	/**
	* @hint Removes a parameter from the request.
	*/
	public void function removeParameter(required string key) {
		StructDelete(variables.parameters, arguments.key);
	}
	
	/**
	* @hint Determine if a parameter exists.
	*/
	public boolean function parameterIsDefined(required string key) {
		return StructKeyExists(variables.parameters, arguments.key);
	}
	
	/**
	* @hint Returns a lexically sorted array of struct parameters for the request
	*/
	public array function getSortedParameters() {
		var stringUtil = new com.brianflove.utils.StringUtil();
		
		//add oauth_nonce parameter
		if (not parameterIsDefined(key="oauth_nonce")) {
			addParameter(key="oauth_nonce", value=stringUtil.percentEncode(value=getNonce()));
		}
		
		//add oauth_timestamp parameter
		if (not parameterIsDefined(key="oauth_timestamp")) {
			addParameter(key="oauth_timestamp", value=stringUtil.percentEncode(value=getTimestamp()));
		}
		
		//add oauth_version parameter
		if (not parameterIsDefined(key="oauth_version")) {
			addParameter(key="oauth_version", value=stringUtil.percentEncode(value=getVersion()));
		}
		
		//add oauth_consumer_key parameter
		if (not parameterIsDefined(key="oauth_consumer_key")) {
			addParameter(key="oauth_consumer_key", value=stringUtil.percentEncode(value=getConsumer().getKey()));
		}
		
		//sort keys
		var keys = StructKeyArray(variables.parameters);
		ArraySort(keys, "text", "asc");
		
		//build sorted parameters array
		var sortedParameters = [];
		for (var key in keys) {
			var param = {};
			param[key] = getParameter(key);
			ArrayAppend(sortedParameters, param);
		}
		
		return sortedParameters;
	}
	
	/**
	* @hint Returns the serialized parameter string.
	*/
	public string function getSerializedParameters() {
		var stringUtil = new com.brianflove.utils.StringUtil();
		var parameters = CreateObject("java", "java.lang.StringBuilder").init();
		
		//build encoded key=value string
		for (var sortedParameter in getSortedParameters()) {
			var keys = StructKeyArray(sortedParameter);
			for (var key in keys) {
				parameters.append(stringUtil.percentEncode(value=key));
				parameters.append("=");
				parameters.append(stringUtil.percentEncode(value=sortedParameter[key]));
			}
			parameters.append("&");
		}
		
		//remove trailing ampersand
		parameters.deleteCharAt(parameters.length()-1);
		
		return parameters.toString();
	}
	
	/**
	* @hint Signs the request with the provided signature method
	*/
	public void function signWithSignatureMethod(required com.brianflove.oauth.methods.SignatureMethod signatureMethod) {
		//validate HTTP method
		if (not StructKeyExists(variables, "method")) {
			throw(message="You must set the HTTP method before signing a request.");
		}
		
		//validate HTTP url
		if (not StructKeyExists(variables, "url")) {
			throw(message="You must set the HTTP url before signing a request.");
		}
		
		//remove signature parameters
		removeParameter(key="oauth_signature_method");
		removeParameter(key="oauth_signature");
		
		//set the signature method parameter
		addParameter(key="oauth_signature_method", value=arguments.signatureMethod.getMethodName());
		
		//create signature using signature method
		var signature = arguments.signatureMethod.sign(request=this);
		
		//set the signature parameter
		addParameter(key="oauth_signature", value=signature);
	}
	
	/**
	* @hint Returns the full URL for the signed request.
	*/
	public string function toUrl() {
		return getUrl() & "?" & getSerializedParameters();
	}
	
	/**
	* @hint Returns the post data for the signed request.
	*		This is just a short-hand method for the getSerializedParameters() method.
	*/
	public string function toPostData() {
		return getSerializedParameters();
	}
	
	/**
	* @hint Returns the authorization header for the signed request.
	*/
	public string function toHeader() {
		var parameters = CreateObject("java", "java.lang.StringBuilder").init();
		
		//build encoded key=value string
		for (var sortedParameter in getSortedParameters()) {
			var keys = StructKeyArray(sortedParameter);
			for (var key in keys) {
				if (ReFindNoCase("^oauth_", key)) {
					parameters.append(key);
					parameters.append('="');
					parameters.append(sortedParameter[key]);
					parameters.append('"');
				}
			}
			parameters.append(",");
		}
		
		//remove trailing comma
		parameters.deleteCharAt(parameters.length()-1);
		
		return parameters.toString();
	}
	
	/**
	* @hint Override getNonce accessor to generate nonce if necessary
	*/
	public string function getNonce() {
		//generate nonce if not already set
		if (not StructKeyExists(variables, "nonce") OR (StructKeyExists(variables, "nonce") AND not Len(variables.nonce))) {
			var uuid = ReReplaceNoCase(CreateUUID(), "[^a-z0-9]", "", "all");
			var hashedNonce = Hash(uuid, "MD5");
			setNonce(hashedNonce);
		}
		return variables.nonce;
	}
	
	/**
	* @hint Override the getTimestamp accessor to set the number of milliseconds since the epoch
	*/
	public numeric function getTimestamp() {
		//generate timestamp if not already set
		if (not StructKeyExists(variables, "timestamp") OR (StructKeyExists(variables, "timestamp") AND not Len(variables.timestamp))) {
			var ts = CreateObject("java", "java.util.Date").getTime();
			setTimestamp(ts);
		}
		return variables.timestamp;
	}
	
	/**
	* @hint Override the setMethod mutator to validate the HTTP method.
	*		I throw the InvalidArgumentTypeException if the method provided is not valid.
	*/
	public void function setMethod(required string method) {
		//validate HTTP method
		if (not ReFindNoCase("(get|set)", arguments.method)) {
			var exception = new com.brianflove.exceptions.InvalidArgumentTypeException();
			exception.throw(message="The method must be either GET or SET.");
		}
		variables.method = UCase(arguments.method);
	}
	
	/**
	* @hint Override the setURL mutator to validate the HTTP URL.
	*		I throw the InvalidArgumentTypeException if the url string is not valid.
	*/
	public void function setUrl(required string url) {
		//validate properly formed URL
		if (not ReFindNoCase("^https?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$", arguments.url)) {
			var exception = new com.brianflove.exceptions.InvalidArgumentTypeException();
			exception.throw(message="A valid URL must be set for the OAuth Request.");
		}
		variables.url = arguments.url;
	}
	
}