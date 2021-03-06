{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  The contents of this file are subject to the Mozilla Public
  License Version 1.1 (the "License"); you may not use this file
  except in compliance with the License. You may obtain a copy of
  the License at http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS
  IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
  implied. See the License for the specific language governing
  rights and limitations under the License.

  Originally developed and released by Peter Hinrichsen, TechInsite Pty. Ltd.
  as the tiOPF (TechInsite Object Persistence Framework)

    23 Victoria Pde, Collingwood, Melbourne, Victoria 3066 Australia
    PO Box 429, Abbotsford, Melbourne, Victoria 3067 Australia
    Phone: +61 3 9419 6456 Fax:   +61 3 9419 1682
    Latest source:   www.techinsite.com.au/tiOPF/Download.htm
    Documentation:   www.techinsite.com.au/tiOPF/Doc/
    Support:         www.techinsite.com.au/tiOPF/MailingList.htm

  Please submit changes to tiOPF@techinsite.com.au

  Revision history:

  Purpose:

  ToDo:

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{$I tiDefines.inc}

unit FEdit_EAddrs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FtiPerEditDialog, ActnList, StdCtrls, Buttons, ExtCtrls, tiPerAwareCtrls,
  tiVisitorDB, tiReadOnly, tiFocusPanel;

type
  TFormEdit_EAdrs = class(TFormTIPerEditDialog)
    paeAdrsType: TtiPerAwareComboBoxDynamic;
    paeEAdrs: TtiPerAwareEdit;
  private
  protected
    procedure SetData(const Value: TtiObject); override;
    function  FormIsValid: boolean; override;
  public
    { Public declarations }
  end;

implementation
uses
  Adrs_BOM
 ;
  
{$R *.DFM}

{ TFormTIPerEditDialog2 }
//* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//*
//* TFormEdit_EAdrs
//*
//* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
function TFormEdit_EAdrs.FormIsValid: boolean;
begin
  result:=
    (paeAdrsType.Value <> nil) and
    (paeEAdrs.Value    <> '');
end;

procedure TFormEdit_EAdrs.SetData(const Value: TtiObject);
begin
  inherited SetData(Value);
  paeAdrsType.List:= gAdrsBook.AdrsTypes.FindByListName('EAdrs').List;
  paeAdrsType.LinkToData(DataBuffer, 'AdrsType');
  paeEAdrs.LinkToData(DataBuffer, 'Text');
end;

end.
