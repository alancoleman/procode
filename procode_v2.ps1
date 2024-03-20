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
$AppDataCount = $AppData.Count # This is not zero based
$ApiDomainEndpoint = "https://jsonplaceholder.typicode.com/"
$PsLineBreak = "`n"

# Create a header
$HeaderContentStarLine = "********************************"
$HeaderContent = $PsLineBreak 
$HeaderContent +=  $HeaderContentStarLine + "  Procode PS API Test " + $HeaderContentStarLine

# start the script by writing out the header and menu items
write-host $HeaderContent
write-host $PsLineBreak

#Loop trough menu items 
foreach ( $node in $AppData )
{
    $node.MenuItem
}



# Prompt user input and save as variable
write-host $PsLineBreak
$UserChoice = Read-Host "Please make a choice from the menu above by entering its number"
$UserChoiceZeroBased = $UserChoice -1 
write-host $PsLineBreak
Write-Host "Thank you, you have made choice '$UserChoice' ($UserChoiceZeroBased)"
write-host $PsLineBreak

$ApiFullEndpoint = $ApiDomainEndpoint + $AppData[$UserChoiceZeroBased].ApiEndpointPath

write-host "API Endpoint: " $ApiFullEndpoint
write-host $PsLineBreak



# Make the API Call
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.4https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.4
# PowerShell formats the response based to the data type. For an RSS or ATOM feed, PowerShell returns the Item or Entry XML nodes. 
# For JavaScript Object Notation (JSON) or XML, PowerShell converts, or deserializes, the content into [PSCustomObject] objects.
# [PSCustomObject]
# TODO Try and catch for the Invoke-RestMethod
$ApiResponse = Invoke-RestMethod -Uri $ApiFullEndpoint

# Display the response
write-host $ApiResponse


if ($UserChoice -eq 1 -or $UserChoice -eq 3){
    # Show 10 Posts
    # https://www.pdq.com/blog/guide-to-loops-in-powershell/
    for ($i = 0;  $i -lt $AppData[$UserChoiceZeroBased].PostsToDisplay; $i++){
        write-host $PsLineBreak
        write-host "userId: " $ApiResponse[$i].userId " id: " $ApiResponse[$i].id 
        write-host "Title: " $ApiResponse[$i].title
        write-host "Body: " $ApiResponse[$i].body
    }
    
}
elseif ($UserChoice -eq 2 -or $UserChoice -eq 4){
    # Show 10 comments
    for ($i = 0;  $i -lt $AppData[$UserChoiceZeroBased].PostsToDisplay; $i++){
        write-host $PsLineBreak
        write-host "postId: " $ApiResponse[$i].postId " id: " $ApiResponse[$i].id
        write-host "Name: " $ApiResponse[$i].name
        write-host "Email: " $ApiResponse[$i].email
        write-host "Body: " $ApiResponse[$i].body
    }
}
else {
    # Error, this shouldn't be possible
    <# Action when all if and elseif conditions are false #>
    
}