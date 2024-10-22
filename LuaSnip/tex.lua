-- This is the `get_visual` function I've been talking about.
-- ----------------------------------------------------------------------------
-- Summary: When `LS_SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `LS_SELECT_RAW` is empty, the function simply returns an empty insert node.
local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end
-- ----------------------------------------------------------------------------
-- Abbreviations used in this article and the LuaSnip docs
local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

return {
  -- Examples of Greek letter snippets, autotriggered for efficiency
  s({ trig = ';a' }, {
    t '\\alpha',
  }),
  s({ trig = ';b' }, {
    t '\\beta',
  }),
  s({ trig = ';g' }, {
    t '\\gamma',
  }),
  s({ trig = ';d' }, {
    t '\\delta',
  }),
  s({ trig = ';e' }, {
    t '\\epsilon',
  }),
  s({ trig = ';q' }, {
    t '\\theta',
  }),
  s({ trig = ';w' }, {
    t '\\omega',
  }),

  -- \texttt
  s({ trig = 'tt', dscr = "Expands 'tt' into '\texttt{}'" }, fmta('\\texttt{<>}', { i(1) })),

  -- \frac
  s(
    { trig = 'ff', dscr = "Expands 'ff' into '\frac{}{}'" },
    fmt(
      '\\frac{<>}{<>}',
      {
        i(1),
        i(2),
      },
      { delimiters = '<>' } -- manually specifying angle bracket delimiters
    )
  ),
  -- Equation
  s(
    { trig = 'eq', dscr = "Expands 'eq' into an equation environment" },
    fmta(
      [[
       \begin{equation}
           <>
           \label{eq:<>}
       \end{equation}
     ]],
      { i(1), i(2) }
    )
  ),

  s(
    { trig = 'mm', dscr = "Expands 'mm' to $$" },
    fmta('$<>$', {
      d(1, get_visual),
    })
  ),
  -- A fun zero subscript snippet
  --
  s({
    trig = '__', -- Regex to capture word part before '00'
    regTrig = true, -- Enable regex trigger
    wordTrig = false, -- Allow trigger inside words
  }, {
    f(function(_, snip)
      return snip.captures[1] .. '_{' -- Return the captured part with '_{'
    end),
    i(1), -- Insert node for cursor placement
    t '}',
  }),

  s(
    { trig = '([%w%)%]%}])11', regTrig = true, wordTrig = true },
    fmta('<>_{<>}', {
      f(function(_, snip)
        return snip.captures[1] .. '_{'
      end),
      t '0',
    })
  ),

  s({
    trig = ';_', -- Trigger when '00' is typed
    wordTrig = true, -- Allow it to trigger even when part of a word like 'a00'
    regTrig = false, -- No need for regex here, just match '00'
  }, {
    t '_{',
    i(1),
    t '}', -- Expand to '_{...}'
  }),

  -- Code for environment snippet in the above GIF
  s(
    { trig = 'env' },
    fmta(
      [[
      \begin{<>}
          <>
      \end{<>}
    ]],
      {
        i(1),
        i(2),
        rep(1), -- this node repeats insert node i(1)
      }
    )
  ),

  s(
    { trig = 'fig', dscr = 'insert figure' },
    fmta(
      [[
        \begin{figure}[<>]
          \includegraphics[width=<>\textwidth]{<>}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
      ]],
      { i(1), i(2), i(3), i(4), i(5) }
    )
  ),

  s(
    { trig = 'emph', dscr = "Expands 'emph' into LaTeX's emph{} command." },
    fmta('\\emph{<>}', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = 'txt', dscr = "Expands 'txt' into LaTeX's text{} command." },
    fmta('\\text{<>}', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = 'tii', dscr = "Expands 'tii' into LaTeX's textit{} command." },
    fmta('\\textit{<>}', {
      d(1, get_visual),
    })
  ),

  s(
    { trig = 'gls', dscr = "Expands 'gls' into LaTeX's gls{} command." },
    fmta('\\gls{<>}', {
      d(1, get_visual),
    })
  ),
  s(
    { trig = 'glspl', dscr = "Expands 'gls' into LaTeX's glspl{} command." },
    fmta('\\glspl{<>}', {
      d(1, get_visual),
    })
  ),

  s(
    { trig = 's2sec', dscr = 'subsubsection header' },
    fmta(
      [[ \subsubsection{<>}\label{s2sec:<>} 
    ]],
      {
        i(1),
        i(2),
      }
    )
  ),
  s(
    { trig = 'ssec', dscr = 'subsection header' },
    fmta(
      [[ \subsection{<>}\label{ssec:<>} 
    ]],
      {
        i(1),
        i(2),
      }
    )
  ),
  s(
    { trig = 'sec', dscr = 'section header' },
    fmta(
      [[ \section{<>}\label{sec:<>} 
    ]],
      {
        i(1),
        i(2),
      }
    )
  ),
}
