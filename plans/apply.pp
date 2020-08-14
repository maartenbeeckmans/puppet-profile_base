plan profile_base::apply (
  TargetSpec $targets,
) {
  # Ensure puppet tools are installed
  apply_prep($targets)

  apply($targets) {
    class { 'profile_base': }
  }
}
