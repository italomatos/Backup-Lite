require 'net/ftp'

class FTP < BackupBase
	def backup(filename)
		Net::FTP.open(@host_ftp) do |ftp|
			ftp.passive = true
			ftp.login(@user_ftp,@pass_ftp)
			ftp.putbinaryfile(filename,File.basename(filename), 1024)
		end
	end
end
