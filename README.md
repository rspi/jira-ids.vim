# Jira-ids.vim

This plugin provides autocomplete for your jira ids when making commit messages.

### Installation

Install with something like Pathogen or Vundle.
Put your jira password in OSX keychain with the "Account Field" set to `jira-vim`
Then put the following in your vimrc:

#####Your username that will be used for login and in the query for ids.
```
let g:jira_username='username'
```
#####The projects you want to show up in the list. (for `qa-123`, the project would be `qa`).
```
let g:jira_projects=['dev', 'qa']
```
#####Required story statuses
```
let g:jira_statuses=["In Progress", "In Testing"]
```
#####Jira url
```
let g:jira_url='https://your.jira.url.com'
```

### Usage

To open the auto-complete dropdown. press `<c-x><c-o>` in a commit message buffer.
You can also start by typing the project name and then press `<c-x><c-o>` to get a filtered list.

