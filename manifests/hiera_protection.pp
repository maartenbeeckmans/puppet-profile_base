#
#
#
class profile_base::hiera_protection {
  $hieraenv = lookup('protect_env', String, first, '')
  if $hieraenv != $::environment {
    fail("\n\n HIERA INTEGRITY CHECK FAILED! \n \
    Hiera key protect_env: '${hieraenv}' does not mach the environment '${::environment}'.")
  }
}
