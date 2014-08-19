component accessors="true" {
	
	property type="string" name="key";
	property type="string" name="secret";
	
	/**
	* @hint Constructor.
	*/
	public Token function init() {
		setKey("");
		setSecret("");
		return this;
	}
	
}