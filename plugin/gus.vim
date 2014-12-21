scriptencoding utf-8

if exists('g:loaded_gus') || !executable('git') || !has('signs') || &cp
  finish
endif

let g:loaded_gus = 1

function! gus#repo_id()
    return gus#system("cd " . gus#dir() . " && git config --get remote.origin.url")
endfunction

function! gus#commit_id()
    return gus#system("cd ". gus#dir() . " && git log --format='%H' -n 1")
endfunction

function! gus#system(cmd)
    return call('system', [a:cmd])
endfunction

function! gus#dir()
    return fnamemodify(expand('%:p'), ':h')
endfunction

function! gus#git_filepath()
    let l:dir_from_repo = gus#system("cd " . gus#dir() . " && git rev-parse --show-prefix")
    return l:dir_from_repo . "/" . fnamemodify(expand("%:p"), ":t")
endfunction

function! gus#branch_name()
    return gus#system("cd " . gus#dir() . " && git branch | grep '*' | sed 's/\* //'")
endfunction

function! gus#sanitize_repo_url(url)
    " So hack. Needs fixed.
    " remove proto
    let l:out = substitute(a:url, "http://", "", "")
    let l:out = substitute(a:url, "https://", "", "")
    let l:out = substitute(l:out, "ssh://.*@", "", "")

    " remove slashes
    let l:out = substitute(l:out, "/", ".", "g")

    return l:out
endfunction


function! gus#get_url()
    let l:url = gus#repo_id() . "/" . gus#branch_name() . "/" . gus#git_filepath()
    echo l:url
endfunction

function! gus#enable()
    let g:gus_enabled = 1
endfunction

function! gus#disable()
    let g:gus_enabled = 0
endfunction

call gus#enable()
command GU call gus#get_url()
