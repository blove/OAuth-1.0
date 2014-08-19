<cfsetting requesttimeout="600">
<cfparam name="url.cfc" type="variablename" default="default">
<cfset tests = ArrayNew(1)>

<cfset basePath = ExpandPath("./")>
<cfdirectory directory="#basePath#" action="list" recurse="true" filter="*.cfc" name="testFiles">

<cfoutput query="testFiles">
	<cfset cfcName = "com.brianflove.tests." & REReplace(ReplaceNoCase(testFiles.directory & "/", basePath, ""),  "[/\\]", ".","ALL") & Replace(testFiles.name, ".cfc", "")>
	<cfif testFiles.name neq "UnitTest.cfc">
		<cfset ArrayAppend(tests, cfcName)>
	</cfif>
</cfoutput>

<form method="get" action="run.cfm">
	<select name="cfc">
		<cfoutput>
			<option value="all"<cfif url.cfc IS "all" OR url.cfc IS "default"> selected="selected"</cfif>>All Unit Tests</option>
			<cfloop array="#tests#" index="test">
				<option value="#test#"<cfif test IS url.cfc> selected="selected"</cfif>>#test#</option>
			</cfloop>
		</cfoutput>
	</select>
	<input type="submit" value="Run Tests" />
</form>

<cfif url.cfc IS NOT "default">
	<cfif url.cfc IS NOT "all">
		<cfset tests = ArrayNew(1)>
		<cfset tests[1] = url.cfc>	
	</cfif>
	<cfset suite = CreateObject("component", "net.sourceforge.cfunit.framework.TestSuite")>
	<cfset suite.init(tests)>
	
	<cfinvoke component="net.sourceforge.cfunit.framework.TestRunner" method="run">
		<cfinvokeargument name="test" value="#suite#">
		<cfinvokeargument name="name" value="">
		<cfinvokeargument name="verbose" value="true">
	</cfinvoke>
</cfif>
<br />

<cfif IsDefined("request.debug_dump")>
	<cfdump var="#request.debug_dump#" label="request.debug_dump">
</cfif>

