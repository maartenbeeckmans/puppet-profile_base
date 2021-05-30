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
) {
  # Create timer file
  $_timer_config = {
    'description' => $description,
    'service'     => "${service_name}.service"
    'on_calendar' => $on_calendar,
  }
  systemd::unit_file{"${service_name}.timer":
    content => epp("${module_name}/systemd_timer/timer.epp", $_timer_config),
    notify  => Service["${service_name}.service"],
  }

  # Create service file
  $_service_config = {
    'description' => $description,
    'exec_start'  => $command,
  }
  ::systemd::unit_file{ "${service_name}.service":
    content => epp("${module_name}/systemd_timer/service.epp", $_service_config),
  }

  # Making sure timer is enabled
  service { "${service_name}.timer":
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
