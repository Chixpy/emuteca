{
[Info]
This script test Emuteca common constants and functions.
[Author]
Name=Chixpy
[Script]
}
program TestBasic;

var
  i: integer;
  aStr, aFolder, aFile: string;
  aBool: boolean;

begin
  WriteLn('CONSTANTS');
  WriteLn('=========');
  WriteLn('');
  WriteLn('krsFmtWindowCaption');
  WriteLn('  ' + krsFmtWindowCaption);
  WriteLn('');
  WriteLn('krsTempGameSubFolder');
  WriteLn('  ' + krsTempGameSubFolder);
  WriteLn('');
  WriteLn('File extensions');
  WriteLn('---------------');
  WriteLn('');
  WriteLn('krsFileExtGroup');
  WriteLn('  ' + krsFileExtGroup);
  WriteLn('');
  WriteLn('krsFileExtSoft');
  WriteLn('  ' + krsFileExtSoft);
  WriteLn('');
  WriteLn('krsFileExtINI');
  WriteLn('  ' + krsFileExtINI);
  WriteLn('');
  WriteLn('krsFileExtScript');
  WriteLn('  ' + krsFileExtScript);
  WriteLn('');
  WriteLn('krsFileExtTXT');
  WriteLn('  ' + krsFileExtTXT);
  WriteLn('');
  WriteLn('File masks for filters');
  WriteLn('----------------------');
  WriteLn('');
  WriteLn('krsFileMaskGroup');
  WriteLn('  ' + krsFileMaskGroup);
  WriteLn('');
  WriteLn('krsFileMaskSoft');
  WriteLn('  ' + krsFileMaskSoft);
  WriteLn('');
  WriteLn('krsFileMaskINI');
  WriteLn('  ' + krsFileMaskINI);
  WriteLn('');
  WriteLn('krsFileMaskScript');
  WriteLn('  ' + krsFileMaskScript);
  WriteLn('');
  WriteLn('krsFileMaskTXT');
  WriteLn('  ' + krsFileMaskTXT);
  WriteLn('');
  WriteLn('EXIT CODES for handling some errors');
  WriteLn('-----------------------------------');
  WriteLn('');
  WriteLn('kErrorExecNoGame');
  WriteLn('  ' + IntToStr(kErrorExecNoGame));
  WriteLn('');
  WriteLn('kError7zDecompress');
  WriteLn('  ' + IntToStr(kError7zDecompress));
  WriteLn('');
  WriteLn('CSV list headers');
  WriteLn('----------------');
  WriteLn('');
  WriteLn('krsCSVStatsHeader');
  WriteLn('  ' + krsCSVStatsHeader);
  WriteLn('');
  WriteLn('krsCSVSoftHeader');
  WriteLn('  ' + krsCSVSoftHeader);
  WriteLn('');
  WriteLn('krsCSVSoftStatsHeader');
  WriteLn('  ' + krsCSVSoftStatsHeader);
  WriteLn('');
  WriteLn('krsCSVGroupHeader');
  WriteLn('  ' + krsCSVGroupHeader);
  WriteLn('');
  WriteLn('krsCSVGroupStatsHeader');
  WriteLn('  ' + krsCSVGroupStatsHeader);
  WriteLn('');
  WriteLn('IniKeys');
  WriteLn('-------');
  WriteLn('Shared');
  WriteLn('');
  WriteLn('krsIniKeyID');
  WriteLn('  ' + krsIniKeyID);
  WriteLn('');
  WriteLn('krsIniKeyTitle');
  WriteLn('  ' + krsIniKeyTitle);
  WriteLn('');
  WriteLn('krsIniKeySortTitle');
  WriteLn('  ' + krsIniKeySortTitle);
  WriteLn('');
  WriteLn('krsIniKeyFileName');
  WriteLn('  ' + krsIniKeyFileName);
  WriteLn('');
  WriteLn('krsIniKeyYear');
  WriteLn('  ' + krsIniKeyYear);
  WriteLn('');
  WriteLn('krsIniKeyEnabled');
  WriteLn('  ' + krsIniKeyEnabled);
  WriteLn('');
  WriteLn('System');
  WriteLn('  Shared Keys: krsIniKeyID, krsIniKeyTitle, krsIniKeyFileName');
  WriteLn('');
  WriteLn('krsIniKeyExtensions');
  WriteLn('  ' + krsIniKeyExtensions);
  WriteLn('');
  WriteLn('krsIniKeyBaseFolder');
  WriteLn('  ' + krsIniKeyBaseFolder);
  WriteLn('');
  WriteLn('krsIniKeyWorkingFolder');
  WriteLn('  ' + krsIniKeyWorkingFolder);
  WriteLn('');
  WriteLn('krsIniKeyMainEmulator');
  WriteLn('  ' + krsIniKeyMainEmulator);
  WriteLn('');
  WriteLn('krsIniKeyOtherEmulators');
  WriteLn('  ' + krsIniKeyOtherEmulators);
  WriteLn('');
  WriteLn('krsIniKeyIcon');
  WriteLn('  ' + krsIniKeyIcon);
  WriteLn('');
  WriteLn('krsIniKeyImage');
  WriteLn('  ' + krsIniKeyImage);
  WriteLn('');
  WriteLn('krsIniKeyBackImage');
  WriteLn('  ' + krsIniKeyBackImage);
  WriteLn('');
  WriteLn('krsIniKeyIconFolder');
  WriteLn('  ' + krsIniKeyIconFolder);
  WriteLn('');
  WriteLn('krsIniKeyImageFolders');
  WriteLn('  ' + krsIniKeyImageFolders);
  WriteLn('');
  WriteLn('krsIniKeyImageCaptions');
  WriteLn('  ' + krsIniKeyImageCaptions);
  WriteLn('');
  WriteLn('krsIniKeyText');
  WriteLn('  ' + krsIniKeyText);
  WriteLn('');
  WriteLn('krsIniKeyTextFolders');
  WriteLn('  ' + krsIniKeyTextFolders);
  WriteLn('');
  WriteLn('krsIniKeyTextCaptions');
  WriteLn('  ' + krsIniKeyTextCaptions);
  WriteLn('');
  WriteLn('krsIniKeyMusicFolders');
  WriteLn('  ' + krsIniKeyMusicFolders);
  WriteLn('');
  WriteLn('krsIniKeyMusicCaptions');
  WriteLn('  ' + krsIniKeyMusicCaptions);
  WriteLn('');
  WriteLn('krsIniKeyVideoFolders');
  WriteLn('  ' + krsIniKeyVideoFolders);
  WriteLn('');
  WriteLn('krsIniKeyVideoCaptions');
  WriteLn('  ' + krsIniKeyVideoCaptions);
  WriteLn('');
  WriteLn('krsIniKeySoftExportKey');
  WriteLn('  ' + krsIniKeySoftExportKey);
  WriteLn('');
  WriteLn('krsIniKeyExtractAll');
  WriteLn('  ' + krsIniKeyExtractAll);
  WriteLn('');
  WriteLn('Group');
  WriteLn('  Shared Keys: krsIniKeyID, krsIniKeyTitle, krsIniKeySortTitle,');
  WriteLn('    krsIniKeyYear, krsIniKeyFileName');
  WriteLn('');
  WriteLn('krsIniKeyDeveloper');
  WriteLn('  ' + krsIniKeyDeveloper);
  WriteLn('');
  WriteLn('Soft');
  WriteLn('  Shared Keys: krsIniKeyID, krsIniKeyTitle, krsIniKeySortTitle,');
  WriteLn('    krsIniKeyYear, krsIniKeyFileName');
  WriteLn('');
  WriteLn('krsIniKeySHA1');
  WriteLn('  ' + krsIniKeySHA1);
  WriteLn('');
  WriteLn('krsIniKeyGroup');
  WriteLn('  ' + krsIniKeyGroup);
  WriteLn('');
  WriteLn('krsIniKeyTranslitTitl');
  WriteLn('  ' + krsIniKeyTranslitTitl);
  WriteLn('');
  WriteLn('krsIniKeyVersion');
  WriteLn('  ' + krsIniKeyVersion);
  WriteLn('');
  WriteLn('krsIniKeyPublisher');
  WriteLn('  ' + krsIniKeyPublisher);
  WriteLn('');
  WriteLn('krsIniKeyZone');
  WriteLn('  ' + krsIniKeyZone);
  WriteLn('');
  WriteLn('krsIniKeyDumpInfo');
  WriteLn('  ' + krsIniKeyDumpInfo);
  WriteLn('');
  WriteLn('krsIniKeyDumpStatus');
  WriteLn('  ' + krsIniKeyDumpStatus);
  WriteLn('');
  WriteLn('krsIniKeyFixed');
  WriteLn('  ' + krsIniKeyFixed);
  WriteLn('');
  WriteLn('krsIniKeyTrainer');
  WriteLn('  ' + krsIniKeyTrainer);
  WriteLn('');
  WriteLn('krsIniKeyTranslation');
  WriteLn('  ' + krsIniKeyTranslation);
  WriteLn('');
  WriteLn('krsIniKeyPirate');
  WriteLn('  ' + krsIniKeyPirate);
  WriteLn('');
  WriteLn('krsIniKeyCracked');
  WriteLn('  ' + krsIniKeyCracked);
  WriteLn('');
  WriteLn('krsIniKeyModified');
  WriteLn('  ' + krsIniKeyModified);
  WriteLn('');
  WriteLn('krsIniKeyHack');
  WriteLn('  ' + krsIniKeyHack);
  WriteLn('');
  WriteLn('krsIniKeyFolder');
  WriteLn('  ' + krsIniKeyFolder);
  WriteLn('');
  WriteLn('Playing Stats');
  WriteLn('');
  WriteLn('krsIniKeyPlayingTime');
  WriteLn('  ' + krsIniKeyPlayingTime);
  WriteLn('');
  WriteLn('krsIniKeyTimesPlayed');
  WriteLn('  ' + krsIniKeyTimesPlayed);
  WriteLn('');
  WriteLn('krsIniKeyLastTime');
  WriteLn('  ' + krsIniKeyLastTime);
  WriteLn('');
  WriteLn('Enumerated, sets, etc.');
  WriteLn('----------------------');
  WriteLn('Constants for krsIniKeySoftExportKey');
  WriteLn('');
  WriteLn('krsSEKCRC32');
  WriteLn('  ' + krsSEKCRC32);
  WriteLn('');
  WriteLn('krsSEKSHA1');
  WriteLn('  ' + krsSEKSHA1);
  WriteLn('');
  WriteLn('krsSEKFileName');
  WriteLn('  ' + krsSEKFileName);
  WriteLn('');
  WriteLn('krsSEKCustom');
  WriteLn('  ' + krsSEKCustom);
  WriteLn('');
  WriteLn('Constant for DumpStatus, fixed (for example, icon filenames)');
  WriteLn('');
  WriteLn('krsEDSVerified');
  WriteLn('  ' + krsEDSVerified);
  WriteLn('');
  WriteLn('krsEDSGood');
  WriteLn('  ' + krsEDSGood);
  WriteLn('');
  WriteLn('krsEDSAlternate');
  WriteLn('  ' + krsEDSAlternate);
  WriteLn('');
  WriteLn('krsEDSOverDump');
  WriteLn('  ' + krsEDSOverDump);
  WriteLn('');
  WriteLn('krsEDSBadDump');
  WriteLn('  ' + krsEDSBadDump);
  WriteLn('');
  WriteLn('krsEDSUnderDump');
  WriteLn('  ' + krsEDSUnderDump);
  WriteLn('');
  WriteLn('');
  WriteLn('RESOURCE STRINGS');
  WriteLn('================');
  WriteLn('');
  WriteLn('Misc');
  WriteLn('----');
  WriteLn('');
  WriteLn('rsNever');
  WriteLn('  ' + rsNever);
  WriteLn('');
  WriteLn('rsFileAlreadyAdded');
  WriteLn('  ' + rsFileAlreadyAdded);
  WriteLn('');
  WriteLn('Lists');
  WriteLn('-----');
  WriteLn('');
  WriteLn('rsLoadingSystemList');
  WriteLn('  ' + rsLoadingSystemList);
  WriteLn('');
  WriteLn('rsImportingSystemList');
  WriteLn('  ' + rsImportingSystemList);
  WriteLn('');
  WriteLn('rsSavingSystemList');
  WriteLn('  ' + rsSavingSystemList);
  WriteLn('');
  WriteLn('rsLoadingGroupList');
  WriteLn('  ' + rsLoadingGroupList);
  WriteLn('');
  WriteLn('rsImportingGroupList');
  WriteLn('  ' + rsImportingGroupList);
  WriteLn('');
  WriteLn('rsSavingGroupList');
  WriteLn('  ' + rsSavingGroupList);
  WriteLn('');
  WriteLn('rsLoadingSoftList');
  WriteLn('  ' + rsLoadingSoftList);
  WriteLn('');
  WriteLn('rsImportingSoftList');
  WriteLn('  ' + rsImportingSoftList);
  WriteLn('');
  WriteLn('rsSavingSoftList');
  WriteLn('  ' + rsSavingSoftList);
  WriteLn('');
  WriteLn('File mask descriptions');
  WriteLn('----------------------');
  WriteLn('');
  WriteLn('rsFileMaskDescGroup');
  WriteLn('  ' + rsFileMaskDescGroup);
  WriteLn('');
  WriteLn('rsFileMaskDescSoft');
  WriteLn('  ' + rsFileMaskDescSoft);
  WriteLn('');
  WriteLn('rsFileMaskDescINI');
  WriteLn('  ' + rsFileMaskDescINI);
  WriteLn('');
  WriteLn('rsFileMaskDescScript');
  WriteLn('  ' + rsFileMaskDescScript);
  WriteLn('');
  WriteLn('rsFileMaskDescTXT');
  WriteLn('  ' + rsFileMaskDescTXT);
  WriteLn('');
  WriteLn('Strings for DumpStatus, translatable');
  WriteLn('------------------------------------');
  WriteLn('');
  WriteLn('rsEDSVerified');
  WriteLn('  ' + rsEDSVerified);
  WriteLn('');
  WriteLn('rsEDSGood');
  WriteLn('  ' + rsEDSGood);
  WriteLn('');
  WriteLn('rsEDSAlternate');
  WriteLn('  ' + rsEDSAlternate);
  WriteLn('');
  WriteLn('rsEDSOverDump');
  WriteLn('  ' + rsEDSOverDump);
  WriteLn('');
  WriteLn('rsEDSBadDump');
  WriteLn('  ' + rsEDSBadDump);
  WriteLn('');
  WriteLn('rsEDSUnderDump');
  WriteLn('  ' + rsEDSUnderDump);
  WriteLn('');
  WriteLn('');
  WriteLn('TYPES');
  WriteLn('=====');
  WriteLn('');
  WriteLn('TEmutecaSoftExportKey = ' +
    '(TEFKSHA1, TEFKCRC32, TEFKFileName, TEFKCustom)');
  WriteLn('');
  WriteLn('TEmutecaDumpStatus = ' +
    '(edsVerified, edsGood, edsAlternate, edsOverDump, edsBadDump,' + 
	' edsUnderDump)');
  WriteLn('');
  WriteLn('TEmutecaProgressCallBack = ' +
    'function(const Title, Info1, Info2: string; const Value, ' +
	'MaxValue: int64) : boolean');
  WriteLn('');
  WriteLn('');
  WriteLn('FUNCTION / PROCEDURES');
  WriteLn('=====================');
  WriteLn('');
  WriteLn('function SoftExportKey2StrK(aSOK: TEmutecaSoftExportKey): string');
  WriteLn('function Str2SoftExportKey(aString: string): TEmutecaSoftExportKey');
  WriteLn('  Some explanation...');
  WriteLn('    SoftExportKey2StrK(Str2SoftExportKey(krsSEKFileName)) -> ' +
    SoftExportKey2StrK(Str2SoftExportKey(krsSEKFileName)));
  WriteLn('');
  WriteLn('');
  WriteLn('function Key2DumpSt(aString: string): TEmutecaDumpStatus');
  WriteLn('function DumpSt2Key(aEDS: TEmutecaDumpStatus): string');
  WriteLn('function DumpSt2Str(aEDS: TEmutecaDumpStatus): string');
  WriteLn('function DumpSt2StrK(aEDS: TEmutecaDumpStatus): string');
  WriteLn('  Some explanation...');
  WriteLn('    DumpSt2Key(Key2DumpSt(krsEDSAlternate)) -> ' +
    DumpSt2Key(Key2DumpSt(krsEDSAlternate)));
  WriteLn('    DumpSt2Str(Key2DumpSt(krsEDSAlternate)) -> ' +
    DumpSt2Str(Key2DumpSt(krsEDSAlternate)));
  WriteLn('    DumpSt2StrK(Key2DumpSt(krsEDSAlternate)) -> ' +
    DumpSt2StrK(Key2DumpSt(krsEDSAlternate)));
  WriteLn('');
  WriteLn('procedure EmuTKSearchAllRelatedFiles(OutFileList: TStrings; ' +
    'aFolder: string; aFileName: string; Extensions: TStrings; ' +
    'SearchInComp: boolean; DecompressFolder: string)');
  WriteLn('  Some explanation...');
  WriteLn('    Some example...');
  WriteLn('');
  WriteLn('function EmuTKSearchFirstRelatedFile(aFolder: string; ' +
    'aFileName: string; Extensions: TStrings; SearchInComp: boolean; ' +
    'AutoDecompress: boolean; DecompressFolder: string): string');
  WriteLn('  Some explanation...');
  WriteLn('    Some example...');
  WriteLn('');
  WriteLn('procedure EmuTKSearchAllFilesByNameExtCT(aFileList: TStrings; ' +
    'aBaseFileName: string; aExtList: string)');
  WriteLn('  Some explanation...');
  WriteLn('    Some example...');
  WriteLn('');
  WriteLn('procedure EmuTKSearchAllFilesByNameExtSL(aFileList: TStrings; ' +
    'aBaseFileName: string; aExtList: TStrings)');
  WriteLn('  Some explanation...');
  WriteLn('    Some example...');
  WriteLn('');
  WriteLn('function EmuTKSearchFirstFileByNameExtCT(aBaseFileName: string; ' +
    'aExtList: string): string');
  WriteLn('  Some explanation...');
  WriteLn('    Some example...');
  WriteLn('');
  WriteLn('function EmuTKSearchFirstFileByNameExtSL(aBaseFileName: string; ' +
    'aExtList: TStrings): string');
  WriteLn('  Some explanation...');
  WriteLn('    Some example...');
  WriteLn('');
  WriteLn('DONE');
  WriteLn('====');

end.
