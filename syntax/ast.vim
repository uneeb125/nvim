" Vim syntax file
" Language: AST debug output
" Maintainer: Gemini
" Last Change: 2025 Nov 12

if exists("b:current_syntax")
  finish
endif

" Case matters
syn case match

" Keywords
syn keyword astKeyword Some None Final Default No Not Inherited Joint Alone JointHidden Semicolon Parenthesis

" Types/Struct names
syn keyword astType Crate Item Fn FnSig FnHeader FnDecl Block Stmt Local Pat Expr Ty Path PathSegment Generics WhereClause Visibility FieldDef Struct MacCall Lit TokenStream Token MacCallStmt DelimArgs StructExpr ExprField BindingMode FieldDef ModSpans FnHeader Spanned Lit Local PatKind MacCallStmt DelimSpan DelimArgs TokenTree

" Rust-style identifiers with #0
syn match astType "\<\w\+#\d\+\>" 

" Identifiers (field names ending with a colon)
syn match astIdentifier "\w\+\s*:"

" Strings
syn region astString start=/"/ skip=/\\"/ end=/"/

" Comments (for source locations)
syn match astComment "\w\+\(\.rs\)\=:\d\+:\d\+:\s*\d\+:\d\+\s*(#\d\+)"
syn match astComment "no-location\s*(#\d\+)"

" NodeId
syn match astNodeId "NodeId(\d\+)"

" Numbers
syn match astNumber "\d\+"

" Highlight links
hi def link astKeyword Keyword
hi def link astType Type
hi def link astIdentifier Constant
hi def link astString String
hi def link astComment Comment
hi def link astNodeId Label
hi def link astNumber Number

let b:current_syntax = "ast"
