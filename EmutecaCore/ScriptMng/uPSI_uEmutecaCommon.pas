unit uPSI_uEmutecaCommon;

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
  , Classes
  , uPSComponent
  , uPSRuntime
  , uPSCompiler;

type
  (*----------------------------------------------------------------------------*)
  TPSImport_uEmutecaCommon = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript;
      const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_uEmutecaCommon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uEmutecaCommon_Routines(S: TPSExec);

procedure Register;

implementation


uses
  FileUtil
  , LazFileUtils
  , LazUTF8
  , u7zWrapper
  , uCHXStrUtils
  , uCHXFileUtils
  , uEmutecaCommon;

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uEmutecaCommon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uEmutecaCommon(CL: TPSPascalCompiler);
begin
  CL.AddConstantN('rsFmtWindowCaption', 'String').SetString('%0:s: %1:s');
  CL.AddConstantN('krsEmutecaTempGameSubFolder', 'String').SetString('Soft/');
  CL.AddConstantN('krsEmutecaGroupFileExt', 'String').SetString('.egl');
  CL.AddConstantN('krsEmutecaSoftFileExt', 'String').SetString('.csv');
  CL.AddConstantN('krsEmutecaINIFileExt', 'String').SetString('.ini');
  CL.AddConstantN('krsEmutecaScriptFileExt', 'String').SetString('.pas');
  CL.AddConstantN('krsEmutecaTXTFileExt', 'String').SetString('.txt');
  CL.AddConstantN('kEmutecaExecErrorNoGame', 'LongInt').SetInt(-300);
  CL.AddConstantN('kEmutecaDecompressError', 'LongInt').SetInt(-301);
  CL.AddConstantN('krsCSVStatsHeader', 'String').SetString(
    '"Last Time","Times Played","Playing Time"');
  CL.AddConstantN('krsCSVSoftHeader', 'String').SetString(
    '"Group","SHA1","ID","Folder","FileName","Title","TransliteratedName",' +
    '"SortTitle","Version","Year","Publisher","Zone","DumpStatus",' +
    '"DumpInfo","Fixed","Trainer","Translation",' +
    '"Pirate","Cracked","Modified","Hack"');
  CL.AddConstantN('krsCSVGroupHeader', 'String').SetString(
    '"ID","Title","Year","Developer"');
  CL.AddConstantN('krsIniKeyID', 'String').SetString('ID');
  CL.AddConstantN('krsIniKeyTitle', 'String').SetString('Title');
  CL.AddConstantN('krsIniKeyFileName', 'String').SetString('FileName');
  CL.AddConstantN('krsIniKeyYear', 'String').SetString('Year');
  CL.AddConstantN('krsIniKeyEnabled', 'String').SetString('Enabled');
  CL.AddConstantN('krsIniKeyExtensions', 'String').SetString('Extensions');
  CL.AddConstantN('krsIniKeyBaseFolder', 'String').SetString('BaseFolder');
  CL.AddConstantN('krsIniKeyWorkingFolder', 'String').SetString(
    'WorkingFolder');
  CL.AddConstantN('krsIniKeyMainEmulator', 'String').SetString('MainEmulator');
  CL.AddConstantN('krsIniKeyOtherEmulators', 'String').SetString(
    'OtherEmulators');
  CL.AddConstantN('krsIniKeyIcon', 'String').SetString('Icon');
  CL.AddConstantN('krsIniKeyImage', 'String').SetString('Image');
  CL.AddConstantN('krsIniKeyBackImage', 'String').SetString('BackImage');
  CL.AddConstantN('krsIniKeyIconFolder', 'String').SetString('IconFolder');
  CL.AddConstantN('krsIniKeyImageFolders', 'String').SetString('ImageFolders');
  CL.AddConstantN('krsIniKeyImageCaptions', 'String').SetString(
    'ImageCaptions');
  CL.AddConstantN('krsIniKeyText', 'String').SetString('Text');
  CL.AddConstantN('krsIniKeyTextFolders', 'String').SetString('TextFolders');
  CL.AddConstantN('krsIniKeyTextCaptions', 'String').SetString('TextCaptions');
  CL.AddConstantN('krsIniKeyMusicFolders', 'String').SetString('MusicFolders');
  CL.AddConstantN('krsIniKeyMusicCaptions', 'String').SetString(
    'MusicCaptions');
  CL.AddConstantN('krsIniKeyVideoFolders', 'String').SetString('VideoFolders');
  CL.AddConstantN('krsIniKeyVideoCaptions', 'String').SetString(
    'VideoCaptions');
  CL.AddConstantN('krsIniKeySoftExportKey', 'String').SetString(
    'SoftExportKey');
  CL.AddConstantN('krsIniKeyExtractAll', 'String').SetString('ExtractAll');
  CL.AddConstantN('krsCRC32', 'String').SetString('CRC32');
  CL.AddConstantN('krsSHA1', 'String').SetString('SHA1');
  CL.AddConstantN('krsFileName', 'String').SetString('FileName');
  CL.AddConstantN('krsCustom', 'String').SetString('Custom');
  CL.AddConstantN('krsIniKeyDeveloper', 'String').SetString('Developer');
  CL.AddConstantN('krsIniKeySHA1', 'String').SetString('SHA1');
  CL.AddConstantN('krsIniKeyGroup', 'String').SetString('Group');
  CL.AddConstantN('krsIniKeyTranslitTitl', 'String').SetString(
    'TranslitTitle');
  CL.AddConstantN('krsIniKeySortTitle', 'String').SetString('SortTitle');
  CL.AddConstantN('krsIniKeyVersion', 'String').SetString('Version');
  CL.AddConstantN('krsIniKeyPublisher', 'String').SetString('Publisher');
  CL.AddConstantN('krsIniKeyZone', 'String').SetString('Zone');
  CL.AddConstantN('krsIniKeyDumpInfo', 'String').SetString('DumpInfo');
  CL.AddConstantN('krsIniKeyDumpStatus', 'String').SetString('DumpStatus');
  CL.AddConstantN('krsIniKeyFixed', 'String').SetString('Fixed');
  CL.AddConstantN('krsIniKeyTrainer', 'String').SetString('Trainer');
  CL.AddConstantN('krsIniKeyTranslation', 'String').SetString('Translation');
  CL.AddConstantN('krsIniKeyPirate', 'String').SetString('Pirate');
  CL.AddConstantN('krsIniKeyCracked', 'String').SetString('Cracked');
  CL.AddConstantN('krsIniKeyModified', 'String').SetString('Modified');
  CL.AddConstantN('krsIniKeyHack', 'String').SetString('Hack');
  CL.AddConstantN('krsIniKeyFolder', 'String').SetString('Folder');
  CL.AddConstantN('krsedsVerified', 'String').SetString('Verified');
  CL.AddConstantN('krsedsGood', 'String').SetString('GoodDump');
  CL.AddConstantN('krsedsAlternate', 'String').SetString('Alternate');
  CL.AddConstantN('krsedsOverDump', 'String').SetString('OverDump');
  CL.AddConstantN('krsedsBadDump', 'String').SetString('BadDump');
  CL.AddConstantN('krsedsUnderDump', 'String').SetString('UnderDump');
  CL.AddConstantN('krsIniKeyPlayingTime', 'String').SetString('PlayingTime');
  CL.AddConstantN('krsIniKeyTimesPlayed', 'String').SetString('TimesPlayed');
  CL.AddConstantN('krsIniKeyLastTime', 'String').SetString('LastTime');
  CL.AddConstantN('rsLoadingSystemList', 'String').SetString(
    'Loading system list...');
  CL.AddConstantN('rsImportingSystemList', 'String').SetString(
    'Importing system list...');
  CL.AddConstantN('rsSavingSystemList', 'String').SetString(
    'Saving system list...');
  CL.AddConstantN('rsLoadingSoftList', 'String').SetString(
    'Loading soft list...');
  CL.AddConstantN('rsImportingSoftList', 'String').SetString(
    'Importing soft list...');
  CL.AddConstantN('rsSavingSoftList', 'String').SetString(
    'Saving soft list...');
  CL.AddConstantN('rsLoadingGroupList', 'String').SetString(
    'Loading group list...');
  CL.AddConstantN('rsImportingGroupList', 'String').SetString(
    'Importing group list...');
  CL.AddConstantN('rsSavingGroupList', 'String').SetString(
    'Saving group list...');
  CL.AddConstantN('rsedsVerified', 'String').SetString('Verified');
  CL.AddConstantN('rsedsGood', 'String').SetString('GoodDump');
  CL.AddConstantN('rsedsAlternate', 'String').SetString('Alternate');
  CL.AddConstantN('rsedsOverDump', 'String').SetString('OverDump');
  CL.AddConstantN('rsedsBadDump', 'String').SetString('BadDump');
  CL.AddConstantN('rsedsUnderDump', 'String').SetString('UnderDump');
  CL.AddConstantN('rsFileAlreadyAdded', 'String').SetString(
    'This file is already added.');
  CL.AddTypeS('TEmutecaSoftExportKey',
    '( TEFKSHA1, TEFKCRC32, TEFKFileName, TE' + 'FKCustom )');
  CL.AddTypeS('TEmutecaDumpStatus',
    '( edsVerified, edsGood, edsAlternate, edsO' +
    'verDump, edsBadDump, edsUnderDump )');
  CL.AddTypeS('TEmutecaProgressCallBack',
    'Function ( const Title, Info1, Info2' +
    ' : string; const Value, MaxValue : int64) : boolean');
  CL.AddDelphiFunction(
    'Function Str2EmutecaSoftExportKey( aString : string) : TEmutecaSoftExportKey');
  CL.AddDelphiFunction(
    'Function EmutecaSoftExportKey2StrK( aSOK : TEmutecaSoftExportKey) : string');
  CL.AddDelphiFunction(
    'Function Key2EmutecaDumpSt( aString : string) : TEmutecaDumpStatus');
  CL.AddDelphiFunction(
    'Function EmutecaDumpSt2Key( aEDS : TEmutecaDumpStatus) : string');
  CL.AddDelphiFunction(
    'Function EmutecaDumpSt2Str( aEDS : TEmutecaDumpStatus) : string');
  CL.AddDelphiFunction(
    'Function EmutecaDumpSt2StrK( aEDS : TEmutecaDumpStatus) : string');
  CL.AddDelphiFunction(
    'Procedure EmuTKSearchAllRelatedFiles( OutFileList : TStrings; aFolder : string; aFileName : string; Extensions : TStrings; SearchInComp : boolean; DecompressFolder : string)');
  CL.AddDelphiFunction(
    'Function EmuTKSearchFirstRelatedFile( aFolder : string; aFileName : string; Extensions : TStrings; SearchInComp : boolean; AutoDecompress : boolean; DecompressFolder : string) : string');
  CL.AddDelphiFunction(
    'Procedure EmuTKSearchAllFilesByNameExtCT( aFileList : TStrings; aBaseFileName : string; aExtList : string)');
  CL.AddDelphiFunction(
    'Procedure EmuTKSearchAllFilesByNameExtSL( aFileList : TStrings; aBaseFileName : string; aExtList : TStrings)');
  CL.AddDelphiFunction(
    'Function EmuTKSearchFirstFileByNameExtCT( aBaseFileName : string; aExtList : string) : string');
  CL.AddDelphiFunction(
    'Function EmuTKSearchFirstFileByNameExtSL( aBaseFileName : string; aExtList : TStrings) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uEmutecaCommon_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@Str2EmutecaSoftExportKey,
    'Str2EmutecaSoftExportKey', cdRegister);
  S.RegisterDelphiFunction(@EmutecaSoftExportKey2StrK,
    'EmutecaSoftExportKey2StrK', cdRegister);
  S.RegisterDelphiFunction(@Key2EmutecaDumpSt, 'Key2EmutecaDumpSt',
    cdRegister);
  S.RegisterDelphiFunction(@EmutecaDumpSt2Key, 'EmutecaDumpSt2Key',
    cdRegister);
  S.RegisterDelphiFunction(@EmutecaDumpSt2Str, 'EmutecaDumpSt2Str',
    cdRegister);
  S.RegisterDelphiFunction(@EmutecaDumpSt2StrK, 'EmutecaDumpSt2StrK',
    cdRegister);
  S.RegisterDelphiFunction(@EmuTKSearchAllRelatedFiles,
    'EmuTKSearchAllRelatedFiles', cdRegister);
  S.RegisterDelphiFunction(@EmuTKSearchFirstRelatedFile,
    'EmuTKSearchFirstRelatedFile', cdRegister);
  S.RegisterDelphiFunction(@EmuTKSearchAllFilesByNameExtCT,
    'EmuTKSearchAllFilesByNameExtCT', cdRegister);
  S.RegisterDelphiFunction(@EmuTKSearchAllFilesByNameExtSL,
    'EmuTKSearchAllFilesByNameExtSL', cdRegister);
  S.RegisterDelphiFunction(@EmuTKSearchFirstFileByNameExtCT,
    'EmuTKSearchFirstFileByNameExtCT', cdRegister);
  S.RegisterDelphiFunction(@EmuTKSearchFirstFileByNameExtSL,
    'EmuTKSearchFirstFileByNameExtSL', cdRegister);
end;



{ TPSImport_uEmutecaCommon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uEmutecaCommon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uEmutecaCommon(CompExec.comp);
end;

(*----------------------------------------------------------------------------*)
procedure TPSImport_uEmutecaCommon.ExecImport1(CompExec: TPSScript;
  const ri: TPSRuntimeClassImporter);
begin
  // RIRegister_uEmutecaCommon(ri);
  RIRegister_uEmutecaCommon_Routines(CompExec.Exec);
  // comment it if no routines
end;

(*----------------------------------------------------------------------------*)


end.
