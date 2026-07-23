-- Intentionally use completion-triggered snippets rather than automatic ones:
-- prose is never unexpectedly rewritten while drafting a paper.
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

local function in_mathzone()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

ls.add_snippets("tex", {
  s("beg", {
    t({ "\\begin{" }),
    i(1, "environment"),
    t({ "}", "  " }),
    i(0),
    t({ "", "\\end{" }),
    rep(1),
    t("}"),
  }),
  s("eq", {
    t({ "\\begin{equation}", "  " }),
    i(1),
    t({ "", "  \\label{eq:" }),
    i(2, "name"),
    t({ "}", "\\end{equation}" }),
  }),
  s("fig", {
    t({ "\\begin{figure}[tbp]", "  \\centering", "  \\includegraphics[width=" }),
    i(1, "\\linewidth"),
    t("]{"),
    i(2, "figure"),
    t({ "}", "  \\caption{" }),
    i(3, "caption"),
    t({ "}", "  \\label{fig:" }),
    i(4, "name"),
    t({ "}", "\\end{figure}" }),
  }),
  s("cite", { t("\\cite{"), i(1, "key"), t("}") }),
  s("emph", { t("\\emph{"), i(1), t("}") }),

  s({ trig = "ff", wordTrig = false, condition = in_mathzone }, {
    t("\\frac{"),
    i(1),
    t("}{"),
    i(2),
    t("}"),
  }),
  s({ trig = "sum", condition = in_mathzone }, {
    t("\\sum_{"),
    i(1, "i = 1"),
    t("}^{"),
    i(2, "n"),
    t("} "),
    i(0),
  }),
  s({ trig = "lim", condition = in_mathzone }, {
    t("\\lim_{"),
    i(1, "n \\to \\infty"),
    t("} "),
    i(0),
  }),
})
