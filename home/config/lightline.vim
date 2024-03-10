let s:bg=['colour000', 0]
let s:red=['colour1', 1]
let s:green=['colour2', 2]
let s:yellow=['colour11', 3]
let s:blue=['colour4', 4]
let s:teal=['colour7', 6]
let s:grey=['colour8', 7]
let s:white=['colour15', 8]
let s:orange=['colour16', 9]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [ s:bg, s:green ], [ s:bg, s:white ] ]
let s:p.normal.middle = [ [ s:white, s:bg ] ]
let s:p.normal.right = [ [ s:bg, s:green ], [ s:bg, s:white ] ]
let s:p.normal.error = [ [ s:bg, s:red ] ]
let s:p.normal.warning = [ [ s:bg, s:yellow ] ]

let s:p.inactive.left =  [ [ s:white, s:bg ], [ s:white, s:bg ] ]
let s:p.inactive.middle = [ [ s:white, s:bg ] ]
let s:p.inactive.right = copy(s:p.inactive.left)

let s:p.insert.left = [ [ s:bg, s:blue ], [ s:bg, s:white ] ]
let s:p.insert.right = copy(s:p.insert.left)

let s:p.replace.left = [ [ s:bg, s:red ], [ s:bg, s:white ] ]
let s:p.replace.right = copy(s:p.replace.left)

let s:p.visual.left = [ [ s:bg, s:orange ], [ s:bg, s:white ] ]
let s:p.visual.right = copy(s:p.visual.left)

let s:p.tabline.left = [ [ s:white, s:bg ] ]
let s:p.tabline.tabsel = copy(s:p.normal.right)
let s:p.tabline.middle = [ [ s:white, s:bg ] ]
let s:p.tabline.right = copy(s:p.normal.right)

let g:lightline#colorscheme#t#palette = lightline#colorscheme#flatten(s:p)

function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction
