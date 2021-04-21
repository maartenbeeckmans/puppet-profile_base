Facter.add(:hypervisor) do
  setcode do
    if File.exist? '/etc/hypervisor'
      Facter::Util::Resolution.exec('cat /etc/hypervisor')
    end
  end
end
