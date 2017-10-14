unit uPSI_ucEmutecaPlayingStats;
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
  TPSImport_ucEmutecaPlayingStats = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cEmutecaPlayingStats(CL: TPSPascalCompiler);
procedure SIRegister_ucEmutecaPlayingStats(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cEmutecaPlayingStats(CL: TPSRuntimeClassImporter);
procedure RIRegister_ucEmutecaPlayingStats(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   dateutils
  ,IniFiles
  ,Graphics
  ,uCHXStrUtils
  ,uEmutecaCommon
  ,ucEmutecaPlayingStats
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ucEmutecaPlayingStats]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cEmutecaPlayingStats(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'cEmutecaPlayingStats') do
  with CL.AddClassN(CL.FindClass('TComponent'),'cEmutecaPlayingStats') do
  begin
    RegisterMethod('Procedure AddPlayingTime( const Start : TDateTime; NumberOfSeconds : int64)');
    RegisterMethod('Procedure WriteToIni( aIniFile : TCustomIniFile; const Section : string; ExportMode : boolean)');
    RegisterMethod('Procedure LoadFromIni( aIniFile : TCustomIniFile; const Section : string)');
    RegisterMethod('Procedure WriteToStrLst( aTxtFile : TStrings; ExportMode : boolean)');
    RegisterMethod('Procedure LoadFromStrLst( aTxtFile : TStrings; const NLine : integer)');
    RegisterProperty('LastTime', 'TDateTime', iptrw);
    RegisterProperty('TimesPlayed', 'int64', iptrw);
    RegisterProperty('PlayingTime', 'int64', iptrw);
    RegisterMethod('Function LastTimeStr : string');
    RegisterMethod('Function TimesPlayedStr : string');
    RegisterMethod('Function PlayingTimeStr : string');
    RegisterProperty('IconIndex', 'integer', iptrw);
    RegisterProperty('Icon', 'TPicture', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ucEmutecaPlayingStats(CL: TPSPascalCompiler);
begin
  SIRegister_cEmutecaPlayingStats(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure cEmutecaPlayingStatsIcon_W(Self: cEmutecaPlayingStats; const T: TPicture);
begin Self.Icon := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaPlayingStatsIcon_R(Self: cEmutecaPlayingStats; var T: TPicture);
begin T := Self.Icon; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaPlayingStatsIconIndex_W(Self: cEmutecaPlayingStats; const T: integer);
begin Self.IconIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaPlayingStatsIconIndex_R(Self: cEmutecaPlayingStats; var T: integer);
begin T := Self.IconIndex; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaPlayingStatsPlayingTime_W(Self: cEmutecaPlayingStats; const T: int64);
begin Self.PlayingTime := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaPlayingStatsPlayingTime_R(Self: cEmutecaPlayingStats; var T: int64);
begin T := Self.PlayingTime; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaPlayingStatsTimesPlayed_W(Self: cEmutecaPlayingStats; const T: int64);
begin Self.TimesPlayed := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaPlayingStatsTimesPlayed_R(Self: cEmutecaPlayingStats; var T: int64);
begin T := Self.TimesPlayed; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaPlayingStatsLastTime_W(Self: cEmutecaPlayingStats; const T: TDateTime);
begin Self.LastTime := T; end;

(*----------------------------------------------------------------------------*)
procedure cEmutecaPlayingStatsLastTime_R(Self: cEmutecaPlayingStats; var T: TDateTime);
begin T := Self.LastTime; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cEmutecaPlayingStats(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(cEmutecaPlayingStats) do
  begin
    RegisterMethod(@cEmutecaPlayingStats.AddPlayingTime, 'AddPlayingTime');
    RegisterMethod(@cEmutecaPlayingStats.WriteToIni, 'WriteToIni');
    RegisterMethod(@cEmutecaPlayingStats.LoadFromIni, 'LoadFromIni');
    RegisterMethod(@cEmutecaPlayingStats.WriteToStrLst, 'WriteToStrLst');
    RegisterMethod(@cEmutecaPlayingStats.LoadFromStrLst, 'LoadFromStrLst');
    RegisterPropertyHelper(@cEmutecaPlayingStatsLastTime_R,@cEmutecaPlayingStatsLastTime_W,'LastTime');
    RegisterPropertyHelper(@cEmutecaPlayingStatsTimesPlayed_R,@cEmutecaPlayingStatsTimesPlayed_W,'TimesPlayed');
    RegisterPropertyHelper(@cEmutecaPlayingStatsPlayingTime_R,@cEmutecaPlayingStatsPlayingTime_W,'PlayingTime');
    RegisterMethod(@cEmutecaPlayingStats.LastTimeStr, 'LastTimeStr');
    RegisterMethod(@cEmutecaPlayingStats.TimesPlayedStr, 'TimesPlayedStr');
    RegisterMethod(@cEmutecaPlayingStats.PlayingTimeStr, 'PlayingTimeStr');
    RegisterPropertyHelper(@cEmutecaPlayingStatsIconIndex_R,@cEmutecaPlayingStatsIconIndex_W,'IconIndex');
    RegisterPropertyHelper(@cEmutecaPlayingStatsIcon_R,@cEmutecaPlayingStatsIcon_W,'Icon');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ucEmutecaPlayingStats(CL: TPSRuntimeClassImporter);
begin
  RIRegister_cEmutecaPlayingStats(CL);
end;

 
 
{ TPSImport_ucEmutecaPlayingStats }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ucEmutecaPlayingStats.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ucEmutecaPlayingStats(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ucEmutecaPlayingStats.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ucEmutecaPlayingStats(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.