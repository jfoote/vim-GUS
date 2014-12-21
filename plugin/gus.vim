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
    return substitute(call('system', [a:cmd]), '\n$', '', '')
endfunction

function! gus#dir()
    return fnamemodify(expand('%:p'), ':h')
endfunction

function! gus#git_filepath()
    let l:dir_from_repo = gus#system("cd " . gus#dir() . " && git rev-parse --show-prefix")
    return l:dir_from_repo . fnamemodify(expand("%:p"), ":t")
endfunction

function! gus#branch_name()
    return gus#system("cd " . gus#dir() . " && git branch | grep '*' | sed 's/\* //'")
endfunction

function! gus#link_url()
    " So hack. 
    let l:out = substitute(gus#get_url(), "ssh://.*@", "http://", "")

    return l:out
endfunction

function! gus#get_url()
    return gus#repo_id() . "/blob/" . gus#branch_name() . "/" . gus#git_filepath() . "#L" . line(".")
endfunction

function! gus#copy_url(url)
    let l:copied = 0
    if executable("pbcopy")
        call gus#system("echo '". a:url . "' | pbcopy")
        let l:copied = 1
    endif
    return l:copied
    " TODO add support for other utils
endfunction

function! gus#process_url()
    let l:url = gus#link_url()
    if gus#copy_url(l:url)
        let l:url = l:url . " (copied)"
    endif
    echo l:url
endfunction

function! gus#enable()
    let g:gus_enabled = 1
endfunction

function! gus#disable()
    let g:gus_enabled = 0
endfunction

call gus#enable()
command GU call gus#process_url()
