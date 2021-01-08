#
#
#
plan profile_base (
  TargetSpec $nodes,
) {
  apply_prep([$nodes])

  apply($nodes) {
    include ::profile_base
  }

  return("Applied profile_base")
}
