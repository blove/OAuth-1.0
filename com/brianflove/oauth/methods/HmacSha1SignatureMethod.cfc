component implements="com.brianflove.oauth.methods.SignatureMethod" {
	
	public string function getMethodName() {
		return "HMAC-SHA1";
	}
	
	public string function sign(required com.brianflove.oauth.Request request) {
		var stringUtil = new com.brianflove.utils.StringUtil();
		
		//get parameters, being sure to exclude the oauth_signature parameter
		var parameters = CreateObject("java", "java.lang.StringBuilder").init();
		for (var sortedParameter in arguments.request.getSortedParameters()) {
			var keys = StructKeyArray(sortedParameter);
			for (var key in keys) {
				parameters.append(stringUtil.percentEncode(value=key));
				parameters.append("=");
				parameters.append(stringUtil.percentEncode(value=sortedParameter[key]));
			}
			parameters.append("&");
		}
		parameters.deleteCharAt(parameters.length()-1);
		
		//build signature base
		var signatureBase = CreateObject("java", "java.lang.StringBuilder").init();
		signatureBase.append(arguments.request.getMethod());
		signatureBase.append("&");
		signatureBase.append(stringUtil.percentEncode(value=ReReplaceNoCase(arguments.request.getUrl(), "\?.*$", "")));
		signatureBase.append("&");
		signatureBase.append(stringUtil.percentEncode(value=parameters.toString()));
		
		//build key for hash algorithm
		var key = CreateObject("java", "java.lang.StringBuilder").init();
		key.append(stringUtil.percentEncode(value=arguments.request.getConsumer().getSecret()));
		key.append("&");
		key.append(stringUtil.percentEncode(value=arguments.request.getToken().getSecret()));
		
		//return hashed signature
		return stringUtil.hmacSha1(key=key.toString(), string=signatureBase.toString());
	}
	
}