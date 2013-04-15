" Vim command logger
"
" Maintainer: Kevin Mershon <nwlinkvxd@gmail.com>
" License: AGPLv3
"
if exists("vcl_loaded")
    delfun VCL_setup
    delfun VCL_log_command
endif

function! VCL_setup()
    " insert mode commands
    call VCL_audit_command("a")
    call VCL_audit_command("A")
    call VCL_audit_command("cc")
    call VCL_audit_command("c$")
    call VCL_audit_command("ci\"")
    call VCL_audit_command("ciw")
    call VCL_audit_command("i")
    call VCL_audit_command("I")
    call VCL_audit_command("o")
    call VCL_audit_command("O")

    " text manipulation
    call VCL_audit_command("yy")
    call VCL_audit_command("p")
    call VCL_audit_command("P")
    call VCL_audit_command("dd")
    call VCL_audit_command("u")

    " TODO -- add more
endfun

function! VCL_audit_command(key)
    exec "noremap <silent> <Leader>" . a:key . " " . a:key
    exec "noremap " . a:key . " :call VCL_log_command(\"" . a:key . "\")<CR>"
endfun

function! VCL_log_command(key)
    let this_command = strftime("%FT%T%z") . " " . a:key
    if g:vcl_last_command != this_command
        " log the command to file
        redir >> /tmp/commands.log
        echo this_command
        redir end
        let g:vcl_last_command = this_command
        call feedkeys("\\" . a:key)
    endif
endfun

let vcl_loaded = 1
let g:vcl_last_command = ""
call VCL_setup()
