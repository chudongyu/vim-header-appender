" ====================================================================
" filename : vim-header-appender.vim
"  author  : chudyu
"   mail   : chdy.uuid@gmail.com
" modified : 2017-10-16 04:57
" descrip. : A plugin for vim to add or update file header information
"            according to current filetype in a simple way.
" ====================================================================
"
command! Header :call FileHeaderAppender()
" Update file header if word 'modified' is in the first 10 lines
" Or add new file header if there is no 'modified'
function! FileHeaderAppender()
    let n = 1
    while n < 10
        let line = getline(n)
        if line =~ '^\S*\s*modified : \s*.*$'
            call UpdateHeader()
            return
        endif
        let n += 1
    endwhile
    call AddHeader()
endfunction
" --- UpdateHeader {{{
function! UpdateHeader()
    normal ggj
    exe '/ *filename :/s@:.*$@\=": ".expand("%:t")@'
    normal j
    exe '/ *modified :/s@:.*$@\=strftime(": %Y-%m-%d %H:%M")@'
    exe 'noh'
    echo "Header updated successfully."
endfunction
" }}}
" ---- AddHeader {{{
function! AddHeader()
    if exists('g:headerAppender_commentChars')
        let l:headerAppender_commentChars = g:headerAppender_commentChars
    else
        let l:headerAppender_commentChars = {
                    \ 'sh'     : '#',
                    \ 'python' : '#',
                    \ 'ruby'   : '#',
                    \ 'java'   : '//',
                    \ 'cpp'    : '//',
                    \ 'c'      : '//',
                    \ 'go'     : '//',
                    \ 'php'    : '//',
                    \ 'lua'    : '--',
                    \ 'vim'    : '"'
                    \ }
    endif
    if !has_key(l:headerAppender_commentChars, &filetype)
        echohl WarningMsg | echo "Comment charactor not defined for current filetype." | echohl None
        return
    endif
    let l:commentchar = l:headerAppender_commentChars[&filetype]

    if exists('g:headerAppender_lines')
        let l:headerAppender_lines = g:headerAppender_lines
    else
        let l:headerAppender_lines = {
                    \ '1' : ' ============================================================',
                    \ '2' : ' filename : '.expand("%:t"),
                    \ '3' : '  author  : ',
                    \ '4' : ' modified : '.strftime("%Y-%m-%d %H:%M"),
                    \ '5' : ' descrip. : ',
                    \ '6' : ' ============================================================'
                    \ }
    endif
    let l:linecount = len(l:headerAppender_lines)

    while l:linecount != 0
        let l:tmpline = l:commentchar.l:headerAppender_lines[l:linecount]
        call append(0, l:tmpline)
        let l:linecount -= 1
    endwhile
    if &filetype == 'make'
        call append(0,"")
        call append(1,"")
    elseif &filetype == 'sh'
        call append(0,"#!/usr/bin/sh")
        call append(1,"")
    elseif &filetype == 'python'
        call append(0,"# coding=utf-8")
        call append(1,"")
        " linux: has("unix"), not has("linux")
        if has("unix")
            call append(0,"#!/usr/bin/env python")
        endif
    elseif &filetype == 'c'
        let l:tmp = len(l:headerAppender_lines)
        call append(l:tmp, "#include<stdio.h>")
        call append(l:tmp+1, "")
        "call append(0,"#include \"".expand("%:t:r").".h\"")
    elseif expand("%:e") == 'h'
        " .h file will be recognized as cpp filetype
        let l:tmp = len(l:headerAppender_lines)
        call append(l:tmp, "#ifndef _".toupper(expand("%:r"))."_H")
        call append(l:tmp+1, "#define _".toupper(expand("%:r"))."_H")
        call append(l:tmp+2, "#endif")
        call append(l:tmp+3, "")
    "elseif expand("%:e") == 'cpp'
    elseif &filetype == 'cpp'
        let l:tmp = len(l:headerAppender_lines)
        call append(l:tmp, "#include<iostream>")
        call append(l:tmp+1, "using namespace std;")
        call append(l:tmp+2, "")
    elseif &filetype == 'java'
        let l:tmp = len(l:headerAppender_lines)
        call append(l:tmp,"public class ".expand("%:r"))
        call append(l:tmp+1,"")
    elseif &filetype == 'ruby'
        call append(0,"#!/usr/bin/env ruby")
        call append(1,"# encoding: utf-8")
        call append(2,"")
    endif
    echo "Header added successfully."
endfunction
" }}}
