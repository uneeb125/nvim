return {
  s("comp", {
    t("#[compartments("),
    i(1),
    t(")]")
  }),
  s("trusted_comp", {
    t("#[trusted_compartments("),
    i(1),
    t(")]")
  }),
  s("compas", {
    t("compas comp("),
    i(1),
    t(")")
  }),
  s("init", {
    i(1, "StructName"),
    t(" { "),
    i(2, ".."),
    t(" }")
  }),
}
