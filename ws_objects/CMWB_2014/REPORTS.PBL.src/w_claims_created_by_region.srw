﻿$PBExportHeader$w_claims_created_by_region.srw
forward
global type w_claims_created_by_region from w_a_report
end type
type cb_ok from commandbutton within w_claims_created_by_region
end type
type gb_1 from groupbox within w_claims_created_by_region
end type
type dw_enter_date_range from u_dw_online within w_claims_created_by_region
end type
end forward

global type w_claims_created_by_region from w_a_report
boolean TitleBar=true
string Title="Claims Created by Region"
cb_ok cb_ok
gb_1 gb_1
dw_enter_date_range dw_enter_date_range
end type
global w_claims_created_by_region w_claims_created_by_region

on open;call w_a_report::open;/*	Database connections and initialization.
*/
	dw_report.SetTransObject (SQLCA)

	dw_enter_date_range.InsertRow(0)
	dw_enter_date_range.SetRow(1)
	dw_enter_date_range.SetColumn("from_date")





end on

on w_claims_created_by_region.create
int iCurrent
call w_a_report::create
this.cb_ok=create cb_ok
this.gb_1=create gb_1
this.dw_enter_date_range=create dw_enter_date_range
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=cb_ok
this.Control[iCurrent+2]=gb_1
this.Control[iCurrent+3]=dw_enter_date_range
end on

on w_claims_created_by_region.destroy
call w_a_report::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_ok)
destroy(this.gb_1)
destroy(this.dw_enter_date_range)
end on

type dw_report from w_a_report`dw_report within w_claims_created_by_region
int Y=493
int TabOrder=40
string DataObject="d_claims_created_by_region"
boolean HScrollBar=true
end type

type cb_ok from commandbutton within w_claims_created_by_region
int X=2154
int Y=213
int Width=389
int Height=109
int TabOrder=30
boolean BringToTop=true
string Text="&OK"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;/*	Variables and initialization.
*/
	LONG 		ll_numrows
	DATETIME	adt_from_date, adt_to_date, adt_today

	dw_enter_date_range.AcceptText()

/*	Validate the dates and set the to date to midnight of the next day to ensure that all transactions
	from the requested day are included.
*/

	adt_from_date = dw_enter_date_range.GetItemDateTime(1,"from_date")
	adt_to_date = DateTime(RelativeDate(Date(dw_enter_date_range.GetItemDateTime(1,"to_date")),1))

	IF IsNull(adt_from_date) or &
		IsNull(adt_to_date) THEN
		MessageBox("Validation Error","Both the from and to dates must have a value.",Exclamation!)
		Return
	END IF

	IF adt_from_date < DateTime(Date(1900,01,01)) OR &
		adt_to_date < DateTime(Date(1900,01,01)) THEN
		MessageBox("Validation Error","Dates cannot be earlier than 1900-01-01!",Exclamation!)
		Return
	END IF

	IF adt_from_date >= adt_to_date then
		MessageBox("Validation Error","The to date must be later than the from date.",Exclamation!)
		Return
	END IF

	adt_today = f_server_datetime()
	adt_today = DateTime(RelativeDate(Date(adt_today), 1))

	If adt_to_date >= adt_today THEN
		MessageBox("Validation Error","The to date must be earlier than the current date",Exclamation!)
		Return
	END IF
	
/*	Retrieve the report.
*/
	ll_numrows = dw_report.Retrieve(adt_from_date,adt_to_date)
	SQLCA.nf_handle_error("w_claims_adjuducated","dw_report","cb_ok")
	IF ll_numrows <= 0 then
		MessageBox("Claims Adjudication Report","No data found to satisfy request")
	END IF

end event

type gb_1 from groupbox within w_claims_created_by_region
int X=51
int Y=85
int Width=1518
int Height=277
int TabOrder=10
string Text="Processing Period"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_enter_date_range from u_dw_online within w_claims_created_by_region
int X=106
int Y=189
int Width=1386
int Height=93
int TabOrder=20
boolean BringToTop=true
string DataObject="d_enter_date_range"
boolean Border=false
boolean LiveScroll=true
end type

