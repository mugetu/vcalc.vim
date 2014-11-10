"=============================================================================
" ビジュアル計算機
" Version: 1.0
" Last Change: 2014/10/29 15:36:33.
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

if !exists('g:vcalc_enable')
  let g:vcalc_enable = 1
elseif v:version < 700
  echoerr 'Vcalc does not work this version of Vim "' . v:version . '".'
  finish
endif

if exists('g:loaded_vcalc') || !g:vcalc_enable
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" Obsolute options check. "{{{
"}}}

" Plugin key-mappings. "{{{
nnoremap <silent> <Plug>(vcalc) :Vcalc<CR>
"ex) nmap <Leader>vc <Plug>(vcalc)

if !hasmapto('<Plug>(vcalc)')
      \ && (!exists('g:vcalc_no_default_key_mappings')
      \   || !g:vcalc_no_default_key_mappings)
  silent! map <unique> <Leader>vcal <Plug>(vcalc)
endif
"}}}

augroup vcalc "{{{
augroup END"}}}

" Commands. "{{{
command! -nargs=0 Vcalc call vcalc#calc()
"}}}

let g:loaded_vcalc = 1

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: foldmethod=marker
