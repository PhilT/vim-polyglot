if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'latex') == -1

" vimtex - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#fold#cmd_single#new(config) abort " {{{1
  return extend(deepcopy(s:folder), a:config).init()
endfunction

" }}}1


let s:folder = {
      \ 'name' : 'cmd_single',
      \ 're' : {},
      \ 'opened' : 0,
      \ 'cmds' : [],
      \}
function! s:folder.init() abort dict " {{{1
  let l:re = '\v^\s*\\%(' . join(self.cmds, '|') . ')\*?\s*%(\[.*\])?'

  let self.re.start = l:re . '\s*\{\s*%($|\%)'
  let self.re.end = '^\s*}'
  let self.re.text = l:re
  let self.re.fold_re = '\\%(' . join(self.cmds, '|') . ')'

  return self
endfunction

" }}}1
function! s:folder.level(line, lnum) abort dict " {{{1
  if a:line =~# self.re.start
    let self.opened = 1
    return 'a1'
  elseif self.opened && a:line =~# self.re.end
    let self.opened = 0
    return 's1'
  endif
endfunction

" }}}1
function! s:folder.text(line, level) abort dict " {{{1
  return matchstr(a:line, self.re.text) . '{...}'
        \ . substitute(getline(v:foldend), self.re.end, '', '')
endfunction

" }}}1

endif
