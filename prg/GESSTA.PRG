LOCAL lcOldError
lcOldError = ON('ERROR')
ON ERROR *
=SYS(1037)
ON ERROR &lcOldError
