component {
	
	/**
	* @hint I perform percent-encoding [RFC-3986].
	*/
	public string function percentEncode(required string value) {
		var encoded = CreateObject("java","java.net.URLEncoder").encode(JavaCast("String", arguments.value), "UTF-8");
		encoded = Replace(encoded, "+", "%20", "all");
		encoded = Replace(encoded, "*", "%2A", "all");
		encoded = Replace(encoded, "%7E", "~", "all");
		return encoded;
	}
	
	/**
	* @hint I hash a string using the key provided using the HMAC-SHA1 algorithm.
	*/
	public string function hmacSha1(required string key, required string string) {
		var secretKeySpec = createObject("java", "javax.crypto.spec.SecretKeySpec");
		var mac = createObject("java", "javax.crypto.Mac");
		var format = "ISO-8859-1";
		
		arguments.key = JavaCast("string", arguments.key).getBytes(format);
		arguments.string = JavaCast("string", arguments.string).getBytes(format);
		secretKeySpec = secretKeySpec.init(arguments.key,"HmacSHA1");
		mac = mac.getInstance(secretKeySpec.getAlgorithm());
		mac.init(secretKeySpec);
		mac.update(arguments.string);
		
		return ToBase64(mac.doFinal());
	}

}