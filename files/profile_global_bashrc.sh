# File managed by Puppet
# Do not edit manually
if [ "$PS1" ]; then
  if [ "$BASH" ] && [ "$BASH" != "/bin/sh" ]; then
    # This file bash.rc already sets the default PS1
    # PS1='0
    if [ -f /etc/bash.bashrc ]; then
      . /etc/bash.bashrc
    fi
  fi
fi
