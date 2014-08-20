component extends="AbstractException" {
	
	property type="any" name="component";
	property type="string" name="methodName";
	property type="string" name="argumentName";
	
	/**
	* @hint I throw an exception.
	*/
	public void function throw(string message="", string detail="") {
		if (not Len(arguments.message) AND IsObject(variables.component) AND Len(variables.methodName) AND Len(variables.argumentName)) {
			arguments.message = "Invalid type passed to #getMethodName()#.#getArgumentName()#() in #GetMetaData(getComponent()).fullname#.";
		}
		super.throw(message=arguments.message, detail=arguments.detail);
	}
	
}