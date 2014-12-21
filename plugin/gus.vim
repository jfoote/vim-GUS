scriptencoding utf-8

" Perform init checks

if exists('g:loaded_gus') || !executable('git') || !has('signs') || &cp
  finish
endif

let g:loaded_gus = 1
let g:loc = resolve(expand('<sfile>:p'))

" Define helper functions

function! gus#remote_url()
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

" **** Link template function ****
" Hack here to support your projects' git URL schemes
function! gus#link_url()
    let l:url = gus#remote_url() . "/blob/" . gus#branch_name() . "/" . gus#git_filepath() . "#L" . line(".")

    " So hack. 
    let l:link = substitute(l:url, "ssh://.*@", "http://", "")

    return l:link
endfunction

function! gus#copy(url)
    if executable("pbcopy")
        call gus#system("echo '". a:url . "' | pbcopy")
        return 1
    endif
    return 0
    " TODO add support for other utils
endfunction

" Define main command-handling functions

function! gus#copy_and_show_url()
    let l:link = gus#link_url()
    if gus#copy(l:link)
        let l:link = l:link . " (copied)"
    endif
    echo l:link
endfunction

function! gus#copy_and_show_markdown()
    let l:md = "[" . gus#git_filepath() . " line " . line(".") . "](" . gus#link_url() . ")"
    if gus#copy(l:md)
        let l:md = l:md. " (copied)"
    endif
    echo l:md
endfunction

function! gus#copy_and_show_redmine()
    let l:rm  = '"' . gus#git_filepath() . " line " . line(".") . '":' . gus#link_url() 
    if gus#copy(l:rm)
        let l:rm = l:rm. " (copied)"
    endif
    echo l:rm
endfunction

" Define commands

command GUS call gus#copy_and_show_url()
command GUM call gus#copy_and_show_markdown()
command GUR call gus#copy_and_show_redmine()
command GUW echo "GUS plugin is here: " . g:loc
