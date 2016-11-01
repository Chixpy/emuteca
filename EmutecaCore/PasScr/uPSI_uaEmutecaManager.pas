unit uPSI_uaEmutecaManager;
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
  TPSImport_uaEmutecaManager = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_caEmutecaManagerTxt(CL: TPSPascalCompiler);
procedure SIRegister_caEmutecaManagerIni(CL: TPSPascalCompiler);
procedure SIRegister_uaEmutecaManager(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_caEmutecaManagerTxt(CL: TPSRuntimeClassImporter);
procedure RIRegister_caEmutecaManagerIni(CL: TPSRuntimeClassImporter);
procedure RIRegister_uaEmutecaManager(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uEmutecaCommon
  ,uaEmutecaManager
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uaEmutecaManager]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_caEmutecaManagerTxt(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'caEmutecaStorableTxt', 'caEmutecaManagerTxt') do
  with CL.AddClassN(CL.FindClass('caEmutecaStorableTxt'),'caEmutecaManagerTxt') do
  begin
    RegisterProperty('ProgressCallBack', 'TEmutecaProgressCallBack', iptrw);
    RegisterMethod('Procedure AssingAllTo( aList : TStrings)');
    RegisterMethod('Procedure AssingEnabledTo( aList : TStrings)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_caEmutecaManagerIni(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'caEmutecaStorableIni', 'caEmutecaManagerIni') do
  with CL.AddClassN(CL.FindClass('caEmutecaStorableIni'),'caEmutecaManagerIni') do
  begin
    RegisterProperty('ProgressCallBack', 'TEmutecaProgressCallBack', iptrw);
    RegisterMethod('Procedure AssingAllTo( aList : TStrings)');
    RegisterMethod('Procedure AssingEnabledTo( aList : TStrings)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uaEmutecaManager(CL: TPSPascalCompiler);
begin
  SIRegister_caEmutecaManagerIni(CL);
  SIRegister_caEmutecaManagerTxt(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure caEmutecaManagerTxtProgressCallBack_W(Self: caEmutecaManagerTxt; const T: TEmutecaProgressCallBack);
begin Self.ProgressCallBack := T; end;

(*----------------------------------------------------------------------------*)
procedure caEmutecaManagerTxtProgressCallBack_R(Self: caEmutecaManagerTxt; var T: TEmutecaProgressCallBack);
begin T := Self.ProgressCallBack; end;

(*----------------------------------------------------------------------------*)
procedure caEmutecaManagerIniProgressCallBack_W(Self: caEmutecaManagerIni; const T: TEmutecaProgressCallBack);
begin Self.ProgressCallBack := T; end;

(*----------------------------------------------------------------------------*)
procedure caEmutecaManagerIniProgressCallBack_R(Self: caEmutecaManagerIni; var T: TEmutecaProgressCallBack);
begin T := Self.ProgressCallBack; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_caEmutecaManagerTxt(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(caEmutecaManagerTxt) do
  begin
    RegisterPropertyHelper(@caEmutecaManagerTxtProgressCallBack_R,@caEmutecaManagerTxtProgressCallBack_W,'ProgressCallBack');
    {TODO: PS}//RegisterVirtualAbstractMethod(@caEmutecaManagerTxt, @!.AssingAllTo, 'AssingAllTo');
    {TODO: PS}//RegisterVirtualAbstractMethod(@caEmutecaManagerTxt, @!.AssingEnabledTo, 'AssingEnabledTo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_caEmutecaManagerIni(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(caEmutecaManagerIni) do
  begin
    RegisterPropertyHelper(@caEmutecaManagerIniProgressCallBack_R,@caEmutecaManagerIniProgressCallBack_W,'ProgressCallBack');
    {TODO: PS}//RegisterVirtualAbstractMethod(@caEmutecaManagerIni, @!.AssingAllTo, 'AssingAllTo');
    {TODO: PS}//RegisterVirtualAbstractMethod(@caEmutecaManagerIni, @!.AssingEnabledTo, 'AssingEnabledTo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uaEmutecaManager(CL: TPSRuntimeClassImporter);
begin
  RIRegister_caEmutecaManagerIni(CL);
  RIRegister_caEmutecaManagerTxt(CL);
end;

 
 
{ TPSImport_uaEmutecaManager }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uaEmutecaManager.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uaEmutecaManager(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uaEmutecaManager.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uaEmutecaManager(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
