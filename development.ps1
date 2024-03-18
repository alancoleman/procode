#Write-Host "Congratulations! Your first script executed successfully"

#1. Present a basic numbered menu asking a user to make a selection from GET Single Post, GET Single Comment, GET 10 Posts, GET 10 Comments
#2. Upon selection the script will trigger the corresponding GET request to the fake Api - JSONPlaceholder - Free Fake REST API (typicode.com)
#3. The script should then output the results to the PowerShell window.
#4. As a bonus, deserialise the JSON object into a better format.

# Resources 
# https://jsonplaceholder.typicode.com/

# Invoke-RestMethod
# https://adamtheautomator.com/invoke-restmethod/
# Store the API GET response in a variable ($Posts).
#$Posts = Invoke-RestMethod -Uri "https://jsonplaceholder.typicode.com/posts" -UseBasicParsing

# Run the GetType() method against the first item in the array, identified by its index of 0.
#$Posts[0].GetType()
#$Posts

# Send a GET request including Basic authentication.
#$Params = @{
#	Uri = "https://jsonplaceholder.typicode.com/posts"
	#Authentication = "Basic"
	#Credential = $Cred
#}

#Invoke-RestMethod @Params

# Invoke-WebRequest
# https://devblogs.microsoft.com/scripting/working-with-json-data-in-powershell/
#$response = Invoke-WebRequest -Uri "https://jsonplaceholder.typicode.com/posts" -UseBasicParsing

#$response[0].Content

#$users = $response[0].Content | ConvertFrom-Json

# Loop through the users and do something
#foreach ($user in $users)

#{

    # TODO
    # Trim strings
    # Shorten and ... title and content so they can be shown on a single line
   # write-host "UserID: $($user.userId) ID: $($user.id)  has the title: $($user.title)"

#}