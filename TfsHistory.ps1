param (
    [string]$server = "http://tfs:8080",
    [string]$fromDate = "1/1/2017",
    [string]$toDate = "12/31/2017",
    [string]$path = "ProjectName/path",
    [int]$maxCount = 1000,
    [string]$outFile = ""
 )

$apiUrl = "/tfs/defaultcollection/_apis/tfvc/changesets";

$url = $server + $apiUrl + `
    '?searchCriteria.itemPath=$/' + $path + `
    '&searchCriteria.fromDate=' + $fromDate + `
    '&searchCriteria.toDate=' + $toDate + `
    '&$top=' + $maxCount

if ($outFile -eq ""){
    $outFile = $("FileHistory.csv")
}

echo "Getting file changes for $path from $server from $fromDate to $toDate up to $maxCount changesets exported to $outFile"

$changeSetsResult = invoke-webrequest -Uri $url -UseDefaultCredentials

$changeSets = ConvertFrom-Json($changeSetsResult.Content)

echo "$($changeSets.Count) changesets found"

$fileList = [System.Collections.ArrayList]@()

foreach($changeSet in $changeSets.value){
    # Get the Details
    echo $("Getting Details for Changeset: " + $changeSet.changesetId)
    # Get the files
    $changesUrl = $changeSet.url+"/changes"
    #echo $("Changes: " + $changesUrl)
    $changeSetChangesResult = invoke-webrequest -uri $changesUrl -UseDefaultCredentials
    $changeSetChanges = ConvertFrom-Json($changeSetChangesResult.Content)
    $items = $($changeSetChanges.value)
    #echo $items
    foreach($item in $items){
        if (-not $item.item.isFolder){
            $date = [DateTime]::Parse($($changeSet.createdDate))
            $file = New-Object System.Object           
            $file | Add-Member FileName $($item.item.path.Replace("$/" + $path + "/", ""))
            $file | Add-Member ChangeSetId $($changeSet.changesetId)
            $file | Add-Member Author $($changeSet.checkedInBy.displayName)
            $file | Add-Member Date $date
            $file | Add-Member Comment $($changeSet.comment)
            $file | Add-Member ChangeSetLink $($changeSet.url)
            $file | Add-Member FileLink $($item.item.url)
            $fileList.Add($file) | Out-Null
        }
    }
}

$fileList | export-csv $outFile -NoTypeInformation