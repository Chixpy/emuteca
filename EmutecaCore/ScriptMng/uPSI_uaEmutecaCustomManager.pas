unit uPSI_uaEmutecaCustomManager;
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
  TPSImport_uaEmutecaCustomManager = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_caEmutecaCustomManager(CL: TPSPascalCompiler);
procedure SIRegister_uaEmutecaCustomManager(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_caEmutecaCustomManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_uaEmutecaCustomManager(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IniFiles
  ,LazFileUtils
  ,LazUTF8
  ,uaCHXStorable
  ,uEmutecaCommon
  ,uaEmutecaCustomManager
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uaEmutecaCustomManager]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_caEmutecaCustomManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'caCHXStorableTxt', 'caEmutecaCustomManager') do
  with CL.AddClassN(CL.FindClass('caCHXStorableTxt'),'caEmutecaCustomManager') do
  begin
    RegisterProperty('ProgressCallBack', 'TEmutecaProgressCallBack', iptrw);
    RegisterMethod('Procedure ImportFromFileIni( aFilename : string)');
    RegisterMethod('Procedure ImportFromIni( aIniFile : TIniFile)');
    RegisterMethod('Procedure ImportFromFileCSV( aFilename : string)');
    RegisterMethod('Procedure ImportFromStrLst( aTxtFile : TStrings)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uaEmutecaCustomManager(CL: TPSPascalCompiler);
begin
  SIRegister_caEmutecaCustomManager(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure caEmutecaCustomManagerProgressCallBack_W(Self: caEmutecaCustomManager; const T: TEmutecaProgressCallBack);
begin Self.ProgressCallBack := T; end;

(*----------------------------------------------------------------------------*)
procedure caEmutecaCustomManagerProgressCallBack_R(Self: caEmutecaCustomManager; var T: TEmutecaProgressCallBack);
begin T := Self.ProgressCallBack; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_caEmutecaCustomManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(caEmutecaCustomManager) do
  begin
    RegisterPropertyHelper(@caEmutecaCustomManagerProgressCallBack_R,@caEmutecaCustomManagerProgressCallBack_W,'ProgressCallBack');
    RegisterVirtualMethod(@caEmutecaCustomManager.ImportFromFileIni, 'ImportFromFileIni');
    RegisterVirtualAbstractMethod(@caEmutecaCustomManager, @!.ImportFromIni, 'ImportFromIni');
    RegisterVirtualMethod(@caEmutecaCustomManager.ImportFromFileCSV, 'ImportFromFileCSV');
    RegisterVirtualAbstractMethod(@caEmutecaCustomManager, @!.ImportFromStrLst, 'ImportFromStrLst');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uaEmutecaCustomManager(CL: TPSRuntimeClassImporter);
begin
  RIRegister_caEmutecaCustomManager(CL);
end;

 
 
{ TPSImport_uaEmutecaCustomManager }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uaEmutecaCustomManager.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uaEmutecaCustomManager(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uaEmutecaCustomManager.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uaEmutecaCustomManager(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.