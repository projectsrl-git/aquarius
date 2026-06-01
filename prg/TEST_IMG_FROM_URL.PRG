SET STEP ON
DECLARE LONG URLDownloadToFile IN URLMON.DLL LONG, STRING, STRING, LONG, LONG
cURL = "http://allimg.activebridge.net/CAL/1031YYYY_B.JPG"
cFileName = "c:\mypicture.jpg"
nResult = URLDownloadToFile(0, cURL, cFileName, 0, 0)
