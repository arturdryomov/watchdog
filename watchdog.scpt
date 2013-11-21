property temporaryLocalFolder : "TMP"
property stableLocalFolder : "STABLE"

property messageRecipients : {"name.surname@mail.com", "nickname@mail.com"}
property messageSubject : "Files were changed"


on run
	checkFiles()
end run


on checkFiles()
	checkFile("REMOTE_FILE_LINK", "LOCAL_FILE_NAME")
	checkFile("REMOTE_FILE_LINK", "LOCAL_FILE_NAME")
	checkFile("REMOTE_FILE_LINK", "LOCAL_FILE_NAME")
end checkFiles


on checkFile(remoteFileLink, localFileName)
	set stableLocalFilePath to buildStableLocalFilePath(localFileName)
	set temporaryLocalFilePath to buildTemporaryLocalFilePath(localFileName)

	downloadFile(remoteFileLink, temporaryLocalFilePath)

	tell application "Finder"
		if not (exists my POSIX file stableLocalFilePath) then
			move my POSIX file temporaryLocalFilePath to POSIX file stableLocalFolder
			return
		end if
	end tell

	set stableLocalFileHash to calculateHash(stableLocalFilePath)
	set temporaryLocalFileHash to calculateHash(temporaryLocalFilePath)

	considering case
		if stableLocalFileHash is not equal to temporaryLocalFileHash then
			tell application "Finder" to move my POSIX file temporaryLocalFilePath to POSIX file stableLocalFolder with replacing
			sendMessage(remoteFileLink)
		end if
	end considering
end checkFile


on buildStableLocalFilePath(localFileName)
	return buildFilePath(stableLocalFolder, localFileName)
end buildStableLocalFilePath


on buildFilePath(folder, fileName)
	return folder & "/" & fileName
end buildFilePath


on buildTemporaryLocalFilePath(localFileName)
	return buildFilePath(temporaryLocalFolder, localFileName)
end buildTemporaryLocalFilePath


on downloadFile(remoteFileLink, localFile)
	do shell script "curl --output " & localFile & " --remote-name " & remoteFileLink
end downloadFile


on calculateHash(filePath)
	return do shell script "md5 -q " & filePath
end calculateHash


on sendMessage(remoteFileLink)
	set messageContent to "Link to the file is " & remoteFileLink

	tell application "Mail"
		set theNewMessage to make new outgoing message with properties {subject:messageSubject, content:messageContent}

		tell theNewMessage
			repeat with messageRecipient in messageRecipients
				make new to recipient at end of to recipients with properties {address:messageRecipient}
			end repeat
			send
		end tell
	end tell
end sendMessage
