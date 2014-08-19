component implements="Exception" {
	
	/**
	* @hint Constructor.
	*/
	public Exception function init() {
		return this;
	}
	
	/**
	* @hint I throw an exception.
	*/
	public void function throw(string message="", string detail="") {
		throw(message=arguments.message, type=getMetaData(this).name, detail=arguments.detail);
	}

}