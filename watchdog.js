// Edit the section below

MAIL_RECIPIENTS = [
  "first.last@mail.com"
]

FILES = {
  "link": "path"
}

FILES_STABLE_DIRECTORY_PATH = "/stable"
FILES_TEMPORARY_DIRECTORY_PATH = "/temporary"

// Edit the section above


function run() {
  for (fileLink in FILES) {
    filePath = FILES[fileLink]

    checkFile(fileLink, filePath)
  }
}

function checkFile(fileLink, filePath) {
  stableFilePath = getFilePath(FILES_STABLE_DIRECTORY_PATH, filePath)
  temporaryFilePath = getFilePath(FILES_TEMPORARY_DIRECTORY_PATH, filePath)

  downloadFile(fileLink, temporaryFilePath)

  filesApplication = Application("Finder")

  if (!filesApplication.exists(Path(stableFilePath))) {
    filesApplication.move(Path(temporaryFilePath), {
      to: Path(stableFilePath),
      replacing: true
    })

    return
  }

  stableFileHash = calculateHash(stableFilePath)
  temporaryFileHash = calculateHash(temporaryFilePath)

  if (stableFileHash != temporaryFileHash) {
    filesApplication.move(Path(temporaryFilePath), {
      to: Path(stableFilePath),
      replacing: true
    })

    sendMail(fileLink, stableFilePath)
  }
}

function getFilePath(directoryPath, filePath) {
  return directoryPath + "/" + filePath
}

function downloadFile(fileLink, filePath) {
    runShell("curl" + " " + fileLink + " " + "--output" + " " + filePath)
}

function calculateHash(filePath) {
    return runShell("md5" + " " + "-q" + " " + filePath)
}

function runShell(shellScript) {
  application = Application.currentApplication()
  application.includeStandardAdditions = true

  return application.doShellScript(shellScript)
}

function sendMail(fileLink, filePath) {
  mailApplication = Application("Mail")

  mail = mailApplication.OutgoingMessage().make()

  for (mailRecipient of MAIL_RECIPIENTS) {
    mail.toRecipients.push(mailApplication.Recipient({
      address: mailRecipient
    }))
  }

  mail.subject = "Watchdog: a file change was detected"
  mail.content = "Link to the file is" + " " + fileLink + "."

  mail.send()
}
