interface {
	
	/**
	* @hint Constructor.
	*/
	public Exception function init();
	
	/**
	* @hint I throw an exception.
	*/
	public void function throw(string message="", string detail="");

}