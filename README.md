Vim Header Appender
===

Description
---------------------------------------------------------------------------------------------------
```markdown
" ====================================================================
" filename : README.md
"  author  : chudyu
"   mail   : chdy.uuid@gmail.com
" modified : 2017-10-16 04:57
" descrip. : A plugin for vim to add or update file header information
"            according to current filetype in a simple way.
" ====================================================================
```
Install:
--------

#### With Vundle:
```vim
Plugin 'chudyu/vim-header-appender'
```
User Command:
----------
-------------

 **`:Header`**  - You can use this to add or update the file header.

------------------------------------------------------------------
Note that please always leave the original "filename" and "modified" lines unchanged in the first 10 rows if you configure the lines manually. 

Configure:
----------
Here is an example for your reference.
```vim
" -------- HeaderAppender {{{
Plugin 'chudyu/vim-header-appender'
let g:headerAppender_commentChars = {
            \ 'sh'     : '#',
            \ 'python' : '#',
            \ 'java'   : '//',
            \ 'cpp'    : '//',
            \ 'c'      : '//',
            \ 'vim'    : '"',
            \ 'markdown' : '"'
            \ }
let g:headerAppender_lines = {
            \ '1' : ' ============================================================',
            \ '2' : ' filename : '.expand("%:t"),
            \ '3' : '  author  : chdy.uuid@gmail.com' ,
            \ '4' : ' modified : '.strftime("%Y-%m-%d %H:%M"),
            \ '5' : ' descrip. : ',
            \ '6' : ' ============================================================'
            \ }
" }}}
```
