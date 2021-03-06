let s:self = {}


if exists('*getcmdwintype')
  function! s:self.is_cmdwin() abort
    return getcmdwintype() !=# ''
  endfunction
else
  function! s:self.is_cmdwin() abort
    return bufname('%') ==# '[Command Line]'
  endfunction
endif

function! s:self.open(opts) abort
  let buf = get(a:opts, 'bufname', '')
  let mode = get(a:opts, 'mode', 'vertical topleft split')
  let Initfunc = get(a:opts, 'initfunc', '')
  let cmd = get(a:opts, 'cmd', '')
  if empty(buf)
    exe mode | enew
  else
    exe mode buf
  endif
  if !empty(Initfunc)
    call call(Initfunc, [])
  endif

  if !empty(cmd)
    exe cmd
  endif
endfunction


func! s:self.resize(size, ...) abort
  let cmd = get(a:000, 0, 'vertical')
  exe cmd 'resize' a:size
endf

function! s:self.listed_buffers() abort
  return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunction


function! s:self.filter_do(expr) abort
  let buffers = range(1, bufnr('$'))
  for f_expr in a:expr.expr
    let buffers = filter(buffers, f_expr)
  endfor
  for b in buffers
    exe printf(a:expr.do, b)
  endfor
endfunction


" just same as nvim_buf_set_lines
function! s:self.buf_set_lines(buffer, start, end, strict_indexing, replacement) abort
  if exists('*nvim_buf_set_lines')
    call nvim_buf_set_lines(a:buffer, a:start, a:end, a:strict_indexing, a:replacement)
  elseif has('python')
    py import vim
    py import string
    if bufexists(a:buffer)
      py bufnr = string.atoi(vim.eval("a:buffer"))
      py start_line = string.atoi(vim.eval("a:start"))
      py end_line = string.atoi(vim.eval("a:end"))
      py lines = vim.eval("a:replacement")
      py vim.buffers[bufnr][start_line:end_line] = lines
    endif
  elseif has('python3')
    py3 import vim
    py3 import string
    if bufexists(a:buffer)
      py3 bufnr = string.atoi(vim.eval("a:buffer"))
      py3 start_line = string.atoi(vim.eval("a:start"))
      py3 end_line = string.atoi(vim.eval("a:end"))
      py3 lines = vim.eval("a:replacement")
      py3 vim.buffers[bufnr][start_line:end_line] = lines
    endif
  else
  endif
endfunction


fu! SpaceVim#api#vim#buffer#get() abort
  return deepcopy(s:self)
endf
