# TfsHistory
PowerShell script to get the change history of a project using TFS version control as a CSV file. 

## Purpose
If your code requires any type of audit from external entities, you may be asked to provide a list of all the changes made to files during a window of time. While history in TFS can provide this, it does it by changeset not by file. To see it by file, only one file can be seen at a time. This tool allows you to get a list of all changes including filename and date changed. It works for Team Foundation Version Control (TFVC). 

This is a simple script that calls the TFS API to get the history of all files in the project. It pulls the changesets and then expands to all files touched. The results are exported to a file (default name is FileHistory.csv) in a CSV format in the current folder.

### Output Format
The CSV format has the following columns:
- FileName: The source control path of the file that was changed
- ChangeSet: The ChangeSet that contains the change
- Author: User who checked in the change
- Date: Date the ChangeSet was checked in
- Comment: Comment on the check in
- ChangeSetLink: Web link to the ChangeSet
- FileLink: Web link to this version of the file

### Command Line Parameters
There are a number of command line parameters:
- server: URL of the server. http://tfs:8080
- fromDate: Date to start looking for changes. M/D/YYYY. 11/1/2017
- toDate: Date to stop looking for changes. M/D/YYYY. 12/1/2017
- path: Project and path to search for changes in. Electron/dev
- maxCount: Maximum number of change sets to bring back (default: 1000)
- outFile: Filename for results. (default: FileHistory.csv) 

### Example

    .\tfshistory.ps1 -server http://tfs:8080 -fromDate 11/1/2017 -toDate 11/30/2017 -path Electron/Dev -maxCount 500 -outFile results.csv

    .\tfshistory.ps1 -server http://tfs:8080 -fromDate 11/1/2017 -toDate 11/30/2017 -path Electron/Dev
    
Note that you can also modify the file with parameter defaults for the server and path that you access regularly.
