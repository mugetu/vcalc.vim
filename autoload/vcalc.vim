"=============================================================================
" ビジュアル計算機
" Version: 1.0
" Last Change: 2014/10/29 15:36:15.
" Author: mugetu
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:LeftNum = 0.0
let s:RightNum = 0.0
let s:CalcStr = ""
let s:periodflg= 0

function! vcalc#calc() "{{{
   exe ":"
   exe "vnew"
   exe "normal 19\<c-w>|"

   exe "normal I       Vcalc\<CR>\<Esc>"
   exe "normal I +---------------+\<CR>\<Esc>"
   exe "normal I |               |\<CR>\<Esc>"
   exe "normal I |              0|\<CR>\<Esc>"
   exe "normal I +---------------+\<CR>\<Esc>"
   exe "normal I +---+---+---+---+\<CR>\<Esc>"
   exe "normal I |   |   |CE | C |\<CR>\<Esc>"
   exe "normal I +---+---+---+---+\<CR>\<Esc>"
   exe "normal I | 7 | 8 | 9 | / |\<CR>\<Esc>"
   exe "normal I +---+---+---+---+\<CR>\<Esc>"
   exe "normal I | 4 | 5 | 6 | * |\<CR>\<Esc>"
   exe "normal I +---+---+---+---+\<CR>\<Esc>"
   exe "normal I | 1 | 2 | 3 | - |\<CR>\<Esc>"
   exe "normal I +---+---+---+---+\<CR>\<Esc>"
   exe "normal I | 0 |   | . | + |\<CR>\<Esc>"
   exe "normal I +---+---+---+---+\<CR>\<Esc>"
   exe "normal I |   |   |   | = |\<CR>\<Esc>"
   exe "normal I +---+---+---+---+\<CR>\<Esc>"
   exe "normal 1G"

   exe "setlocal nonumber"
   if v:version >= 704
      " カレント行からの相対的な行番号を表示
      exe "setlocal norelativenumber"
   endif

   exe "setlocal noautoindent"
   exe "setlocal nomodifiable"
   exe "setlocal filetype=vcalc"

   exe 'nnoremap <silent> <buffer> <cr> :call <SID>CalcDoAction()<cr>'
   exe 'nnoremap <silent> <buffer> <2-LeftMouse> :call <SID>CalcDoAction()<cr>'

   exe 'nnoremap <silent> <buffer> <Esc> :call <SID>CalcClearAction("C")<cr>'
   exe 'nnoremap <silent> <buffer> = :call <SID>CalcEnterAction()<cr>'

   exe 'nnoremap <silent> <buffer> 0 :call <SID>CalcDoAction("0")<cr>'
   exe 'nnoremap <silent> <buffer> 1 :call <SID>CalcDoAction("1")<cr>'
   exe 'nnoremap <silent> <buffer> 2 :call <SID>CalcDoAction("2")<cr>'
   exe 'nnoremap <silent> <buffer> 3 :call <SID>CalcDoAction("3")<cr>'
   exe 'nnoremap <silent> <buffer> 4 :call <SID>CalcDoAction("4")<cr>'
   exe 'nnoremap <silent> <buffer> 5 :call <SID>CalcDoAction("5")<cr>'
   exe 'nnoremap <silent> <buffer> 6 :call <SID>CalcDoAction("6")<cr>'
   exe 'nnoremap <silent> <buffer> 7 :call <SID>CalcDoAction("7")<cr>'
   exe 'nnoremap <silent> <buffer> 8 :call <SID>CalcDoAction("8")<cr>'
   exe 'nnoremap <silent> <buffer> 9 :call <SID>CalcDoAction("9")<cr>'

   exe 'nnoremap <silent> <buffer> + :call <SID>CalcDoAction("+")<cr>'
   exe 'nnoremap <silent> <buffer> - :call <SID>CalcDoAction("-")<cr>'
   exe 'nnoremap <silent> <buffer> * :call <SID>CalcDoAction("*")<cr>'
   exe 'nnoremap <silent> <buffer> / :call <SID>CalcDoAction("/")<cr>'

   " keybind
   exe 'nnoremap <silent> <buffer> q :q!<cr>'
endfunction
"}}}
function! s:CalcDoAction(...) "{{{
    let l:cword = ""
    if a:0 == 1
        let l:cword = a:1
    else
        let l:cword = expand("<cWORD>")
        let l:cword = substitute(l:cword, ' ', '', 'g')
        let l:cword = substitute(l:cword, '|', '', 'g')
        let l:cword = substitute(l:cword, '-+', '', 'g')
        let l:cword = substitute(l:cword, '+-', '', 'g')
        let l:cword = substitute(l:cword, '-------', '', '')
        let l:cword = substitute(l:cword, '------', '', '')
    endif

    if l:cword == "C" || l:cword == "CE"
        call s:CalcClearAction(l:cword)
        return
    endif

    if l:cword == "="
        call s:CalcEnterAction()
        return
    endif

    exe "setlocal modifiable"

    if l:cword == "0" ||
     \ l:cword == "1" ||
     \ l:cword == "2" ||
     \ l:cword == "3" ||
     \ l:cword == "4" ||
     \ l:cword == "5" ||
     \ l:cword == "6" ||
     \ l:cword == "7" ||
     \ l:cword == "8" ||
     \ l:cword == "9"
        let l:disp = ""
        if s:periodflg == 1
             if s:CalcStr == ""
                  let l:disp = s:DispNum(s:LeftNum) . "." . l:cword
             else
                  let l:disp = s:DispNum(s:RightNum) . "." . l:cword
             endif
        else
             if s:CalcStr == ""
                  let l:disp = s:DispNum(s:LeftNum) . l:cword
             else
                  let l:disp = s:DispNum(s:RightNum) . l:cword
             endif
        endif

        if s:CalcStr == ""
             let s:LeftNum = str2float(l:disp)
             let l:disp = s:DispNum(s:LeftNum)
        else
             let s:RightNum = str2float(l:disp)
             let l:disp = s:DispNum(s:RightNum)
        endif

        call s:SetNumLine(l:disp)

    endif

    if l:cword == "."
        if s:periodflg == 0
            let s:periodflg = 1

            let l:disp = ""
            if s:CalcStr == ""
                let l:disp = s:DispNum(s:LeftNum)
            else
                let l:disp = s:DispNum(s:RightNum)
            endif

            call s:SetNumLine(l:disp)
        endif
    endif

    if l:cword == "+"
        let s:CalcStr = "+"
    elseif l:cword == "-"
        let s:CalcStr = "-"
    elseif l:cword == "*"
        let s:CalcStr = "*"
    elseif l:cword == "/"
        let s:CalcStr = "/"
    endif
    if l:cword == "+" || l:cword == "-" || l:cword == "*" || l:cword == "/"
        if s:CalcStr != ""
            call s:SetDispLine(s:DispNum(s:LeftNum) . " " . s:CalcStr)
        endif
        let s:periodflg= 0
    endif

    exe "setlocal nomodifiable"
endfunction
"}}}
function! s:CalcEnterAction() "{{{
    exe "setlocal modifiable"

    if s:CalcStr == "+"
        let s:calc = s:LeftNum + s:RightNum
    elseif s:CalcStr == "-"
        let s:calc = s:LeftNum - s:RightNum
    elseif s:CalcStr == "*"
        let s:calc = s:LeftNum * s:RightNum
    elseif s:CalcStr == "/"
        let s:calc = s:LeftNum / s:RightNum
    else
        let s:calc = s:LeftNum
    endif

    call s:SetNumLine(s:DispNum(s:calc))
    call s:SetDispLine("")

    let s:LeftNum = s:calc
    let s:RightNum = 0.0
    let s:CalcStr = ""
    let s:periodflg= 0

    exe "setlocal nomodifiable"
endfunction
"}}}
function! s:CalcClearAction(cword) "{{{
    exe "setlocal modifiable"

    call s:SetNumLine("0")

    if a:cword == "C"
        call s:SetDispLine("")

        let s:LeftNum = 0.0
        let s:RightNum = 0.0
        let s:CalcStr = ""

    elseif a:cword == "CE"
      if s:CalcStr == ""
          let s:LeftNum = 0.0
      else
          let s:RightNum = 0.0
      endif

    end

    let s:periodflg = 0

    exe "setlocal nomodifiable"
endfunction
"}}}

function! s:SetNumLine(word) "{{{
    let l:space = s:CreateSpace(a:word)
    let l:pos = getpos('.')
    call cursor(4,1)
    exe "normal dd"
    exe "normal O |" . l:space . a:word . "|\<Esc>"
    call setpos('.', l:pos)
endfunction
"}}}
function! s:SetDispLine(word) "{{{
    let l:space = s:CreateSpace(a:word)
    let l:pos = getpos('.')
    call cursor(3,1)
    exe "normal dd"
    exe "normal O |" . l:space . a:word . "|\<Esc>"
    call setpos('.', l:pos)
endfunction
"}}}
function! s:CreateSpace(num) "{{{
    let l:space = ""
    while strlen(l:space) + strlen(a:num) < 15
        let l:space = l:space . " "
    endwhile
    return l:space
endfunction
"}}}
function! s:DispNum(num) "{{{
    let l:d = printf("%f", floor(a:num))
    let l:f = printf("%f", a:num)
    let l:out = ""
    if l:d == l:f
        let l:out = printf("%.0f", a:num)
    else
        let l:out = printf("%g", a:num)
    endif
    return l:out
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: foldmethod=marker
