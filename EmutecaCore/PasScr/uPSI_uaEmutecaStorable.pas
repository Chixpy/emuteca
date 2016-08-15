unit uPSI_uaEmutecaStorable;
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
  TPSImport_uaEmutecaStorable = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_caEmutecaStorableTxt(CL: TPSPascalCompiler);
procedure SIRegister_caEmutecaStorableIni(CL: TPSPascalCompiler);
procedure SIRegister_caEmutecaStorable(CL: TPSPascalCompiler);
procedure SIRegister_uaEmutecaStorable(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_caEmutecaStorableTxt(CL: TPSRuntimeClassImporter);
procedure RIRegister_caEmutecaStorableIni(CL: TPSRuntimeClassImporter);
procedure RIRegister_caEmutecaStorable(CL: TPSRuntimeClassImporter);
procedure RIRegister_uaEmutecaStorable(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IniFiles
  ,LazUTF8
  ,LazFileUtils
  ,uaEmutecaStorable
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uaEmutecaStorable]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_caEmutecaStorableTxt(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'caEmutecaStorable', 'caEmutecaStorableTxt') do
  with CL.AddClassN(CL.FindClass('caEmutecaStorable'),'caEmutecaStorableTxt') do
  begin
    RegisterMethod('Procedure LoadFromFileTxt( TxtFile : TStrings)');
    RegisterMethod('Procedure SaveToFileTxt( TxtFile : TStrings; const ExportMode : boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_caEmutecaStorableIni(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'caEmutecaStorable', 'caEmutecaStorableIni') do
  with CL.AddClassN(CL.FindClass('caEmutecaStorable'),'caEmutecaStorableIni') do
  begin
    RegisterMethod('Procedure LoadFromFileIni( IniFile : TCustomIniFile)');
    RegisterMethod('Procedure SaveToFileIni( IniFile : TCustomIniFile; const ExportMode : boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_caEmutecaStorable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'caEmutecaStorable') do
  with CL.AddClassN(CL.FindClass('TComponent'),'caEmutecaStorable') do
  begin
    RegisterMethod('Procedure LoadFromFile( FileName : string)');
    RegisterMethod('Procedure SaveToFile( FileName : string; const ExportMode : boolean)');
    RegisterProperty('DataFile', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uaEmutecaStorable(CL: TPSPascalCompiler);
begin
  SIRegister_caEmutecaStorable(CL);
  SIRegister_caEmutecaStorableIni(CL);
  SIRegister_caEmutecaStorableTxt(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure caEmutecaStorableDataFile_W(Self: caEmutecaStorable; const T: string);
begin Self.DataFile := T; end;

(*----------------------------------------------------------------------------*)
procedure caEmutecaStorableDataFile_R(Self: caEmutecaStorable; var T: string);
begin T := Self.DataFile; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_caEmutecaStorableTxt(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(caEmutecaStorableTxt) do
  begin
   {TODO: PS}// RegisterVirtualAbstractMethod(@caEmutecaStorableTxt, @!.LoadFromFileTxt, 'LoadFromFileTxt');
   {TODO: PS}//RegisterVirtualAbstractMethod(@caEmutecaStorableTxt, @!.SaveToFileTxt, 'SaveToFileTxt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_caEmutecaStorableIni(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(caEmutecaStorableIni) do
  begin
   {TODO: PS}//RegisterVirtualAbstractMethod(@caEmutecaStorableIni, @!.LoadFromFileIni, 'LoadFromFileIni');
   {TODO: PS}// RegisterVirtualAbstractMethod(@caEmutecaStorableIni, @!.SaveToFileIni, 'SaveToFileIni');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_caEmutecaStorable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(caEmutecaStorable) do
  begin
    {TODO: PS}//RegisterVirtualAbstractMethod(@caEmutecaStorable, @!.LoadFromFile, 'LoadFromFile');
    {TODO: PS}//RegisterVirtualAbstractMethod(@caEmutecaStorable, @!.SaveToFile, 'SaveToFile');
    RegisterPropertyHelper(@caEmutecaStorableDataFile_R,@caEmutecaStorableDataFile_W,'DataFile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uaEmutecaStorable(CL: TPSRuntimeClassImporter);
begin
  RIRegister_caEmutecaStorable(CL);
  RIRegister_caEmutecaStorableIni(CL);
  RIRegister_caEmutecaStorableTxt(CL);
end;

 
 
{ TPSImport_uaEmutecaStorable }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uaEmutecaStorable.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uaEmutecaStorable(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uaEmutecaStorable.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uaEmutecaStorable(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.