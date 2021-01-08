#
#
#
plan profile_base (
  TargetSpec $targets,
) {
  apply_prep([$targets])

  run_plan("profile_base")

  return("Applied profile_base")
}
