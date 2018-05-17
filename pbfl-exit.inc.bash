#!/bin/bash -p
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#########################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"	#
# SCRIPT_TITLE="Exit Codes Script"						#
# MAINTAINER="Mattijs Snepvangers"						#
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"				#
# VERSION_MAJOR=0										#
# VERSION_MINOR=0										#
# VERSION_PATCH=0										#
# VERSION_STATE="PRE-ALPHA"								#
# VERSION_BUILD=20180425								#
# LICENSE="MIT"											#
#########################################################


### EXITCODES HOWTO
howto=<<-EOF
		This file attempts to categorize possible error exit statuses for system program.

		Error numbers begin at EX__BASE to reduce the possibility of clashing with other exit statuses that random programs may already return.
		The meaning of the codes is approximately as follows:

		EX_USAGE		->	The command was used incorrectly, e.g., with the wrong number of arguments, a bad flag, a bad syntax in a parameter, or whatever.
		EX_DATAERR		->	The input data was incorrect in some way. This should only be used for user\'s data & not system files.
		EX_NOINPUT		->	An input file (not a system file) did not exist or was not readable. This could also include errors like "No message" to a mailer (if it cared to catch it).
		EX_NOUSER		->	The user specified does not exist. This might be used for mail addresses or remote logins.
		EX_NOHOST		->	The host specified did not exist. This is used in mail addresses or network requests.
		EX_UNAVAILABLE	->	A service is unavailable. This can occur if a support program or file does not exist. This can also be used as a catchall message when something you wanted to do doesn\'t work, but you don\'t know why.
		EX_SOFTWARE			->	An internal software error has been detected. This should be limited to non-operating system related errors as possible.
		EX_OSERR		->	An operating system error has been detected. It includes things like getuid returning a user that does not exist in the passwd file.
		EX_OSFILE		->	Some system file (e.g., /etc/passwd, /etc/utmp, etc.) does not exist, cannot be opened, or has some sort of error (e.g., syntax error).
		EX_CANTCREAT	->	A (user specified) output dir or file cannot be created.
		EX_IOERR		->	An error occurred while doing I/O on some file.
		EX_TEMPFAIL		->	temporary failure, indicating something that is not really an error. In sendmail, this means that a mailer (e.g.) could not create a connection, and the request should be reattempted later.
		EX_PROTOCOL		->	the remote system returned something that was "not possible" during a protocol exchange.
		EX_NOPERM		->	You did not have sufficient permission to perform the operation. This is not intended for file system problems, which should use NOINPUT or CANTCREAT, but rather for higher level permissions.
EOF

declare -gr EX_OK=0				#	successful termination
### reserved exit codes (source: advanced bash scripting guide)
declare -gr EX_GEN_ERR=1		#	generic error code
declare -gr EX_MISUSE=2			#	Misuse of shell builtins; Missing keyword or command, or permission problem (and diff return code on a failed binary file comparison).
####

### defined by apple for C code ###
declare -gr EX_USAGE=64			#	command line usage error 
declare -gr EX_DATAERR=65		#	data format error 
declare -gr EX_NOINPUT=66		#	cannot open input 
declare -gr EX_NOUSER=67		#	addressee unknown 
declare -gr EX_NOHOST=68		#	host name unknown 
declare -gr EX_UNAVAILABLE=69	#	service unavailable 
declare -gr EX_SOFTWARE=70		#	internal software error 
declare -gr EX_OSERR=71			#	system error (e.g., can't fork) 
declare -gr EX_OSFILE=72		#	critical OS file missing 
declare -gr EX_CANTCREAT=73		#	can't create (user) output file 
declare -gr EX_IOERR=74			#	input/output error 
declare -gr EX_TEMPFAIL=75		#	temp failure; user is invited to retry 
declare -gr EX_PROTOCOL=76		#	remote error in protocol 
declare -gr EX_NOPERM=77		#	permission denied 
declare -gr EX_CONFIG=78		#	configuration error 
### end defined by apple ###

### thought up myself ###
declare -gr EX_USER=80			#	Something went wrong during user interaction, most likely unexpected input from user.
declare -gr EX_FORK=81			#	Cannot Fork
declare -gr EX_PIPE=82			#	Cannot create pipe
declare -gr EX_DNS=83			#	DNS error, either Host or Domain does not exist or DNS server unreachable.
declare -gr EX_FILE_WRITE=84	#	File writing error so either the permissons are off or the fs is readonly
declare -gr EX_FILE_READ=85		#	File reading error so the permissons must be wrong
declare -gr EX_FILE_NOTEXIST=86	#	File doen not exist
declare -gr EX_DIR_WRITE=87		#	Cannot write into DIR; directory permissions are wrong or fs is mounted readonly
declare -gr EX_DIR_READ=88		#	Dir reading error so the permissons must be wrong
declare -gr EX_DIR_NOTEXIST=89	#	Dir does not exist
declare -gr EX_HOST_TIMEOUT=90	#	Timeout on connection
### end thought up myself

### reserved exit codes (source: advanced bash scripting guide)
declare -gr EX_EXEC=126			#	Command invoked cannot execute; permission problem or command is not an executable
declare -gr EX_NOTFOUND=127		#	command not found; possible problem with $PATH or a typo
declare -gr EX_EXIT=128			#	Invalid argument to exit; exit takes only integer args in the range 0 - 255
declare -gr EX_ERR_SIG9=137		#	Fatal error signal 9; kill -9 $PPID $? returns 137 (128 + 9)
declare -gr EX_ERR_SIG15=143	#	Fatal error signal 15; kill -15 $PPID $? returns 143 (128 + 15)
declare -gr EX_CTRL_C=130		#	Script terminated by Control-C; Control-C is fatal error signal 2, (130 = 128 + 2, see above)
if [[EXIT_CODE>255]] ; then 	#	Exit status out of range									exit -1	exit takes only integer args in the range 0 - 255