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

        # Note I'm using Write-Host instead of Write-Ouput, this is because
        # we don't want to store the invalid inputs messages in the
        # $userInput variable.
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
Write-Host "Thank you, you have made choice '$UserChoice' ($UserChoiceZeroBased) on $date"
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
# TODO Try and catch for the Invoke-RestMethod
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
#write-host $ApiResponse
#write-host $PsLineBreak

if ($UserChoice -eq 1 -or $UserChoice -eq 3){
    # Show 10 Posts
    # https://www.pdq.com/blog/guide-to-loops-in-powershell/
    for ($i = 0;  $i -lt $AppData[$UserChoiceZeroBased].PostsToDisplay; $i++){
        write-host "userId: " $ApiResponse[$i].userId " id: " $ApiResponse[$i].id 
        write-host "Title: " $ApiResponse[$i].title
        write-host "Body: " $ApiResponse[$i].body
        write-host $HeaderContentStarLine
        write-host $PsLineBreak
    }
    
}
elseif ($UserChoice -eq 2 -or $UserChoice -eq 4){
    # Show 10 comments
    for ($i = 0;  $i -lt $AppData[$UserChoiceZeroBased].PostsToDisplay; $i++){
        write-host "postId: " $ApiResponse[$i].postId " id: " $ApiResponse[$i].id
        write-host "Name: " $ApiResponse[$i].name
        write-host "Email: " $ApiResponse[$i].email
        write-host "Body: " $ApiResponse[$i].body
        write-host $HeaderContentStarLine
        write-host $PsLineBreak
    }
}
else {
    # Error, this shouldn't be possible
    Write-Error "User choice is not compatible"
}