require 'net/ftp'
require 'yaml'
#call ruby backup.rb "filaname separeted space" "databasename separated space"
config = YAML.load_file("config.yml")


#load database config
config["database"].each {|key, value| instance_variable_set("@#{key}_db", value)}

#load ftp config
config["ftp"].each {|key,value| instance_variable_set("@#{key}_ftp", value)}



# backup de banco
databases = ARGV[1].split(" ") 
result = ""
databases.each do |db|
	puts "mysqldump -u#{@user_db} -p#{@pass_db} -h#{@host_db} #{db} > #{db}.sql"
	`mysqldump -u#{@user_db} -p#{@pass_db} -h#{@host_db} #{db} > #{db}.sql`
	result << " " << "#{db}.sql"
end

#backup de arquivo
dir = ARGV[0].split(" ") 
dir.each do |d|
	result << " " << d
end
timestamp = Time.now.strftime("%Y%m%d%H%M")
filename = "backup_#{timestamp}.tar"
`tar -zcvf #{filename} #{result}`

#enviando via FTP 
Net::FTP.open(@host_ftp,@user_ftp,@pass_ftp) do |ftp|
    ftp.login
    ftp.putbinaryfile(filename,filename, 1024)
end
