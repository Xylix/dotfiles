function! Tabline()
    let s = ''
    for i in range(tabpagenr('$'))
	let tab = i + 1
	let winnr = tabpagewinnr(tab)
	let buflist = tabpagebuflist(tab)
	let bufnr = buflist[winnr - 1]
	let bufname = bufname(bufnr)
	let bufmodified = getbufvar(bufnr, "&mod")

	let s .= '%' . tab . 'T'
	let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
	let s .= ' ' . tab .':'
	let s .= (bufname != '' ? '['. fnamemodify(bufname, ':t') . '] ' : '[No Name] ')

	if bufmodified
	    let s .= '[+] '
	endif
    endfor

    let s .= '%#TabLineFill#'
    if (exists("g:tablineclosebutton"))
	let s .= '%=%999XX'
    endif
    return s
endfunction

function! FoldText()
    let l:lpadding = &fdc
    redir => l:signs
	execute 'silent sign place buffer='.bufnr('%')
    redir End
    let l:lpadding += l:signs =~ 'id=' ? 2 : 0

    " Won't work with relativenumbers, they require some bubblegum
    if (&number)
	let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
    endif

    " expand tabs
    let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
    let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

    let l:width = winwidth(0) - l:lpadding

    let l:separator = ' … '
    let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
    let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
    let l:text = l:start . ' … ' . l:end

    return l:text  . repeat(' ', l:width - strlen(substitute(l:text, ".", "x", "g")))
endfunction

function VimConfig() 
    set tabline=%!Tabline()
    set foldtext=FoldText()

    if has("autocmd")
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
		    \| exe "normal! g'\"" | endif
    endif
    lang en_US.UTF-8

    set autoread
    set encoding=utf-8
    set mouse=a
    set linebreak number title
    set backspace=2 " make backspace work like most other programs
    set laststatus=0
    set shiftwidth=4
    set clipboard=unnamedplus
    "Consider _ a word delimiter
    set iskeyword+=_

    "Hide buffer something
    set hidden
    "Store an undo buffer in a file in $HOME/.vimundo
    set undofile
    set undolevels=1000
    set undoreload=10000
    "Set deus as colorscheme and some related variables to ensure proper background 
    set t_Co=256
    set termguicolors
    
    "Configure folds by syntax by default and open files with all folds open
    set foldmethod=syntax
    set fillchars=fold:\
    autocmd BufNewFile,BufFilePre,BufRead * normal zR
    
    autocmd FileType python setlocal foldmethod=indent
    autocmd FileType haskell setlocal expandtab tabstop=4 shiftwidth=4 expandtab 
    "jsx js tsx ts config
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact setlocal tabstop=2 shiftwidth=2 expandtab
    "markdown config
    autocmd BufNewFile,BufFilePre,BufRead *.md setlocal filetype=markdown
    autocmd FileType markdown setlocal nonumber
    autocmd FileType tex setlocal nonumber
    
    autocmd BufNewFile,BufRead *.robot setlocal filetype=robot

    autocmd FileType haskell syn match haskellLambda '\\' conceal cchar=λ
    autocmd FileType haskell set conceallevel=2 concealcursor=nv
    autocmd FileType haskell syn match haskellCompose '\.' conceal cchar=∘


    set listchars=eol:$,nbsp:_,tab:>-,trail:~,extends:>,precedes:<

    " Disable ex mode hotkey and command history search hotkey
    map q: <Nop>
    nnoremap Q <nop>

endfunction
