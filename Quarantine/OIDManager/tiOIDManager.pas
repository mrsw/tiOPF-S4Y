unit tiOIDManager;

interface

uses
  Contnrs,
  tiBaseObject,
  tiObject,
  tiOID;



type
  TOIDClassMapping = class(TtiBaseObject)
  private
    FOIDClass: TtiOIDClass;
    FOIDGeneratorClass: TtiOIDGeneratorClass;
    FObjectClass: TtiObjectClass;
    FOIDGenerator: TtiOIDGenerator;
    function GetOIDGenerator: TtiOIDGenerator;
  public
    destructor Destroy; override;

    property ObjectClass: TtiObjectClass read FObjectClass write FObjectClass;
    property OIDClass : TtiOIDClass read FOIDClass write FOIDClass;
    property OIDGenerator: TtiOIDGenerator read GetOIDGenerator;
    property OIDGeneratorClass : TtiOIDGeneratorClass read FOIDGeneratorClass
      write FOIDGeneratorClass;
  end;

  TOIDManager = Class(TtiBaseObject)
  private
    FDefaultOIDClass: TtiOIDClass;
    FDefaultOIDGeneratorClass: TtiOIDGeneratorClass;
    FUseDefaultOID: boolean;
    FDefaultOIDGenerator: TtiOIDGenerator;
    procedure SetDefaultOIDGeneratorClass(const Value: TtiOIDGeneratorClass);
    function GetDefaultOIDGenerator: TtiOIDGenerator;
    procedure SetDefaultOIDClass(const Value: TtiOIDClass);
  protected
    FList : TObjectList;
    function FindByObjectClass(const pObjectClass: TtiObjectClass): TOIDClassMapping;
    function FindByObjectClassName(const AObjectClassName: string): TOIDClassMapping;
    procedure _RegisterMapping(const pObjectClass: TtiObjectClass;
      const pOIDGeneratorClass: TtiOIDGeneratorClass; const pOIDClass: TtiOIDClass);
  public
    constructor Create;
    destructor Destroy; override;

    function IsClassRegistered(const pObjectClass: TtiObjectClass): boolean; overload;
    function IsClassRegistered(const pObjectClassName: string): boolean; overload;
    function GetOIDClass(const pObjectClass: TtiObjectClass): TtiOIDClass; overload;
    function GetOIDClass(const pObjectClassName: string): TtiOIDClass; overload;
    function GetOIDGenerator(const pObjectClass: TtiObjectClass): TtiOIDGenerator; overload;
    function GetOIDGenerator(const AObjectClassName: string): TtiOIDGenerator; overload;
    procedure RegisterMapping(const pObjectClass: TtiObjectClass; const pOIDGeneratorClass: TtiOIDGeneratorClass;
      const pOIDClass: TtiOIDClass);

    property UseDefaultOID: boolean read FUseDefaultOID write FUseDefaultOID;
    property DefaultOIDClass: TtiOIDClass read FDefaultOIDClass write SetDefaultOIDClass;
    property DefaultOIDGeneratorClass: TtiOIDGeneratorClass read FDefaultOIDGeneratorClass write SetDefaultOIDGeneratorClass;
    property DefaultOIDGenerator: TtiOIDGenerator read GetDefaultOIDGenerator;
  End;


  function OIDManager: TOIDManager;


implementation


uses
  SysUtils,
  tiUtils,
  tiOPFManager,
  tiOIDGUID;



var
  OIDManagerInst: TOIDManager;



function OIDManager: TOIDManager;
begin
  if not Assigned(OIDManagerInst) then
    OIDManagerInst := TOIDManager.Create;

  result := OIDManagerInst;
end;




{ TOIDManager }

constructor TOIDManager.Create;
begin
  inherited;

  FList := TObjectList.Create(True);
  FList.OwnsObjects := true;

  FDefaultOIDClass := TOIDGUID;
  FDefaultOIDGeneratorClass := TtiOIDGeneratorGUID;
//  FDefaultOIDGenerator := FDefaultOIDGeneratorClass.Create;
//  FDefaultOIDGenerator.OIDClass := FDefaultOIDClass;
  FUseDefaultOID := true;
end;

destructor TOIDManager.Destroy;
begin
  FList.Free;
  FreeAndNil(FDefaultOIDGenerator);

  inherited;
end;

function TOIDManager.FindByObjectClass(
  const pObjectClass: TtiObjectClass): TOIDClassMapping;
var
  I: integer;
begin
  result := nil;

  if not Assigned(pObjectClass) then
    Exit;

  for I := 0 to FList.Count - 1 do
  {IFDEF COMPARECLASSINHERITED }
    if pObjectClass.InheritsFrom(TOIDClassMapping(FList.Items[I]).ObjectClass) then
  {ELSE}
    if TOIDClassMapping(FList.Items[I]).ObjectClass = pObjectClass then
  {ENDIF}
    begin
      result := TOIDClassMapping(FList.Items[I]);

      Exit; //==>
    end;
end;

function TOIDManager.FindByObjectClassName(
  const AObjectClassName: string): TOIDClassMapping;
var
  I : integer;
  OIDClassMapping: TOIDClassMapping;
begin
  result := nil;

  if AObjectClassName = EmptyStr then
    Exit;

  for I := 0 to FList.Count - 1 do
  begin
    OIDClassMapping := TOIDClassMapping(FList.Items[I]);

    if Assigned(OIDClassMapping) and
      ((OIDClassMapping.ObjectClass = nil) or
       (OIDClassMapping.ObjectClass.ClassName = AObjectClassName)) then
    begin
      result := OIDClassMapping;

      Exit; //==>
    end;
  end;
end;

function TOIDManager.GetOIDClass(
  const pObjectClass: TtiObjectClass): TtiOIDClass;
var
  lObjectClassMapping: TOIDClassMapping;
begin
  result := nil;

  if not Assigned(pObjectClass) then
    Exit;

  lObjectClassMapping := FindByObjectClass(pObjectClass);

  if lObjectClassMapping <> nil then
    result := lObjectClassMapping.OIDClass
  else if FUseDefaultOID then
  begin
    if not Assigned(FDefaultOIDClass) then
      raise Exception.Create('No default OIDClass defined!');

    result := FDefaultOIDClass;
  end;
end;

function TOIDManager.GetOIDGenerator(
  const pObjectClass: TtiObjectClass): TtiOIDGenerator;
var
  lObjectClassMapping: TOIDClassMapping;
begin
  result := nil;

  lObjectClassMapping := FindByObjectClass(pObjectClass);

  if (lObjectClassMapping = nil) and not FUseDefaultOID then
    Exit; //-->

  if lObjectClassMapping <> nil then
    result := lObjectClassMapping.OIDGenerator
  else if FUseDefaultOID then
    result := DefaultOIDGenerator;
end;

procedure TOIDManager.RegisterMapping(
  const pObjectClass: TtiObjectClass; const pOIDGeneratorClass: TtiOIDGeneratorClass; const pOIDClass: TtiOIDClass);
begin
  if not Assigned(pObjectClass) then
    raise Exception.Create('You need to specify a object class!');

  _RegisterMapping(pObjectClass, pOIDGeneratorClass, pOIDClass);
end;

//procedure TOIDManager.SetDefaultOIDClass(const Value: TtiOIDClass);
//var
//  lDefaultOIDObjectClassMapping: TOIDClassMapping;
//begin
//  lDefaultOIDObjectClassMapping := FindByObjectClass(nil);
//
//  if Assigned(lDefaultOIDObjectClassMapping) then
//  begin
//    lDefaultOIDObjectClassMapping := TOIDClassMapping(
//      FList.Extract(lDefaultOIDObjectClassMapping));
//
//    _RegisterMapping(nil,
//      lDefaultOIDObjectClassMapping.OIDGeneratorClass,
//      Value);
//
//    lDefaultOIDObjectClassMapping.Free;
//  end
//  else
//  begin
//    _RegisterMapping(nil, nil, Value);
//  end;
//end;

procedure TOIDManager.SetDefaultOIDClass(const Value: TtiOIDClass);
begin
  Assert(Value <> nil, 'DefaultOIDClass cannot be nil.');

  FDefaultOIDClass := Value;
end;

procedure TOIDManager.SetDefaultOIDGeneratorClass(
  const Value: TtiOIDGeneratorClass);
//var
//  lDefaultOIDObjectClassMapping: TOIDClassMapping;
begin
//  lDefaultOIDObjectClassMapping := FindByObjectClass(nil);
//
//  if Assigned(lDefaultOIDObjectClassMapping) then
//  begin
//    lDefaultOIDObjectClassMapping := TOIDClassMapping(
//      FList.Extract(lDefaultOIDObjectClassMapping));
//
//    _RegisterMapping(nil,
//      Value,
//      lDefaultOIDObjectClassMapping.OIDClass);
//
//    lDefaultOIDObjectClassMapping.Free;
//  end
//  else
//  begin
//    _RegisterMapping(nil, Value, nil);
//  end;
  Assert(Value <> nil, 'DefaultOIDGeneratorClass cannot be nil.');

  FreeAndNil(FDefaultOIDGenerator);

  FDefaultOIDGeneratorClass := Value;
end;

procedure TOIDManager._RegisterMapping(
  const pObjectClass: TtiObjectClass; const pOIDGeneratorClass: TtiOIDGeneratorClass;
  const pOIDClass: TtiOIDClass);
var
  lObjectClassMapping : TOIDClassMapping;
begin
  if FindByObjectClass(pObjectClass) <> nil then
    raise Exception.Create(
      'Attempt to register duplicated OID mapping for class: ' +
      pObjectClass.ClassName + Cr(2) +
      'An object class can only be mapped to one pair of OIDClass:OIDGenerator');

  lObjectClassMapping := TOIDClassMapping.Create;
  lObjectClassMapping.ObjectClass := pObjectClass;
  lObjectClassMapping.OIDClass := pOIDClass;
  lObjectClassMapping.OIDGeneratorClass := pOIDGeneratorClass;

  FList.Add(lObjectClassMapping);
end;

function TOIDManager.GetDefaultOIDGenerator: TtiOIDGenerator;
begin
  if not Assigned(FDefaultOIDGenerator) then
    FDefaultOIDGenerator := FDefaultOIDGeneratorClass.Create;

  result := FDefaultOIDGenerator;
end;

function TOIDManager.GetOIDClass(
  const pObjectClassName: string): TtiOIDClass;
var
  lObjectClassMapping: TOIDClassMapping;
begin
  result := nil;

  if pObjectClassName = EmptyStr then
    Exit;

  lObjectClassMapping := FindByObjectClassName(pObjectClassName);

  if lObjectClassMapping <> nil then
    result := lObjectClassMapping.OIDClass
  else if FUseDefaultOID then
  begin
    if not Assigned(FDefaultOIDClass) then
      raise Exception.Create('No default OIDClass defined!');

    result := FDefaultOIDClass;
  end;
end;

function TOIDManager.GetOIDGenerator(
  const AObjectClassName: string): TtiOIDGenerator;
var
  lObjectClassMapping,
  lDefaultClassMapping: TOIDClassMapping;
begin
  result := nil;

  lObjectClassMapping := FindByObjectClassName(AObjectClassName);

  if (lObjectClassMapping = nil) and not FUseDefaultOID then
    Exit; //-->

  if lObjectClassMapping <> nil then
    result := lObjectClassMapping.OIDGenerator
  else if FUseDefaultOID then
    result := DefaultOIDGenerator;
end;

function TOIDManager.IsClassRegistered(
  const pObjectClass: TtiObjectClass): boolean;
begin
  Assert(pObjectClass <> nil, 'TOIDManager.IsClassRegistered: pObjectClass not assigned.');

  result := false;

  result := Assigned(FindByObjectClass(pObjectClass));
end;

function TOIDManager.IsClassRegistered(const pObjectClassName: string): boolean;
begin
  Assert(pObjectClassName <> EmptyStr, 'TOIDManager.IsClassRegistered: pObjectClassName is empty.');

  result := false;

  result := Assigned(FindByObjectClassName(pObjectClassName));
end;

{ TOIDClassMapping }

destructor TOIDClassMapping.Destroy;
begin
  if Assigned(FOIDGenerator) then
    FOIDGenerator.Free;

  inherited;
end;

function TOIDClassMapping.GetOIDGenerator: TtiOIDGenerator;
begin
  result := nil;

  if FOIDGeneratorClass = nil then
    Exit; //-->

  if not Assigned(FOIDGenerator) then
    FOIDGenerator := FOIDGeneratorClass.Create;

  result := FOIDGenerator;
end;


initialization

finalization
  if Assigned(OIDManagerInst) then
    FreeAndNil(OIDManagerInst);

end.
