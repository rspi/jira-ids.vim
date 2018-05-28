let s:fullComplete = ""
let s:fetchSuccess = 0

" complete-functions
fun! jiraids#Complete(findstart, base)
  call jiraids#FetchIssues()
  if a:findstart
    let line = getline('.')

    let i = col('.') - 1
    let start = 0
    while i > 0 && line[i - 1] =~ '[a-zA-Z0-9_\.]'
      if line[i - 1] == "." && start == 0
        let start = i
      endif
      let i -= 1
    endwhile

    if start == 0
      let start = i
    endif

    let s:fullComplete = line[i : col('.')-1]

    return start
  else
    let res = []

    if s:fetchSuccess
      for issue in s:json.issues

        let match = matchstr(issue['key'], '^' . s:fullComplete)
        if match != '' || s:fullComplete == ''
          call add(res, {'word': '['.issue['key'].']', 'menu': issue['fields']['summary']})
        endif

      endfor
    endif

    return res
  endif
endf

fun! s:DecodeJSON(s)
  let true = 1
  let false = 0
  let null = 0
  return eval(a:s)
endf

fun! jiraids#FetchIssues()
  let projects = '('. join(g:jira_projects, ',') . ')'
  let status = '(\"'. join(g:jira_statuses, '\",\"') . '\")'
  let user = g:jira_username

  let curl_data = '{"jql":"assignee = '.user.' AND (project in '.projects.') AND (status in '.status.')","fields":["key", "summary"]}'

  let auth = system('security find-generic-password -a vim-jira -w | awk '.shellescape('{printf"'.user.':"$1}').' | base64')
  let auth = substitute(auth, '\n', '', '')

  let curl_cmd = "curl -k -s -X POST -H 'Authorization: Basic ".auth."' -H 'Content-Type: application/json' --data ". shellescape(curl_data) ." '".g:jira_url."/rest/api/2/search'"

  let resp = system(curl_cmd)
  if !empty(resp)
    let s:json = s:DecodeJSON(resp)
    let s:fetchSuccess = 1
  endif
endf
