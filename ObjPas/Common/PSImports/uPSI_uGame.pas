unit uPSI_uGame;
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
  TPSImport_uGame = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cGame(CL: TPSPascalCompiler);
procedure SIRegister_uGame(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cGame(CL: TPSRuntimeClassImporter);
procedure RIRegister_uGame(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   fileutil
  ,IniFiles
  ,LazUTF8
  ,uCHXStrUtils
  ,uGameStats
  ,uEmutecaGame
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uGame]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cGame(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'cGameStats', 'cGame') do
  with CL.AddClassN(CL.FindClass('cGameStats'),'cGame') do
  begin
    RegisterProperty('Key', 'String', iptrw);
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('SortKey', 'String', iptrw);
    RegisterProperty('GameGroup', 'String', iptrw);
    RegisterProperty('Folder', 'String', iptrw);
    RegisterProperty('FileName', 'String', iptrw);
    RegisterProperty('Version', 'String', iptrw);
    RegisterProperty('Year', 'String', iptrw);
    RegisterProperty('Publisher', 'String', iptrw);
    RegisterProperty('Zones', 'TStringList', iptr);
    RegisterProperty('Languages', 'TStringList', iptr);
    RegisterProperty('License', 'String', iptrw);
    RegisterProperty('ReleaseType', 'String', iptrw);
    RegisterProperty('Tags', 'TStringList', iptr);
    RegisterProperty('Verified', 'boolean', iptrw);
    RegisterProperty('Alternate', 'String', iptrw);
    RegisterProperty('BadDump', 'String', iptrw);
    RegisterProperty('Fixed', 'String', iptrw);
    RegisterProperty('Trainer', 'String', iptrw);
    RegisterProperty('Translation', 'String', iptrw);
    RegisterProperty('Pirate', 'String', iptrw);
    RegisterProperty('Cracked', 'String', iptrw);
    RegisterProperty('Modified', 'String', iptrw);
    RegisterProperty('Hack', 'String', iptrw);
    RegisterProperty('DataString', 'String', iptrw);
    RegisterMethod('Procedure ExportData( aFilename : String; ExportMode : boolean)');
    RegisterMethod('Procedure ExportDataIni( aIniFile : TCustomIniFile; ExportMode : boolean)');
    RegisterMethod('Procedure ImportData( aFilename : String)');
    RegisterMethod('Procedure ImportDataIni( aIniFile : TCustomIniFile)');
    RegisterMethod('Constructor Create( const aFolder : String; const aFileName : String; const aKey : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uGame(CL: TPSPascalCompiler);
begin
  SIRegister_cGame(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure cGameDataString_W(Self: cGame; const T: String);
begin Self.DataString := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameDataString_R(Self: cGame; var T: String);
begin T := Self.DataString; end;

(*----------------------------------------------------------------------------*)
procedure cGameHack_W(Self: cGame; const T: String);
begin Self.Hack := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameHack_R(Self: cGame; var T: String);
begin T := Self.Hack; end;

(*----------------------------------------------------------------------------*)
procedure cGameModified_W(Self: cGame; const T: String);
begin Self.Modified := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameModified_R(Self: cGame; var T: String);
begin T := Self.Modified; end;

(*----------------------------------------------------------------------------*)
procedure cGameCracked_W(Self: cGame; const T: String);
begin Self.Cracked := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameCracked_R(Self: cGame; var T: String);
begin T := Self.Cracked; end;

(*----------------------------------------------------------------------------*)
procedure cGamePirate_W(Self: cGame; const T: String);
begin Self.Pirate := T; end;

(*----------------------------------------------------------------------------*)
procedure cGamePirate_R(Self: cGame; var T: String);
begin T := Self.Pirate; end;

(*----------------------------------------------------------------------------*)
procedure cGameTranslation_W(Self: cGame; const T: String);
begin Self.Translation := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameTranslation_R(Self: cGame; var T: String);
begin T := Self.Translation; end;

(*----------------------------------------------------------------------------*)
procedure cGameTrainer_W(Self: cGame; const T: String);
begin Self.Trainer := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameTrainer_R(Self: cGame; var T: String);
begin T := Self.Trainer; end;

(*----------------------------------------------------------------------------*)
procedure cGameFixed_W(Self: cGame; const T: String);
begin Self.Fixed := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameFixed_R(Self: cGame; var T: String);
begin T := Self.Fixed; end;

(*----------------------------------------------------------------------------*)
procedure cGameBadDump_W(Self: cGame; const T: String);
begin Self.BadDump := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameBadDump_R(Self: cGame; var T: String);
begin T := Self.BadDump; end;

(*----------------------------------------------------------------------------*)
procedure cGameAlternate_W(Self: cGame; const T: String);
begin Self.Alternate := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameAlternate_R(Self: cGame; var T: String);
begin T := Self.Alternate; end;

(*----------------------------------------------------------------------------*)
procedure cGameVerified_W(Self: cGame; const T: boolean);
begin Self.Verified := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameVerified_R(Self: cGame; var T: boolean);
begin T := Self.Verified; end;

(*----------------------------------------------------------------------------*)
procedure cGameTags_R(Self: cGame; var T: TStringList);
begin T := Self.Tags; end;

(*----------------------------------------------------------------------------*)
procedure cGameReleaseType_W(Self: cGame; const T: String);
begin Self.ReleaseType := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameReleaseType_R(Self: cGame; var T: String);
begin T := Self.ReleaseType; end;

(*----------------------------------------------------------------------------*)
procedure cGameLicense_W(Self: cGame; const T: String);
begin Self.License := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameLicense_R(Self: cGame; var T: String);
begin T := Self.License; end;

(*----------------------------------------------------------------------------*)
procedure cGameLanguages_R(Self: cGame; var T: TStringList);
begin T := Self.Languages; end;

(*----------------------------------------------------------------------------*)
procedure cGameZones_R(Self: cGame; var T: TStringList);
begin T := Self.Zones; end;

(*----------------------------------------------------------------------------*)
procedure cGamePublisher_W(Self: cGame; const T: String);
begin Self.Publisher := T; end;

(*----------------------------------------------------------------------------*)
procedure cGamePublisher_R(Self: cGame; var T: String);
begin T := Self.Publisher; end;

(*----------------------------------------------------------------------------*)
procedure cGameYear_W(Self: cGame; const T: String);
begin Self.Year := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameYear_R(Self: cGame; var T: String);
begin T := Self.Year; end;

(*----------------------------------------------------------------------------*)
procedure cGameVersion_W(Self: cGame; const T: String);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameVersion_R(Self: cGame; var T: String);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure cGameFileName_W(Self: cGame; const T: String);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameFileName_R(Self: cGame; var T: String);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure cGameFolder_W(Self: cGame; const T: String);
begin Self.Folder := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameFolder_R(Self: cGame; var T: String);
begin T := Self.Folder; end;

(*----------------------------------------------------------------------------*)
procedure cGameGameGroup_W(Self: cGame; const T: String);
begin Self.GameGroup := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameGameGroup_R(Self: cGame; var T: String);
begin T := Self.GameGroup; end;

(*----------------------------------------------------------------------------*)
procedure cGameSortKey_W(Self: cGame; const T: String);
begin Self.SortKey := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameSortKey_R(Self: cGame; var T: String);
begin T := Self.SortKey; end;

(*----------------------------------------------------------------------------*)
procedure cGameName_W(Self: cGame; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameName_R(Self: cGame; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure cGameKey_W(Self: cGame; const T: String);
begin Self.Key := T; end;

(*----------------------------------------------------------------------------*)
procedure cGameKey_R(Self: cGame; var T: String);
begin T := Self.Key; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cGame(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(cGame) do
  begin
    RegisterPropertyHelper(@cGameKey_R,@cGameKey_W,'Key');
    RegisterPropertyHelper(@cGameName_R,@cGameName_W,'Name');
    RegisterPropertyHelper(@cGameSortKey_R,@cGameSortKey_W,'SortKey');
    RegisterPropertyHelper(@cGameGameGroup_R,@cGameGameGroup_W,'GameGroup');
    RegisterPropertyHelper(@cGameFolder_R,@cGameFolder_W,'Folder');
    RegisterPropertyHelper(@cGameFileName_R,@cGameFileName_W,'FileName');
    RegisterPropertyHelper(@cGameVersion_R,@cGameVersion_W,'Version');
    RegisterPropertyHelper(@cGameYear_R,@cGameYear_W,'Year');
    RegisterPropertyHelper(@cGamePublisher_R,@cGamePublisher_W,'Publisher');
    RegisterPropertyHelper(@cGameZones_R,nil,'Zones');
    RegisterPropertyHelper(@cGameLanguages_R,nil,'Languages');
    RegisterPropertyHelper(@cGameLicense_R,@cGameLicense_W,'License');
    RegisterPropertyHelper(@cGameReleaseType_R,@cGameReleaseType_W,'ReleaseType');
    RegisterPropertyHelper(@cGameTags_R,nil,'Tags');
    RegisterPropertyHelper(@cGameVerified_R,@cGameVerified_W,'Verified');
    RegisterPropertyHelper(@cGameAlternate_R,@cGameAlternate_W,'Alternate');
    RegisterPropertyHelper(@cGameBadDump_R,@cGameBadDump_W,'BadDump');
    RegisterPropertyHelper(@cGameFixed_R,@cGameFixed_W,'Fixed');
    RegisterPropertyHelper(@cGameTrainer_R,@cGameTrainer_W,'Trainer');
    RegisterPropertyHelper(@cGameTranslation_R,@cGameTranslation_W,'Translation');
    RegisterPropertyHelper(@cGamePirate_R,@cGamePirate_W,'Pirate');
    RegisterPropertyHelper(@cGameCracked_R,@cGameCracked_W,'Cracked');
    RegisterPropertyHelper(@cGameModified_R,@cGameModified_W,'Modified');
    RegisterPropertyHelper(@cGameHack_R,@cGameHack_W,'Hack');
    RegisterPropertyHelper(@cGameDataString_R,@cGameDataString_W,'DataString');
    RegisterMethod(@cGame.ExportData, 'ExportData');
    RegisterMethod(@cGame.ExportDataIni, 'ExportDataIni');
    RegisterMethod(@cGame.ImportData, 'ImportData');
    RegisterMethod(@cGame.ImportDataIni, 'ImportDataIni');
    RegisterConstructor(@cGame.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uGame(CL: TPSRuntimeClassImporter);
begin
  RIRegister_cGame(CL);
end;

 
 
{ TPSImport_uGame }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uGame.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uGame(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uGame.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uGame(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
