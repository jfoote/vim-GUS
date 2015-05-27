scriptencoding utf-8

" https://github.com/jfoote/vim-GUS
" jmfoote@loyola.edu
" 2014 Dec 21

" Perform init checks

if exists('g:loaded_gus') || !executable('git') || !has('signs') || &cp
  finish
endif

let g:loaded_gus = 1
let g:loc = resolve(expand('<sfile>:p'))

" Define helper functions

function! gus#remote_url()
    return gus#system("cd " . gus#dir() . 
                \" && git config --get remote.origin.url")
endfunction

function! gus#commit_id()
    return gus#system("cd ". gus#dir() . 
                \" && git log --format='%H' -n 1")
endfunction

function! gus#system(cmd)
    let l:out = substitute(call('system', [a:cmd]), '\n$', '', '')
    if v:shell_error != 0
        throw 'cmd error'
    endif
    return l:out
endfunction

function! gus#dir()
    return fnamemodify(expand('%:p'), ':h')
endfunction

function! gus#git_filepath()
    let l:dir_from_repo = gus#system("cd " . gus#dir() . 
                \" && git rev-parse --show-prefix")
    return l:dir_from_repo . fnamemodify(expand("%:p"), ":t")
endfunction

function! gus#branch_name()
    return gus#system("cd " . gus#dir() . 
                \" && git branch | grep --color=never '*' | sed 's/\* //'")
endfunction

" **** Link template function ****
" Hack here to support your projects' git URL schemes
function! gus#link_url()

    " This could be a lot better ('man git-clone' to see the volume of valid
    " URI schemes). If needs be you can just hard-code the base URL for your
    " projects' git servers instead of using gus#remote_url(). Or fix this 
    " logic and open a pull request :)
    let l:remote = gus#remote_url()
    let l:remote = substitute(l:remote, '^.*@\([^:]\+\):', 'http://\1/', "")
    let l:remote = substitute(l:remote, "ssh://.*@", "http://", "")
    let l:remote = substitute(l:remote, "\\.git$", "", "")

    let l:url = l:remote . "/blob/" . gus#branch_name() . "/" . 
                \gus#git_filepath() . "#L" . line(".")

    return l:url
endfunction

function! gus#copy(url)
    try
        if executable("pbcopy")
            call gus#system("echo '". a:url . "' | pbcopy")
            return 1
        elseif executable("xsel")
            call gus#system("echo '". a:url . "' | xsel")
            return 1
        elseif executable("xclip")
            " warning: may require X display
            call gus#system("echo '". a:url . "' | xclip -selection c")
            return 1
        endif
    catch /cmd error/
        " probably linux without X display
    endtry
    return 0
endfunction

" Define main command-handling functions

function! gus#copy_and_show_url()
    try
        let l:link = gus#link_url()
        if gus#copy(l:link)
            let l:link = l:link . " (copied)"
        else
            let l:link = l:link . " (not copied)"
        endif
        echo l:link
    catch /cmd error/
        echo "GUS error: can't get URL"
    endtry
endfunction

function! gus#copy_and_show_markdown()
    try
        let l:md = "[" . gus#git_filepath() . " line " . line(".") . "](" . 
                    \gus#link_url() . ")"
        if gus#copy(l:md)
            let l:md = l:md . " (copied)"
        else
            let l:md = l:md . " (not copied)"
        endif
        echo l:md
    catch /cmd error/
        echo "GUS error: can't get URL"
    endtry
endfunction

function! gus#copy_and_show_redmine()
    try
        let l:rm  = '"' . gus#git_filepath() . " line " . line(".") . '":' . 
                    \gus#link_url() 
        if gus#copy(l:rm)
            let l:rm = l:rm . " (copied)"
        else
            let l:rm = l:rm . " (not copied)"
        endif
        echo l:rm
    catch /cmd error/
        echo "GUS error: can't get URL"
    endtry
endfunction

" Define commands

command GUS call gus#copy_and_show_url()
command GUM call gus#copy_and_show_markdown()
command GUR call gus#copy_and_show_redmine()
command GUW echo "GUS plugin is here: " . g:loc
