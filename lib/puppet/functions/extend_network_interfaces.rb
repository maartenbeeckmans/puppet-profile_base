Puppet::Functions.create_function(:'extend_network_interfaces') do
  dispatch :extend_interfaces do
    param 'String', :ifaces
    return_type 'Array'
  end

  def extend_interfaces(ifaces)
    iface_array = ifaces.split(",")
    iface_extended = Array.new
    iface_array.each do |iface|
      # skip virtual, loopback and other interfaces that are not going to be configured
      next if iface.include? ":"
      next if ["lo","ip_vti0","gretap0"].include? iface
      next if iface.match(/^docker[0-9]/)
      next if iface.match(/^br[0-9]/)
      next if iface.match(/^zr[0-9]/)
      next if iface.match(/^virbr[0-9]/)
      next if iface.match(/^vnet[0-9]/)

      iface_extended << iface
      iface_extended << "#{iface}:0"
      iface_extended << "#{iface}:1"
      iface_extended << "#{iface}:2"
    end
    iface_extended
  end
end


