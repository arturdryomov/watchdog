var MAIL_RECIPIENTS = [
  "first.last@mail.com"
]

var FILES_STABLE_DIRECTORY_PATH = "/stable"
var FILES_TEMPORARY_DIRECTORY_PATH = "/temporary"
var FILES = {
  "fileLink": "filePath"
}


function run() {
  for (var fileLink in FILES) {
    var filePath = FILES[fileLink]

    checkFile(fileLink, filePath)
  }
}

function checkFile(fileLink, filePath) {
  var filesApplication = Application("Finder")

  var stableFilePath = getFilePath(FILES_STABLE_DIRECTORY_PATH, filePath)
  var temporaryFilePath = getFilePath(FILES_TEMPORARY_DIRECTORY_PATH, filePath)

  downloadFile(fileLink, filePath)

  if (!filesApplication.exists(stableFilePath)) {
    filesApplication.move(temporaryFilePath, stableFilePath)
    return
  }

  var stableFileHash = calculateHash(stableFilePath)
  var temporaryFileHash = calculateHash(temporaryFilePath)

  if (stableFileHash != temporaryFileHash) {
    filesApplication.move(temporaryFilePath, stableFilePath)

    sendMail()
  }
}

function getFilePath(directoryPath, filePath) {
  return directoryPath + "/" + filePath
}

function downloadFile(fileLink, filePath) {
    runShell("curl" + " " + "--remote-name" + " " + fileLink + "--output" + " " + filePath)
}

function calculateHash(filePath) {
    return runShell("md5sum" + " " + filePath)
}

function runShell(shellScript) {
  return Application.currentApplication().doShellScript(shellScript)
}

function sendMail(fileLink, filePath) {
  var mailApplication = Application("Mail")

  var mail = mailApplication.OutgoingMessage().make()

  for (mailRecipient in MAIL_RECIPIENTS) {
    mail.toRecipients.push(Mail.Recipient({
      address: mailRecipient
    }))
  }

  mail.subject = "Watchdog: a file change was detected"

  mail.content += "Link to the file is" + " " + fileLink + "."
  mail.content += "Path to the file is" + " " + filePath + "."

  mail.send()
}
