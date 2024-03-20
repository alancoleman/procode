## ---------------------------
##
## Script name: procode_v1
##
## Purpose of script: To display results of Procode interview task
##
## Author: Alan Coleman
##
## Date Created: 2018-03-19
##
## Email: alan@alancoleman.co.uk
##
## ---------------------------
##
## Notes:
##
## This is the first version of the script that has been superceded by procode_v2.ps1
## 
## ---------------------------

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
$HeaderContent +=  $HeaderContentStarLine + "  Procode Cloud Powershell Test " + $HeaderContentStarLine

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

# Build the API Endpoint
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

# Make the API Call
# PowerShell formats the response based to the data type. For an RSS or ATOM feed, PowerShell returns the Item or Entry XML nodes. 
# For JavaScript Object Notation (JSON) or XML, PowerShell converts, or deserializes, the content into [PSCustomObject] objects.
# [PSCustomObject]
$ApiResponse = Invoke-RestMethod -Uri $ApiFullEndpoint

# Display the response
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
    for ($i = 0;  $i -lt 10; $i++){
        write-host $PsLineBreak
        write-host "userId: " $ApiResponse[$i].userId " id: " $ApiResponse[$i].id 
        write-host "Title: " $ApiResponse[$i].title
        write-host "Body: " $ApiResponse[$i].body
    }
    
}
elseif ($UserChoice -eq 4){
    # Show 10 comments
    for ($i = 0;  $i -lt 10; $i++){
        write-host $PsLineBreak
        write-host "postId: " $ApiResponse[$i].postId " id: " $ApiResponse[$i].id
        write-host "Name: " $ApiResponse[$i].name
        write-host "Email: " $ApiResponse[$i].email
        write-host "Body: " $ApiResponse[$i].body
    }
}
else {
    # Error
    <# Action when all if and elseif conditions are false #> 
}