$PBExportHeader$uo_mailslot.sru
forward
global type uo_mailslot from nonvisualobject
end type
end forward

global type uo_mailslot from nonvisualobject
end type
global uo_mailslot uo_mailslot

type prototypes

function ulong CreateMailslot(ref string lpName, ulong nMaxMessageSize, ulong lReadTimeout, ulong lpSecurityAttributes) library "Kernel32.dll" alias for "CreateMailslotW"
function boolean CloseHandle (ulong hObject) Library "kernel32.dll" 
function boolean GetMailslotInfo (ulong hMailslot, ref ulong lpMaxMessageSize, ref ulong lpNextSize, ref ulong lpMessageCount, ref ulong lpReadTimeout) library "kernel32.dll"
function boolean SetMailslotInfo (ulong hMailslot, ulong lReadTimeout) library "kernel32.dll"
function ulong CreateFile (string lpFileName, ulong dwDesiredAccess, ulong dwShareMode, ulong lpSecurityAttributes, ulong dwCreationDisposition, ulong dwFlagsAndAttributes, ulong hTemplateFile) library "kernel32.dll" alias for "CreateFileW"
function boolean ReadFile (ulong hFile, ref string lpBuffer, ulong nNumberOfBytesToRead, ref ulong lpNumberOfBytesRead, ulong lpOverlapped) library "kernel32.dll"
function boolean WriteFile (ulong hFile, ref string lpBuffer, ulong nNumberOfBytesToWrite, ref ulong lpNumberOfBytesWritten, ulong lpOverlapped) library "kernel32.dll"
function ulong GetLastError() library "kernel32.dll"

end prototypes

type variables

/* Mailslot paths : (http://msdn.microsoft.com/en-us/library/aa365147(VS.85).aspx)

\\.\mailslot\[path]name						Retrieves a client handle to a local mailslot.
\\computername\mailslot\[path]name		Retrieves a client handle to a remote mailslot.
\\domainname\mailslot\[path]name			Retrieves a client handle to all mailslots with the specified name in the specified domain.
\\*\mailslot\[path]name						Retrieves a client handle to all mailslots with the specified name in the system's primary domain.

Max size for a message :
- 64 kB for a local msg
- 423 bytes for a broadcast

*/

//return values
constant ulong INVALID_HANDLE_VALUE = -1
constant ulong MAILSLOT_NO_MESSAGE = -1

//timeout
constant ulong MAILSLOT_WAIT_FOREVER = -1

//msg sizes
constant ulong MSG_ANY_SIZE = 0
constant ulong MSG_MAX_SIZE = 4096 // suffira pour tout le monde ? API MAX = 65536 

//file access
constant ulong GENERIC_READ  = 2147483648 //0x80000000
constant ulong GENERIC_WRITE = 1073741824 //0x40000000

//file shares
constant ulong FILE_SHARE_READ = 1
constant ulong FILE_SHARE_WRITE = 2
constant ulong FILE_SHARE_DELETE = 4

//creation types
constant ulong CREATE_ALWAYS = 2
constant ulong CREATE_NEW = 1
constant ulong OPEN_ALWAYS = 4
constant ulong OPEN_EXISTING = 3
constant ulong TRUNCATE_EXISTING = 5

//file attributes
constant ulong FILE_ATTRIBUTE_NORMAL = 128
end variables

forward prototypes
public function boolean closemailslot (unsignedlong aul_slot)
public function boolean sendmail (string as_host, string as_path, string as_msg)
public function boolean hasmessage (unsignedlong aul_mslot)
public function boolean settimeout (unsignedlong aul_mslot, unsignedlong aul_timeout)
public function boolean getmailslotinfos (unsignedlong aul_mslot, ref unsignedlong aul_maxmsg, ref unsignedlong aul_nextmsg, ref unsignedlong aul_msgcount, ref unsignedlong aul_timeout)
public function ulong getmessagescount (unsignedlong aul_mslot)
public function string readmail (unsignedlong aul_mslot)
public function unsignedlong createmailslot (string as_path, unsignedlong aul_maxsize, unsignedlong aul_timeout)
public function boolean mailslotexists (string as_host, string as_path)
end prototypes

public function boolean closemailslot (unsignedlong aul_slot);// Close a mailslot

boolean lb_ret

lb_ret = closehandle( aul_slot )

return lb_ret

end function

public function boolean sendmail (string as_host, string as_path, string as_msg);// send a message to the mailslot

boolean lb_ret
ulong hFile, lul_written
string ls_path

if len(as_msg) > msg_max_size then return false

ls_path = "\\" + as_host + "\mailslot\" + as_path

hFile = CreateFile(ls_path, generic_write, file_share_read, 0, create_always /* CREATE_NEW */ , file_attribute_normal, 0)
if hfile <> INVALID_HANDLE_VALUE then
	lb_ret = WriteFile( hFile, as_msg, len(as_msg) * 2, lul_written, 0)
	Closehandle( hfile )
end if

return lb_ret

end function

public function boolean hasmessage (unsignedlong aul_mslot);// Tells if the given mailslot has waiting messages

ulong lul_count

lul_count = getmessagescount( aul_mslot ) 

return lul_count > 0


end function

public function boolean settimeout (unsignedlong aul_mslot, unsignedlong aul_timeout);// Modify the mailslot read timeout

boolean lb_ret

lb_ret = SetMailslotInfo( aul_mslot, aul_timeout)

return lb_ret

end function

public function boolean getmailslotinfos (unsignedlong aul_mslot, ref unsignedlong aul_maxmsg, ref unsignedlong aul_nextmsg, ref unsignedlong aul_msgcount, ref unsignedlong aul_timeout);// Get informations about the mailslot

boolean lb_ret

lb_ret = GetMailslotinfo( aul_mslot, aul_maxmsg, aul_nextmsg, aul_msgcount, aul_timeout)

return lb_ret

end function

public function ulong getmessagescount (unsignedlong aul_mslot);// Tells if the given mailslot has waiting messages

ulong lul_maxmsg, lul_nextmsg, lul_msgcount, lul_timeout

if getmailslotinfos( aul_mslot, lul_maxmsg, lul_nextmsg, lul_msgcount, lul_timeout) then
	return lul_msgcount
else
	return 0
end if


end function

public function string readmail (unsignedlong aul_mslot);// read the next waiting message

boolean lb_ret
ulong lul_maxmsg, lul_nextmsg, lul_msgcount, lul_timeout, lul_read
string ls_buf

if GetMailslotinfo( aul_mslot, lul_maxmsg, lul_nextmsg, lul_msgcount, lul_timeout) and lul_msgcount > 0 then
	ls_buf = space(lul_nextmsg / 2)
	lb_ret = readfile( aul_mslot, ls_buf, lul_nextmsg, lul_read, 0)
	
	if lb_ret and (lul_read = lul_nextmsg) then
		return ls_buf
	else
		ls_buf = "" //return null ??
	end if
else
	ls_buf = "" //return null ??
end if

return ls_buf

end function

public function unsignedlong createmailslot (string as_path, unsignedlong aul_maxsize, unsignedlong aul_timeout);// Create a mailslot


ulong lul_ret, lul_error
string ls_path

ls_path = "\\.\mailslot\" + as_path

lul_ret = createmailslot( ls_path, aul_maxsize, aul_timeout, 0)
if lul_ret = invalid_handle_value then
	lul_error = getlasterror( )
end if

return lul_ret

end function

public function boolean mailslotexists (string as_host, string as_path);// Test the existence of a mailslot

boolean lb_ret = false
ulong hFile
string ls_path

ls_path = "\\" + as_host + "\mailslot\" + as_path

hFile = CreateFile(ls_path, generic_read + generic_write, file_share_read, 0, open_existing, 0, 0)
if hfile <> INVALID_HANDLE_VALUE then
	lb_ret = true
	Closehandle( hfile )
end if

return lb_ret

end function

on uo_mailslot.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_mailslot.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

