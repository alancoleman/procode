## ---------------------------
##
## Script name: procode_v2
##
## Purpose of script: To display results of Procode interview task
##
## Author: Alan Coleman
##
## Date Created: 2018-03-20
##
## Email: alan@alancoleman.co.uk
##
## ---------------------------
##
## Notes:
##
## This is the second version of the task that uses more Powershell functionality to provide for better experience for both user and developer
## 1) The details for each available choice are now stored in an array of PS Custom objects ($AppData), this allows the API End points to be stored alongside the corresponding menu items and required posts to be displayed
## 2) The menu display makes use of the array and will not need to be adjusted once the $AppData array is altered
## 3) User input is now validated with warnings returned for an invalid input. Again, the array details are used so the validation will not need to be adjusted once the $AppData array is altered
## 4) A try and catch has been added to the Invoke-RestMethod, with warnings being returned from any error
## 5) Display of the API response has been updated to reuse code. Again details from the $AppData array are used here
##
## Further improvement:
## 
## Currently, the repsonse from the API Requests are displayed with the key for each value hardcoded in the script, this is less than ideal.
## An improvement would be to split the string on ; and loop through the new array splitting the substrings on = and replacing with :
## The above improvement would mean that additional API Call options could be added to the $AppData array without any other part of the script being altered
## Also, hard coding API Responses doesn't allow for that response to change by the endpoint provider
## 
## ---------------------------

# Build an array of custom objects to hold the details for each available choice
$AppData = @(
    [pscustomobject]@{
        MenuItem = "1) GET Single Post";
        PostsToDisplay = 1;
        ApiEndpointPath = "posts/1"
    }
    [pscustomobject]@{
        MenuItem = "2) GET Single Comment";
        PostsToDisplay = 1;
        ApiEndpointPath = "comments/1"
    }
    [pscustomobject]@{
        MenuItem = "3) GET 10 Posts";
        PostsToDisplay = 10;
        ApiEndpointPath = "posts"
    }
    [pscustomobject]@{
        MenuItem = "4) GET 10 Comments";
        PostsToDisplay = 10;
        ApiEndpointPath = "comments"
    }
)

# Set misc variables
$AppDataCount = $AppData.Count # This is not zero based, will be used as part of the input validation
$ApiDomainEndpoint = "https://jsonplaceholder.typicode.com/"
$PsLineBreak = "`n"
$Date = Get-Date

# Create a header
$HeaderContentStarLine = "********************************"
$HeaderContent = $PsLineBreak 
$HeaderContent +=  $HeaderContentStarLine + "  Procode PS API Test " + $HeaderContentStarLine

# start the script by writing out the header and menu items
write-host $HeaderContent
write-host $PsLineBreak

#Loop trough menu items and display
foreach ( $node in $AppData )
{
    $node.MenuItem
}

# Prompt user input and save as variable
write-host $PsLineBreak
$ErrorActionPreference = 'Stop'
$UserChoiceObj = "Make a choice from the menu by entering its number"

# User input validation
# https://stackoverflow.com/questions/68056955/user-input-validation-in-powershell
$scriptBlock = {
    try
    {
        $FromInput = [int](Read-Host $UserChoiceObj)

        if ($FromInput -le 0) {
            Write-Warning "Your input has to be a number greater than 0!"
            & $scriptBlock
        }
        # Use $AppDataCount here to check that the number selected isn't greater than the amount of menu items
        # Will need to increment by 1 as the variable is zero based
        elseif ($FromInput -ge $AppDataCount + 1) {
            Write-Warning "Your input has to be the number $AppDataCount or less!"
            & $scriptBlock
        }
        else {
            $FromInput
        }
    }
    catch
    {
        Write-Warning "Your input has to be a number."
        & $scriptBlock
    }
}

$UserChoice = & $scriptBlock

# Create a zero based version of the $UserChoice variable, to be used to access the data
$UserChoiceZeroBased = $UserChoice -1 

# Display the users choice
write-host $PsLineBreak
Write-Host "Thank you, you have made choice '$UserChoice' ($UserChoiceZeroBased) on $date"  -ForegroundColor Green
write-host $PsLineBreak

# Create the API Endpoint
$ApiFullEndpoint = $ApiDomainEndpoint + $AppData[$UserChoiceZeroBased].ApiEndpointPath

# Display the API Endpoint
write-host "API Endpoint: " $ApiFullEndpoint
write-host $PsLineBreak

# Make the API Call
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.4https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.4
# PowerShell formats the response based to the data type. For an RSS or ATOM feed, PowerShell returns the Item or Entry XML nodes. 
# For JavaScript Object Notation (JSON) or XML, PowerShell converts, or deserializes, the content into [PSCustomObject] objects.
# [PSCustomObject]
# https://stackoverflow.com/questions/29613572/error-handling-for-invoke-restmethod-powershell
Try {
    $ApiResponse = Invoke-RestMethod -Uri $ApiFullEndpoint
} Catch {
   if($_.ErrorDetails.Message) {
        Write-Warning $_.ErrorDetails.Message
   } else {
        Write-Warning $_
   }
   break
}

# Display the response
write-host $ApiResponse
write-host $PsLineBreak

if ($UserChoice -eq 1 -or $UserChoice -eq 3){
    # Show post(s)
    # https://www.pdq.com/blog/guide-to-loops-in-powershell/
    for ($i = 0;  $i -lt $AppData[$UserChoiceZeroBased].PostsToDisplay; $i++){
        write-host "userId: " $ApiResponse[$i].userId " id: " $ApiResponse[$i].id 
        write-host "Title: " $ApiResponse[$i].title
        write-host "Body: " $ApiResponse[$i].body
        write-host $HeaderContentStarLine -ForegroundColor Blue
        write-host $PsLineBreak
    }
}
elseif ($UserChoice -eq 2 -or $UserChoice -eq 4){
    # Show comment(s)
    for ($i = 0;  $i -lt $AppData[$UserChoiceZeroBased].PostsToDisplay; $i++){
        write-host "postId: " $ApiResponse[$i].postId " id: " $ApiResponse[$i].id
        write-host "Name: " $ApiResponse[$i].name
        write-host "Email: " $ApiResponse[$i].email -ForegroundColor Yellow
        write-host "Body: " $ApiResponse[$i].body
        write-host $HeaderContentStarLine -ForegroundColor Blue
        write-host $PsLineBreak
    }
}
else {
    # Error, this shouldn't be possible
    Write-Error "User choice is not compatible"
}