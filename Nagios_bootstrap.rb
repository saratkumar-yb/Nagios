require 'rubygems'
require 'net/ssh'
require 'optparse'
require 'socket'

opts = OptionParser.new
opts.on("-H HOSTNAME", "--hostname NAME", String, "Hostname of Server") { |v| @hostname = v }
opts.on("-u SSH USERNAME", "--username SSH USERNAME", String, "SSH Username of Server") { |v| @username = v }
opts.on("-p SSH PASSWORD", "--password SSH PASSWORD", String, "SSH Password of Server") { |v| @password = v }
opts.on("-s", "--sudo", "Run with Sudo User") do |v| 
  $sudo = v 
end
opts.on("-h", "--help", "Help") { |v| puts opts ; exit}

begin
  opts.parse!(ARGV)
rescue OptionParser::ParseError => e
  puts e
end
raise OptionParser::MissingArgument, "Hostname [-H]" if @hostname.nil?
raise OptionParser::MissingArgument, "SSH Username [-u]" if @username.nil?
raise OptionParser::MissingArgument, "SSH Password [-p]" if @password.nil?

ip = IPSocket.getaddress(Socket.gethostname)
ip = "192.168.0.50"
begin
    ssh = Net::SSH.start(@hostname, @username, :password => @password)
    stdout = ""
    stdout = ssh.exec!("wget -qO-  https://raw.githubusercontent.com/kumarsarath588/Nagios/master/get-destros.sh | bash")
    stdout = stdout.chomp
    pass = @password
    case stdout
 	when "redhat"
	   if(defined?($sudo))
	 	ssh.exec!("echo #{pass} | sudo -S yum install -y nagios-plugins.x86_64 nrpe.x86_64 nagios-plugins-nrpe.x86_64")
                ssh.exec!("echo #{pass} | sudo -S sed -i '/allowed_hosts/ s/$/,#{ip}/g' /etc/nagios/nrpe.cfg")
                ssh.exec!("echo #{pass} | sudo -S /etc/init.d/nrpe restart")
	   else	
		ssh.exec!("yum install -y nagios-plugins.x86_64 nrpe.x86_64 nagios-plugins-nrpe.x86_64")
		ssh.exec!("sed -i '/allowed_hosts/ s/$/,#{ip}/g' /etc/nagios/nrpe.cfg")
		ssh.exec!("/etc/init.d/nrpe restart")
	   end
  	when "debian"
	   if(defined?($sudo))
  		ssh.exec!("echo #{pass} | sudo -S apt-get update")
		ssh.exec!("echo #{pass} | sudo -S apt-get -y install nagios-nrpe-server nagios-plugins")
		ssh.exec!("echo #{pass} | sudo -S sed -i '/allowed_hosts/ s/$/,#{ip}/g' /etc/nagios/nrpe.cfg")
		ssh.exec!("echo #{pass} | sudo -S /etc/init.d/nrpe restart")
	   else
		ssh.exec!("apt-get update")
		ssh.exec!("apt-get install -y nagios-nrpe-server nagios-plugins")
		ssh.exec!("sed -i '/allowed_hosts/ s/$/,#{ip}/g' /etc/nagios/nrpe.cfg")
		ssh.exec!("/etc/init.d/nrpe restart")
	   end
    end
    puts ":#{stdout}:"
    ssh.close
rescue
    puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
end
