local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local rep = require("luasnip.extras").rep -- 1. Import the repeat node

local snippets = {
  -- Basic begin/end environment
  s("beg", fmt([[
\begin{{{}}}
  {}
\end{{{}}}
  ]], { i(1), i(2), rep(1) })),

  -- Equation environment
  s("eq", fmt([[
\begin{{equation}}
  {}
\end{{equation}}
  ]], { i(1) })),

  -- Align environment
  s("ali", fmt([[
\begin{{align}}
  {}
\end{{align}}
  ]], { i(1) })),

  -- Figure environment with label and caption
  s("fig", fmt([[
\begin{{figure}}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]{{{}}}
  \caption{{{}}}
  \label{{fig:{}}}
\end{{figure}}
  ]], { i(1, "image"), i(2, "caption"), i(3, "label") })),

  -- Table environment
  s("tab", fmt([[
\begin{{table}}[htbp]
  \centering
  \caption{{{}}}
  \label{{tab:{}}}
  \begin{{tabular}}{{{}}}
    {}
  \end{{tabular}}
\end{{table}}
  ]], { i(1, "caption"), i(2, "label"), i(3, "c"), i(4) })),

  -- Section
  s("sec", fmt("\\section{{{}}}", { i(1, "Section") })),

  -- Subsection
  s("sub", fmt("\\subsection{{{}}}", { i(1, "Subsection") })),

  -- Subsubsection
  s("ssub", fmt("\\subsubsection{{{}}}", { i(1, "Subsubsection") })),

  -- Fraction
  s("frac", fmt("\\frac{{{}}}{{{}}}", { i(1, "num"), i(2, "den") })),

  -- Sum with limits
  s("sum", fmt("\\sum_{{{}}}^{{{}}}", { i(1, "i=1"), i(2, "n") })),

  -- Integral
  s("int", fmt("\\int_{{{}}}^{{{}}}", { i(1, "a"), i(2, "b") })),

  -- Partial derivative
  s("part", fmt("\\frac{{\\partial {}}}{{\\partial {}}}", { i(1, "f"), i(2, "x") })),

  -- Matrix
  s("mat", fmt([[
\begin{{bmatrix}}
  {}
\end{{bmatrix}}
  ]], { i(1) })),

  -- Citation
  s("cite", fmt("\\cite{{{}}}", { i(1, "key") })),

  -- Reference
  s("ref", fmt("\\ref{{{}}}", { i(1, "label") })),

  -- Label
  s("lab", fmt("\\label{{{}}}", { i(1, "label") })),

  -- Bold text
  s("bf", fmt("\\textbf{{{}}}", { i(1) })),

  -- Italic text
  s("it", fmt("\\textit{{{}}}", { i(1) })),

  -- Emphasized text
  s("em", fmt("\\emph{{{}}}", { i(1) })),

  -- Underline
  s("ul", fmt("\\underline{{{}}}", { i(1) })),

  -- Typewriter text
  s("tt", fmt("\\texttt{{{}}}", { i(1) })),

  -- Math mode inline
  s("mm", fmt("${}$", { i(1) })),

  -- Display math
  s("dm", fmt([[
\[
  {}
\]], { i(1) })),

  -- Itemize
  s("item", fmt([[
\begin{{itemize}}
  \item {}
\end{{itemize}}
  ]], { i(1) })),

  -- Enumerate
  s("enum", fmt([[
\begin{{enumerate}}
  \item {}
\end{{enumerate}}
  ]], { i(1) })),

  -- Description
  s("desc", fmt([[
\begin{{description}}
  \item[{}] {}
\end{{description}}
  ]], { i(1, "term"), i(2, "description") })),

  -- Code listing (listings package)
  s("lst", fmt([[
\begin{{lstlisting}}[language={}]
{}
\end{{lstlisting}}
  ]], { i(1, "Python"), i(2) })),

  -- URL
  s("url", fmt("\\url{{{}}}", { i(1, "https://example.com") })),

  -- Hyperlink
  s("href", fmt("\\href{{{}}}{{{}}}", { i(1, "https://example.com"), i(2, "link text") })),

  -- Document class and begin document
  s("doc", fmt([[
\documentclass[{}]{{{}}}
\usepackage{{amsmath,amssymb,graphicx}}
\usepackage{{hyperref}}

\title{{{}}}
\author{{{}}}
\date{{{}}}

\begin{{document}}
\maketitle

{}

\end{{document}}
  ]], { i(1, "12pt"), i(2, "article"), i(3, "Title"), i(4, "Author"), i(5, "\\today"), i(6) })),
}

return snippets
