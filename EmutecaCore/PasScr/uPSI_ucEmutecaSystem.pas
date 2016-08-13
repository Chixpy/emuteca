unit uPSI_ucEmutecaSystem;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_ucEmutecaSystem = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cEmutecaSystem(CL: TPSPascalCompiler);
procedure SIRegister_ucEmutecaSystem(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ucEmutecaSystem_Routines(S: TPSExec);
procedure RIRegister_cEmutecaSystem(CL: TPSRuntimeClassImporter);
procedure RIRegister_ucEmutecaSystem(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IniFiles
  ,LazFileUtils
  ,LazUTF8
  ,fgl
  ,uCHXStrUtils
  ,uEmutecaCommon
  ,uaEmutecaStorable
  ,ucEmutecaSystem
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ucEmutecaSystem]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cEmutecaSystem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'caEmutecaStorableIni', 'cEmutecaSystem') do
  with CL.AddClassN(CL.FindClass('caEmutecaStorableIni'),'cEmutecaSystem') do
  begin
    RegisterProperty('ID', 'string', iptrw);
    RegisterProperty('Enabled', 'boolean', iptrw);
    RegisterProperty('Company', 'string', iptrw);
    RegisterProperty('Model', 'string', iptrw);
    RegisterProperty('Extensions', 'TStringList', iptr);
    RegisterProperty('ExtractAll', 'boolean', iptrw);
    RegisterProperty('GameKey', 'TEmutecaFileKey', iptrw);
    RegisterProperty('BaseFolder', 'string', iptrw);
    RegisterProperty('TempFolder', 'string', iptrw);
    RegisterProperty('MainEmulator', 'string', iptrw);
    RegisterProperty('OtherEmulators', 'TStringList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ucEmutecaSystem(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('krsIniKeyEnabled','String').SetString( 'Enabled');
 CL.AddConstantN('krsIniKeyCompany','String').SetString( 'Company');
 CL.AddConstantN('krsIniKeyModel','String').SetString( 'Model');
 CL.AddConstantN('krsIniKeyExtensions','String').SetString( 'Extensions');
 CL.AddConstantN('krsIniKeyBaseFolder','String').SetString( 'BaseFolder');
 CL.AddConstantN('krsIniKeyTempFolder','String').SetString( 'TempFolder');
 CL.AddConstantN('krsIniKeyGamesKey','String').SetString( 'GamesKey');
 CL.AddConstantN('krsIniKeyExtractAll','String').SetString( 'ExtractAll');
 CL.AddConstantN('krsIniKeyMainEmulator','String').SetString( 'MainEmulator');
 CL.AddConstantN('krsIniKeyOtherEmulators','String').SetString( 'OtherEmulators');
  CL.AddTypeS('TEmutecaFileKey', '( TEFKSHA1, TEFKCRC32, TEFKFileName, TEFKCust'
   +'om )');
  SIRegister_cEmutecaSystem(CL);
 CL.AddDelphiFunction('Function EmutecaFileKey2Str( aEFK : TEmutecaFileKey) : string');
 CL.AddDelphiFunction('Function Str2EmutecaFileKey( aString : string) : TEmutecaFileKey');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemOtherEmulators_R(Self: cEmutecaSystem; var T: TStringList);
begin T := Self.OtherEmulators; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemMainEmulator_W(Self: cEmutecaSystem; const T: string);
begin Self.MainEmulator := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemMainEmulator_R(Self: cEmutecaSystem; var T: string);
begin T := Self.MainEmulator; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemTempFolder_W(Self: cEmutecaSystem; const T: string);
begin Self.TempFolder := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemTempFolder_R(Self: cEmutecaSystem; var T: string);
begin T := Self.TempFolder; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemBaseFolder_W(Self: cEmutecaSystem; const T: string);
begin Self.BaseFolder := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemBaseFolder_R(Self: cEmutecaSystem; var T: string);
begin T := Self.BaseFolder; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemGameKey_W(Self: cEmutecaSystem; const T: TEmutecaFileKey);
begin Self.GameKey := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemGameKey_R(Self: cEmutecaSystem; var T: TEmutecaFileKey);
begin T := Self.GameKey; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemExtractAll_W(Self: cEmutecaSystem; const T: boolean);
begin Self.ExtractAll := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemExtractAll_R(Self: cEmutecaSystem; var T: boolean);
begin T := Self.ExtractAll; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemExtensions_R(Self: cEmutecaSystem; var T: TStringList);
begin T := Self.Extensions; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemModel_W(Self: cEmutecaSystem; const T: string);
begin Self.Model := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemModel_R(Self: cEmutecaSystem; var T: string);
begin T := Self.Model; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemCompany_W(Self: cEmutecaSystem; const T: string);
begin Self.Company := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemCompany_R(Self: cEmutecaSystem; var T: string);
begin T := Self.Company; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemEnabled_W(Self: cEmutecaSystem; const T: boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemEnabled_R(Self: cEmutecaSystem; var T: boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemID_W(Self: cEmutecaSystem; const T: string);
begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaSystemID_R(Self: cEmutecaSystem; var T: string);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ucEmutecaSystem_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EmutecaFileKey2Str, 'EmutecaFileKey2Str', cdRegister);
 S.RegisterDelphiFunction(@Str2EmutecaFileKey, 'Str2EmutecaFileKey', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cEmutecaSystem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(cEmutecaSystem) do
  begin
    RegisterPropertyHelper(@cEmutecaSystemID_R,@cEmutecaSystemID_W,'ID');
    RegisterPropertyHelper(@cEmutecaSystemEnabled_R,@cEmutecaSystemEnabled_W,'Enabled');
    RegisterPropertyHelper(@cEmutecaSystemCompany_R,@cEmutecaSystemCompany_W,'Company');
    RegisterPropertyHelper(@cEmutecaSystemModel_R,@cEmutecaSystemModel_W,'Model');
    RegisterPropertyHelper(@cEmutecaSystemExtensions_R,nil,'Extensions');
    RegisterPropertyHelper(@cEmutecaSystemExtractAll_R,@cEmutecaSystemExtractAll_W,'ExtractAll');
    RegisterPropertyHelper(@cEmutecaSystemGameKey_R,@cEmutecaSystemGameKey_W,'GameKey');
    RegisterPropertyHelper(@cEmutecaSystemBaseFolder_R,@cEmutecaSystemBaseFolder_W,'BaseFolder');
    RegisterPropertyHelper(@cEmutecaSystemTempFolder_R,@cEmutecaSystemTempFolder_W,'TempFolder');
    RegisterPropertyHelper(@cEmutecaSystemMainEmulator_R,@cEmutecaSystemMainEmulator_W,'MainEmulator');
    RegisterPropertyHelper(@cEmutecaSystemOtherEmulators_R,nil,'OtherEmulators');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ucEmutecaSystem(CL: TPSRuntimeClassImporter);
begin
  RIRegister_cEmutecaSystem(CL);
end;

 
 
{ TPSImport_ucEmutecaSystem }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ucEmutecaSystem.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ucEmutecaSystem(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ucEmutecaSystem.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ucEmutecaSystem(ri);
  RIRegister_ucEmutecaSystem_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.