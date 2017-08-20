unit uPSI_ucEmutecaGroupManager;
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
  TPSImport_ucEmutecaGroupManager = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cEmutecaGroupManager(CL: TPSPascalCompiler);
procedure SIRegister_ucEmutecaGroupManager(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cEmutecaGroupManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_ucEmutecaGroupManager(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   FileUtil
  ,LazFileUtils
  ,IniFiles
  ,LazUTF8
  ,LConvEncoding
  ,LResources
  ,uEmutecaCommon
  ,uaCHXStorable
  ,uaEmutecaCustomManager
  ,uaEmutecaCustomSystem
  ,ucEmutecaGroupList
  ,ucEmutecaGroupManager
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ucEmutecaGroupManager]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cEmutecaGroupManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'caEmutecaCustomManager', 'cEmutecaGroupManager') do
  with CL.AddClassN(CL.FindClass('caEmutecaCustomManager'),'cEmutecaGroupManager') do
  begin
    RegisterProperty('System', 'caEmutecaCustomSystem', iptrw);
    RegisterProperty('FullList', 'cEmutecaGroupList', iptr);
    RegisterProperty('VisibleList', 'cEmutecaGroupList', iptr);
    RegisterMethod('Function AddGroup( aID : string) : integer');
    RegisterMethod('Procedure ClearData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ucEmutecaGroupManager(CL: TPSPascalCompiler);
begin
  SIRegister_cEmutecaGroupManager(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure cEmutecaGroupManagerVisibleList_R(Self: cEmutecaGroupManager; var T: cEmutecaGroupList);
begin T := Self.VisibleList; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaGroupManagerFullList_R(Self: cEmutecaGroupManager; var T: cEmutecaGroupList);
begin T := Self.FullList; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaGroupManagerSystem_W(Self: cEmutecaGroupManager; const T: caEmutecaCustomSystem);
begin Self.System := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaGroupManagerSystem_R(Self: cEmutecaGroupManager; var T: caEmutecaCustomSystem);
begin T := Self.System; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cEmutecaGroupManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(cEmutecaGroupManager) do
  begin
    RegisterPropertyHelper(@cEmutecaGroupManagerSystem_R,@cEmutecaGroupManagerSystem_W,'System');
    RegisterPropertyHelper(@cEmutecaGroupManagerFullList_R,nil,'FullList');
    RegisterPropertyHelper(@cEmutecaGroupManagerVisibleList_R,nil,'VisibleList');
    RegisterMethod(@cEmutecaGroupManager.AddGroup, 'AddGroup');
    RegisterMethod(@cEmutecaGroupManager.ClearData, 'ClearData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ucEmutecaGroupManager(CL: TPSRuntimeClassImporter);
begin
  RIRegister_cEmutecaGroupManager(CL);
end;

 
 
{ TPSImport_ucEmutecaGroupManager }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ucEmutecaGroupManager.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ucEmutecaGroupManager(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ucEmutecaGroupManager.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ucEmutecaGroupManager(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
