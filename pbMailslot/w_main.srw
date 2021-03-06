$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cb_test from commandbutton within w_main
end type
type cb_close from commandbutton within w_main
end type
type cb_open from commandbutton within w_main
end type
type st_path from statictext within w_main
end type
type st_waiting from statictext within w_main
end type
type cb_recv from commandbutton within w_main
end type
type cb_send from commandbutton within w_main
end type
type mle_input from multilineedit within w_main
end type
type mle_output from multilineedit within w_main
end type
type sle_slot from singlelineedit within w_main
end type
type sle_host from singlelineedit within w_main
end type
end forward

global type w_main from window
integer width = 2514
integer height = 1176
boolean titlebar = true
string title = "PB Mailslot test"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_test cb_test
cb_close cb_close
cb_open cb_open
st_path st_path
st_waiting st_waiting
cb_recv cb_recv
cb_send cb_send
mle_input mle_input
mle_output mle_output
sle_slot sle_slot
sle_host sle_host
end type
global w_main w_main

type variables

ulong iul_hslot = -1
uo_mailslot iuo_mslot

end variables

forward prototypes
public subroutine update_path ()
end prototypes

public subroutine update_path ();
string ls_path

ls_path = "\\"
ls_path += sle_host.text
ls_path += "\mailslot\"
ls_path += sle_slot.text

st_path.text = ls_path

end subroutine

on w_main.create
this.cb_test=create cb_test
this.cb_close=create cb_close
this.cb_open=create cb_open
this.st_path=create st_path
this.st_waiting=create st_waiting
this.cb_recv=create cb_recv
this.cb_send=create cb_send
this.mle_input=create mle_input
this.mle_output=create mle_output
this.sle_slot=create sle_slot
this.sle_host=create sle_host
this.Control[]={this.cb_test,&
this.cb_close,&
this.cb_open,&
this.st_path,&
this.st_waiting,&
this.cb_recv,&
this.cb_send,&
this.mle_input,&
this.mle_output,&
this.sle_slot,&
this.sle_host}
end on

on w_main.destroy
destroy(this.cb_test)
destroy(this.cb_close)
destroy(this.cb_open)
destroy(this.st_path)
destroy(this.st_waiting)
destroy(this.cb_recv)
destroy(this.cb_send)
destroy(this.mle_input)
destroy(this.mle_output)
destroy(this.sle_slot)
destroy(this.sle_host)
end on

event open;
iuo_mslot = create uo_mailslot

update_path( )

end event

event close;
if iul_hslot <> -1 then iuo_mslot.closemailslot( iul_hslot )
if isvalid(iuo_mslot) then destroy iuo_mslot

end event

event timer;
ulong lul_count

if iul_hslot <> -1 then
	lul_count = iuo_mslot.getmessagescount(iul_hslot)
	st_waiting.text = "Mode serveur, " + string(lul_count) + " msg(s)"
end if

end event

type cb_test from commandbutton within w_main
integer x = 1061
integer y = 168
integer width = 247
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "exists ?"
end type

event clicked;
if iuo_mslot.mailslotexists( sle_host.text, sle_slot.text) then
	messagebox("Mailslot existence test", "YES : " + st_path.text + " does exist.")
else
	messagebox("Mailslot existence test", "NO : " + st_path.text + " does NOT exist.")
end if

end event

type cb_close from commandbutton within w_main
integer x = 1317
integer y = 64
integer width = 224
integer height = 80
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "close"
end type

event clicked;boolean lb_ret
if iul_hslot <> -1 then 
	lb_ret = iuo_mslot.closemailslot( iul_hslot )
	if lb_ret then
		messagebox("Mailslot close", "close ok")
		iul_hslot = -1
		cb_close.enabled = false
		//cb_send.enabled = false
		cb_recv.enabled = false
		cb_open.enabled = true
		timer(0)
		st_waiting.visible = false
	else
		messagebox("Mailslot close", "close failed")
	end if
end if

end event

type cb_open from commandbutton within w_main
integer x = 1061
integer y = 64
integer width = 224
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "create"
end type

event clicked;
ulong lul_hmslot

if not iuo_mslot.mailslotexists( ".", sle_slot.text ) then
	lul_hmslot = iuo_mslot.createmailslot( sle_slot.text, 256, iuo_mslot.mailslot_wait_forever)
	
	if lul_hmslot <> iuo_mslot.invalid_handle_value then
		iul_hslot = lul_hmslot
		messagebox("Mailslot creation", "creation ok")
		cb_close.enabled = true
		//cb_send.enabled = true
		cb_recv.enabled = true
		cb_open.enabled = false
		timer(1)
		st_waiting.visible = true
	else
		messagebox("Mailslot creation", "creation failed")
	end if
else
	messagebox("Mailslot creation problem", "Mailslot already exists")
end if
end event

type st_path from statictext within w_main
integer x = 197
integer y = 288
integer width = 1595
integer height = 88
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "\\"
boolean focusrectangle = false
end type

type st_waiting from statictext within w_main
boolean visible = false
integer x = 1646
integer y = 32
integer width = 805
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_recv from commandbutton within w_main
integer x = 1888
integer y = 748
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "receive"
end type

event clicked;
string ls_msg
if iul_hslot <> -1 then
	ls_msg = iuo_mslot.readmail( iul_hslot )
	mle_input.text = ls_msg
end if


end event

type cb_send from commandbutton within w_main
integer x = 1888
integer y = 412
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "send"
end type

event clicked;
//if iul_hslot <> -1 then
	iuo_mslot.sendmail( sle_host.text, sle_slot.text, mle_output.text )
//end if

end event

type mle_input from multilineedit within w_main
integer x = 187
integer y = 736
integer width = 1618
integer height = 316
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type mle_output from multilineedit within w_main
integer x = 187
integer y = 396
integer width = 1618
integer height = 316
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "some text"
borderstyle borderstyle = stylelowered!
end type

type sle_slot from singlelineedit within w_main
integer x = 187
integer y = 176
integer width = 837
integer height = 72
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "slotpath"
borderstyle borderstyle = stylelowered!
end type

event modified;
update_path( )

end event

type sle_host from singlelineedit within w_main
integer x = 187
integer y = 72
integer width = 837
integer height = 72
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "."
borderstyle borderstyle = stylelowered!
end type

event modified;
update_path( )

end event

