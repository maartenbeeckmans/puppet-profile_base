Puppet::Functions.create_function(:'netmask_to_cidr') do
  dispatch :netmask_to_cidr do
    param 'String', :netmask
    return_type 'Integer'
  end

  def netmask_to_cidr(netmask)
    netmask.split(".").map { |e| e.to_i.to_s(2).rjust(8, "0") }.join.count("1")
  end
end
