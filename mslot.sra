$PBExportHeader$mslot.sra
$PBExportComments$Generated Application Object
forward
global type mslot from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type mslot from application
string appname = "mslot"
end type
global mslot mslot

on mslot.create
appname="mslot"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on mslot.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
open(w_main)

end event

