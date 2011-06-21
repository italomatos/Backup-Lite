require 'backupbase.rb'
class Ssh < BackupBase
	def backup(filename)
		`scp #{filename} #{@user_ssh}@#{@host_ssh}:`
	end
end
