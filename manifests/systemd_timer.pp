#
#
#
define profile_base::systemd_timer (
  String  $on_calendar,
  String  $command,
  String  $service_ensure = 'running',
  Boolean $service_enable = true,
  String  $service_name   = $title,
  String  $description    = $title,
  String  $user           = 'root',
  String  $group          = 'root',
) {
  # Create timer file
  $_timer_config = {
    'description' => $description,
    'service'     => "${service_name}.service",
    'on_calendar' => $on_calendar,
  }

  # Create service file
  $_service_config = {
    'description' => $description,
    'exec_start'  => $command,
    'user'        => $user,
    'group'       => $group,
  }

  ::systemd::timer{ "${service_name}.timer":
    timer_content  => epp("${module_name}/systemd_timer/timer.epp", $_timer_config),
    service_content => epp("${module_name}/systemd_timer/service.epp", $_service_config),
  }

  # Making sure timer is enabled
  service { "${service_name}.timer":
    ensure    => $service_ensure,
    enable    => $service_enable,
    subscribe => Systemd::Timer["${service_name}.timer"],
  }
}
