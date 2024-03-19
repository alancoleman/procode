# Set menu variables
$UserOption1 = "1) GET Single Post"
$UserOption2 = "2) GET Single Comment"
$UserOption3 = "3) GET 10 Posts"
$UserOption4 = "4) GET 10 Comments"

# Set misc variables
$ApiDomainEndpoint = "https://jsonplaceholder.typicode.com/"
$PsLineBreak = "`n"

# Create a header
$HeaderContentStarLine = "********************************"
$HeaderContent = $PsLineBreak 
$HeaderContent +=  $HeaderContentStarLine + "  Procode PS API Test " + $HeaderContentStarLine

# start the script by writing out the header and menu items
write-host $HeaderContent
write-host $PsLineBreak
write-host $UserOption1
write-host $UserOption2
write-host $UserOption3
write-host $UserOption4
write-host $PsLineBreak

# Prompt user input and save as variable

$UserChoice = Read-Host "Please make a choice from the menu above by entering its number"
write-host $PsLineBreak
Write-Host "Thank you, you have made choice '$UserChoice'"
write-host $PsLineBreak


if ($UserChoice -eq 1) {
    # GET Single Post
    $ApiFullEndpoint = $ApiDomainEndpoint + "posts/1"
} 
elseif ($UserChoice -eq 2) {
    # GET Single Comment
    $ApiFullEndpoint = $ApiDomainEndpoint + "comments/1"
}
elseif ($UserChoice -eq 3){
    # GET 10 Posts
    $ApiFullEndpoint = $ApiDomainEndpoint + "posts"
}
else {
    # GET 10 Comments
    <# Action when all if and elseif conditions are false #>
    $ApiFullEndpoint = $ApiDomainEndpoint + "comments"
    
}

write-host "API Endpoint: " $ApiFullEndpoint
write-host $PsLineBreak


# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.4https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.4
# PowerShell formats the response based to the data type. For an RSS or ATOM feed, PowerShell returns the Item or Entry XML nodes. 
# For JavaScript Object Notation (JSON) or XML, PowerShell converts, or deserializes, the content into [PSCustomObject] objects.
# [PSCustomObject]
# TODO Try and catch for the Invoke-RestMethod
$ApiResponse = Invoke-RestMethod -Uri $ApiFullEndpoint

write-host $ApiResponse

if ($UserChoice -eq 1) {
    # Show Single Post
    write-host $PsLineBreak
    write-host "userId: " $ApiResponse.userId " id: " $ApiResponse.id 
    write-host "Title: " $ApiResponse.title
    write-host "Body: " $ApiResponse.body
} 
elseif ($UserChoice -eq 2) {
    # Show Single Comment
    write-host $PsLineBreak
    write-host "postId: " $ApiResponse.postId " id: " $ApiResponse.id
    write-host "Name: " $ApiResponse.name
    write-host "Email: " $ApiResponse.email
    write-host "Body: " $ApiResponse.body
}
elseif ($UserChoice -eq 3){
    # Show 10 Posts
    
}
elseif ($UserChoice -eq 4){
    # Show 10 comments
    
}
else {
    # Error
    <# Action when all if and elseif conditions are false #>
    
}


# Loop through the users and do something
#foreach ($user in $users)

#{

    # TODO
    # Trim strings
    # Shorten and ... title and content so they can be shown on a single line
   # write-host "UserID: $($user.userId) ID: $($user.id)  has the title: $($user.title)"

#}


















break
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

# https://devblogs.microsoft.com/scripting/working-with-json-data-in-powershell/
#$users = $response[0].Content | ConvertFrom-Json

# Loop through the users and do something
#foreach ($user in $users)

#{

    # TODO
    # Trim strings
    # Shorten and ... title and content so they can be shown on a single line
   # write-host "UserID: $($user.userId) ID: $($user.id)  has the title: $($user.title)"

#}



# Functions
# https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/09-functions?view=powershell-7.4

function Get-MrPSVersion {
    $PSVersionTable.PSVersion
}

Get-MrPSVersion


# **************************** BREAK
# https://stackoverflow.com/questions/2022326/terminating-a-script-in-powershell
break



# Prompt user input
# https://www.itprotoday.com/powershell/prompting-user-input-powershell#close-modal

# Clear-Host
$Date = Get-Date


# https://www.oreilly.com/library/view/professional-windows-powershell/9780471946939/9780471946939_using_the_dollar_erroractionpreference_v.html
$ErrorActionPreference = 'Stop'
$FromObj = "Make a choice from the menu by entering its number"

# https://stackoverflow.com/questions/68056955/user-input-validation-in-powershell
$scriptBlock = {
    try
    {
        $FromInput = [int](Read-Host $FromObj)

        # Note I'm using Write-Host instead of Write-Ouput, this is because
        # we don't want to store the invalid inputs messages in the
        # $userInput variable.
        if ($FromInput -le 0) {
            Write-Host "Your input has to be a number greater than 0!"
            & $scriptBlock
        }
        elseif ($FromInput -ge 800) {
            Write-Host "Your input has to be a number less than 800!"
            & $scriptBlock
        }
        else {
            $FromInput
        }
    }
    catch
    {
        Write-Host "Your input has to be a number."
        & $scriptBlock
    }
}

$userInputChoice = & $scriptBlock
Write-Host "You input server '$userInputChoice' on '$Date'" 




