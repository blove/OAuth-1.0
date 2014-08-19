component implements="com.brianflove.oauth.methods.SignatureMethod" {
	
	public string function getMethodName() {
		return "PLAINTEXT";
	}
	
	public string function sign(required com.brianflove.oauth.Request request) {
		var stringUtil = new com.brianflove.utils.StringUtil();
		
		//build signature elements
		var signatureElements = [
			stringUtil.percentEncode(value=arguments.request.getConsumer().getSecret()), 
			stringUtil.percentEncode(value=arguments.request.getToken().getSecret())
		];
		
		//concatenate all signature elements using ampersands
		var signature = CreateObject("java", "java.lang.StringBuilder").init();
		for (signatureElement in signatureElements) {
			signature.append(signatureElement);
			signature.append("&");
		}
		
		//remove trailing ampersand in signature
		signature.deleteCharAt(signature.length()-1);
		
		//encode signature again
		var encodedSignature = stringUtil.percentEncode(value=signature.toString());
		
		return encodedSignature;
	}
	
}