class SSH < BackupBase
	def backup(filename)
		`scp #{filename} #{@user_ssh}@#{@host_ssh}:`
	end
end
