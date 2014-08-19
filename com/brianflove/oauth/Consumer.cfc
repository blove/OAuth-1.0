component accessors="true" {
	
	property type="string" name="key";
	property type="string" name="secret";
	
	/**
	* @hint Constructor.
	*/
	public Consumer function init() {
		setKey("");
		setSecret("");
		return this;
	}
	
	/**
	* @hint Override the getKey accessor to ensure it is not empty.
	*/
	public string function getKey() {
		if (not Len(variables.key)) {
			throw(message="You must supply the key value for the Consumer.");
		}
		return variables.key;
	}
	
	/**
	* @hint Override the getSecret accessor to ensure it is not empty.
	*/
	public string function getSecret() {
		if (not Len(variables.secret)) {
			throw(message="You must supply the secret value for the Consumer.");
		}
		return variables.secret;
	}
	
}