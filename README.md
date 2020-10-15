# vim-ack

在vim里方便使用的ack查询工具 (命令行中需要能够使用ack命令)

可使用 `:Ack ` 命令搜索指定内容, 默认匹配纯文本

配置快捷键后, 可对选中内容或当前指向单词进行搜索

# 安装

* 需要先安装插件 `Plug 'skywind3000/asyncrun.vim'`

加入vimrc的插件列表中即可, 如

```
call plug#begin()

Plug 'skywind3000/asyncrun.vim'
Plug 'ZhuzhuNo3/vim-ack'

call plug#end()
```

# 配置

```
" 在visual模式下对选中内容进行搜索
vnoremap <silent> <leader>F :call ack#search(1,"")<cr>
" 在normal模式下对光标指向的单词进行搜索
nnoremap <silent> <leader>F :call ack#search(0,"")<cr>
```

# 选项

### `g:ack_autoclose_qf`

默认: `let g:ack_autoclose_qf = 1`

为1时, 在quickfix窗口中选择文件后, 自动关闭quickfix窗口. 为0时不会自动关闭

### `g:ack_support_regx`

默认: `let g:ack_support_regx = 0`

为0时, 完全匹配目标文本

为1时, 支持perl正则表达式(ack自带的), 表达式不需要在两侧加引号, 需转义的字符正常转义即可, 如 `:Ack Hello W.*zhuzhu` 可以匹配到 `Hello World, my name is zhuzhu.`

### `g:ack_openqf_when_search`

默认: `let g:ack_openqf_when_search = 1`

为1时, 搜索即打开quickfix窗口. 为0时, 搜索结束后打开quickfix窗口.

### `g:ack_focus_when_search`

默认: `let g:ack_focus_when_search = 0`

当 `g:ack_focus_when_search == 1` 时该选项生效.

为0时, 搜索时光标停留在当前buffer. 为1时, 搜索时光标聚焦至quickfix窗口.

### `g:ack_focus_after_search`

默认: `let g:ack_focus_after_search = 0`

为0时, 搜索结束后光标仍停留在当前buffer. 为1时, 搜索结束后光标聚焦至quickfix窗口.

### `g:ack_program_lists`

默认不进行设置

为list格式, 可将自己项目的根目录放进来, 如果当前vim的工作路径在列表中的某个项目下的话, 在搜索时, 会以该项目以及其内包含的所有git项目作为搜索路径 (原理, 找到项目中最顶层的包含.git文件的目录, 添加至ack的搜索路径下, ack可以根据目录中的.git来查找文件)

例子:

```
let g:ack_program_lists = [
    \ '~/Code/GitProgramA',
    \ '/root/src/GitProgramB',
    \ ]
```
