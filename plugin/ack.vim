" vnoremap <silent> <leader>F :call ack#search(1,"")<cr>
" nnoremap <silent> <leader>F :call ack#search(0,"")<cr>
" 自定义quickfix中高亮行的高亮方式 -> 保留文本颜色, 仅修改背景色
" hi QuickFixLine ctermfg=NONE ctermbg=12 guifg=NONE guibg=#de935f

" 选择后自动关闭qf窗口
if !exists('g:ack_autoclose_qf')
    let g:ack_autoclose_qf = 1
endif

if !exists('g:ack_support_regx')
    let g:ack_support_regx = 0
endif

if !exists('g:ack_openqf_when_search')
    let g:ack_openqf_when_search = 1
endif

if !exists('g:ack_focus_when_search')
    let g:ack_focus_when_search = 0
endif

if !exists('g:ack_focus_after_search')
    let g:ack_focus_after_search = 0
endif

if g:ack_autoclose_qf == 1
    autocmd FileType qf nnoremap <silent> <buffer> <CR> <CR>:cclose<CR>
endif

" ack会根据.git里的内容快速搜索结果, 可以将包含.git的所有项目目录加入到搜索路径中
let s:MyPath = expand('%:p') . " '.' "
if exists('g:ack_program_lists')
    for s:program_path in g:ack_program_lists
        if fnamemodify('', ':p') =~ fnamemodify(s:program_path, ':p') . '.*'
            let s:gitLists = split(globpath(s:program_path, '**/.git'), '\n')
            for s:gitList in s:gitLists
                let s:MyPath = s:MyPath . substitute(s:gitList, '^\(.*\)/\.git$', "'\\1'", 'g') . " "
            endfor
            break
        endif
    endfor
endif

function! ack#search(mod, args)
    if a:mod
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
        call setpos('.', [0, line_start, column_start, 0, column_start])
        let lines = getline(line_start, line_end)
        if len(lines) != 1
            echoerr "ValueError. Not allowed multi lines."
            return
        endif
        let pargs = lines[0][column_start - 1 : column_end - (&selection == 'inclusive' ? 1 : 2)]
    else
        let pargs = empty(a:args) ? expand("<cword>") : a:args
    endif
    echo ""
    if pargs == ""
        echo "No regular expression found."
        return
    endif
    let pargs = substitute(pargs, '\\', '\\\\', 'g')
    let pargs = substitute(pargs, '"', '\\"', 'g')
    let showargs = "AckSearch:\\ " . substitute(pargs, ' ', '\\ ', 'g')
    let pargs = "\"" . pargs . "\""
    if g:ack_support_regx == 0
        let pargs = "-Q " . pargs
    endif
    if g:ack_openqf_when_search
        silent! execute ":botright copen"
        if g:ack_focus_when_search == 0
            silent! execute "wincmd p"
        endif
    endif
    let s:post = "call\\ setqflist([],'a',{'title':\"" . showargs . "\"})"
    if g:ack_focus_after_search == 0
        let s:post = 'wincmd\ p|'.s:post
    endif
    let s:post = 'botright\ copen|'.s:post
    silent execute ":AsyncRun! -strip -post=".s:post." ack -s -H --nopager --nocolor --nogroup --column ".pargs." ".s:MyPath." | awk '!x[$0]++'"
    " 在qf打开之后再修改title
    if g:ack_openqf_when_search
        call setqflist([],'a',{'title':'Searching...'})
    endif
endfunction

command! -nargs=* Ack :call ack#search(0, <q-args>)
