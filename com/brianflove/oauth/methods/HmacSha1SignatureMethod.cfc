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
				parameters.append(key);
				parameters.append("=");
				parameters.append(sortedParameter[key]);
			}
			parameters.append("&");
		}
		parameters.deleteCharAt(parameters.length()-1);
		
		//build signature elements
		var signatureElements = [
			stringUtil.percentEncode(value=arguments.request.getMethod()), 
			stringUtil.percentEncode(value=arguments.request.getUrl()), 
			stringUtil.percentEncode(value=parameters.toString())
		];
		
		//writeDump(signatureElements);
		//abort;
		
		//concatenate all signature elements using ampersands
		var signature = CreateObject("java", "java.lang.StringBuilder").init();
		for (signatureElement in signatureElements) {
			signature.append(signatureElement);
			signature.append("&");
		}
		
		//remove trailing ampersand in signature
		signature.deleteCharAt(signature.length()-1);
		
		//build key elements for hash algorithm
		var keyElements = [
			stringUtil.percentEncode(value=arguments.request.getConsumer().getSecret()), 
			stringUtil.percentEncode(value=arguments.request.getToken().getSecret())
		];
		
		//concatenate all key elements using ampersands
		var key = CreateObject("java", "java.lang.StringBuilder").init();
		for (keyElement in keyElements) {
			key.append(keyElement);
			key.append("&");
		}
		
		//remove trailing ampersand in key
		key.deleteCharAt(key.length()-1);
		
		//return hashed signature
		return stringUtil.hmacSha1(key=key.toString(), string=signature.toString());
	}
	
}