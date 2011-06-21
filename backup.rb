require "yaml"
require "ssh.rb"
require "ftp.rb"
# #call ruby backup.rb "filaname separeted space" "databasename separated space"

if (ARGV[3]) 
  config = YAML.load_file(ARGV[3])
else
  config = YAML.load_file("config.yml")
end

#config.each do |key, value|
#	config[key].each {|key_attr, value| instance_variable_set("@#{key_attr}_#{key}", value)}
#end

#load database config
config["database"].each {|key, value| instance_variable_set("@#{key}_db", value)}

#load ftp config
#config["ftp"].each {|key,value| instance_variable_set("@#{key}_ftp", value)}


# backup database
databases = ARGV[1].split(" ") 
result = ""
databases.each do |db|
	puts "mysqldump -u#{@user_db} -p#{@pass_db} -h#{@host_db} #{db} > #{db}.sql"
	`mysqldump -u#{@user_db} -p#{@pass_db} -h#{@host_db} #{db} > #{db}.sql`
	result << " " << "#{db}.sql"
end

#backup files
dir = ARGV[2].split(" ") 
dir.each do |d|
	result << " " << d
end
exclude_pattern = config["general"]["exclude_files_pattern"]
result = " --exclude='#{exclude_pattern}'" + result if exclude_pattern && !exclude_pattern.empty?
timestamp = Time.now.strftime("%Y%m%d%H%M")
filename = "#{ARGV[0]}_backup_#{timestamp}.tar"
`tar -zcvf #{filename} #{result}`


method = config["general"]["method"]
obj = eval(method.capitalize).new
obj.backup(filename)

# # removing backup file after send it to other server
`rm #{filename}`
`rm *.sql`

