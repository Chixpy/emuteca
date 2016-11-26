unit uPSI_ucEmutecaConfig;
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
  TPSImport_ucEmutecaConfig = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cEmutecaConfig(CL: TPSPascalCompiler);
procedure SIRegister_ucEmutecaConfig(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cEmutecaConfig(CL: TPSRuntimeClassImporter);
procedure RIRegister_ucEmutecaConfig(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   LazFileUtils
  ,LazUTF8
  ,Graphics
  ,uCHXStrUtils
  ,uCHXRscStr
  ,u7zWrapper
  ,ucEmutecaConfig
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ucEmutecaConfig]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cEmutecaConfig(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'cEmutecaConfig') do
  with CL.AddClassN(CL.FindClass('TComponent'),'cEmutecaConfig') do
  begin
    RegisterProperty('z7Folder', 'string', iptrw);
    RegisterProperty('z7CMExecutable', 'string', iptrw);
    RegisterProperty('z7GExecutable', 'string', iptrw);
    RegisterProperty('DataFolder', 'string', iptrw);
    RegisterProperty('GroupsFile', 'string', iptrw);
    RegisterProperty('SoftFile', 'string', iptrw);
    RegisterProperty('EmulatorsFile', 'string', iptrw);
    RegisterProperty('SystemsFile', 'string', iptrw);
    RegisterProperty('CompressedExtensions', 'TStringList', iptr);
    RegisterProperty('TempSubfolder', 'string', iptrw);
    RegisterProperty('TempFile', 'string', iptrw);
    RegisterProperty('ConfigFile', 'string', iptrw);
    RegisterMethod('Procedure LoadConfig( aFileName : string)');
    RegisterMethod('Procedure SaveConfig( aFilename : string)');
    RegisterMethod('Procedure SetDefaultConfig');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ucEmutecaConfig(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('krsIniSectionConfig','String').SetString( 'Config');
  SIRegister_cEmutecaConfig(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigConfigFile_W(Self: cEmutecaConfig; const T: string);
begin Self.ConfigFile := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigConfigFile_R(Self: cEmutecaConfig; var T: string);
begin T := Self.ConfigFile; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigTempFile_W(Self: cEmutecaConfig; const T: string);
begin Self.TempFile := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigTempFile_R(Self: cEmutecaConfig; var T: string);
begin T := Self.TempFile; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigTempSubfolder_W(Self: cEmutecaConfig; const T: string);
begin Self.TempSubfolder := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigTempSubfolder_R(Self: cEmutecaConfig; var T: string);
begin T := Self.TempSubfolder; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigCompressedExtensions_R(Self: cEmutecaConfig; var T: TStringList);
begin T := Self.CompressedExtensions; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigSystemsFile_W(Self: cEmutecaConfig; const T: string);
begin Self.SystemsFile := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigSystemsFile_R(Self: cEmutecaConfig; var T: string);
begin T := Self.SystemsFile; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigEmulatorsFile_W(Self: cEmutecaConfig; const T: string);
begin Self.EmulatorsFile := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigEmulatorsFile_R(Self: cEmutecaConfig; var T: string);
begin T := Self.EmulatorsFile; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigSoftFile_W(Self: cEmutecaConfig; const T: string);
begin Self.SoftFile := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigSoftFile_R(Self: cEmutecaConfig; var T: string);
begin T := Self.SoftFile; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigGroupsFile_W(Self: cEmutecaConfig; const T: string);
begin Self.GroupsFile := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigGroupsFile_R(Self: cEmutecaConfig; var T: string);
begin T := Self.GroupsFile; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigDataFolder_W(Self: cEmutecaConfig; const T: string);
begin Self.DataFolder := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigDataFolder_R(Self: cEmutecaConfig; var T: string);
begin T := Self.DataFolder; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigz7GExecutable_W(Self: cEmutecaConfig; const T: string);
begin Self.z7GExecutable := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigz7GExecutable_R(Self: cEmutecaConfig; var T: string);
begin T := Self.z7GExecutable; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigz7CMExecutable_W(Self: cEmutecaConfig; const T: string);
begin Self.z7CMExecutable := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigz7CMExecutable_R(Self: cEmutecaConfig; var T: string);
begin T := Self.z7CMExecutable; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigz7Folder_W(Self: cEmutecaConfig; const T: string);
begin Self.z7Folder := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaConfigz7Folder_R(Self: cEmutecaConfig; var T: string);
begin T := Self.z7Folder; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cEmutecaConfig(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(cEmutecaConfig) do
  begin
    RegisterPropertyHelper(@cEmutecaConfigz7Folder_R,@cEmutecaConfigz7Folder_W,'z7Folder');
    RegisterPropertyHelper(@cEmutecaConfigz7CMExecutable_R,@cEmutecaConfigz7CMExecutable_W,'z7CMExecutable');
    RegisterPropertyHelper(@cEmutecaConfigz7GExecutable_R,@cEmutecaConfigz7GExecutable_W,'z7GExecutable');
    RegisterPropertyHelper(@cEmutecaConfigDataFolder_R,@cEmutecaConfigDataFolder_W,'DataFolder');
    RegisterPropertyHelper(@cEmutecaConfigGroupsFile_R,@cEmutecaConfigGroupsFile_W,'GroupsFile');
    RegisterPropertyHelper(@cEmutecaConfigSoftFile_R,@cEmutecaConfigSoftFile_W,'SoftFile');
    RegisterPropertyHelper(@cEmutecaConfigEmulatorsFile_R,@cEmutecaConfigEmulatorsFile_W,'EmulatorsFile');
    RegisterPropertyHelper(@cEmutecaConfigSystemsFile_R,@cEmutecaConfigSystemsFile_W,'SystemsFile');
    RegisterPropertyHelper(@cEmutecaConfigCompressedExtensions_R,nil,'CompressedExtensions');
    RegisterPropertyHelper(@cEmutecaConfigTempSubfolder_R,@cEmutecaConfigTempSubfolder_W,'TempSubfolder');
    RegisterPropertyHelper(@cEmutecaConfigTempFile_R,@cEmutecaConfigTempFile_W,'TempFile');
    RegisterPropertyHelper(@cEmutecaConfigConfigFile_R,@cEmutecaConfigConfigFile_W,'ConfigFile');
    RegisterMethod(@cEmutecaConfig.LoadConfig, 'LoadConfig');
    RegisterMethod(@cEmutecaConfig.SaveConfig, 'SaveConfig');
    RegisterMethod(@cEmutecaConfig.SetDefaultConfig, 'SetDefaultConfig');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ucEmutecaConfig(CL: TPSRuntimeClassImporter);
begin
  RIRegister_cEmutecaConfig(CL);
end;

 
 
{ TPSImport_ucEmutecaConfig }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ucEmutecaConfig.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ucEmutecaConfig(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ucEmutecaConfig.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ucEmutecaConfig(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
