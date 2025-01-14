unit uaEmutecaCustomEmu;
{< caEmutecaEmulator abstract class unit.

  This file is part of Emuteca Core.

  Copyright (C) 2006-2024 Chixpy
}
{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, FileUtil, StrUtils, LazUTF8, LazFileUtils,
  IniFiles, LCLIntf,
  // CHX units
  uCHXStrUtils, uCHXExecute,
  // CHX abstracts
  uaCHXStorable,
  // Emuteca common
  uEmutecaConst,
  // Emuteca clases
  ucEmutecaPlayingStats;

const

  // Keys for command line parameters for emulators
  // ----------------------------------------------
  // Working folders
  krsEmutecaEmuDirKey = '%EMUDIR%';
  {< Emulator's directory key. }
  krsEmutecaROMDirKey = '%ROMDIR%';
  {< ROM's directory key. }
  krsEmutecaCurrentDirKey = '%CURRENTDIR%';
  {< Current directory key. }

  // Parameters
  krsEmutecaROMPathKey = '%ROM%';
  {< ROM full path key. }
  krsEmutecaROMPathNoExtKey = '%ROMNOEXT%';
  {< ROM filename without extension. }
  //kEmutecaROMDirKey = '%ROMDIR%'; <- Same as Working Folders
  //{< ROM's directory key. }
  krsEmutecaROMLastFolderKey = '%ROMLASTDIR%';
  {< ROM's last folder key. }
  krsEmutecaROMFileNameKey = '%ROMNAME%';
  {< ROM filename only key. }
  krsEmutecaROMFileNameNoExtKey = '%ROMNAMENOEXT%';
  {< ROM filename only without extension key. }
  krsEmutecaROMFileExtKey = '%ROMEXT%';
  {< ROM file extension key. }
  krsEmutecaROMSysIDKey = '%SYSID%';
  {< Extra parameter from System.CoreID key. }
  krsEmutecaROMExtensionParamKey = '%EXTPARAM%';
  {< Extra parameter from System.CoreID key. }
  krsEmutecaROMExtraParamKey = '%EXTRA%';
  {< Extra parameters from Software.ExtraParameter key. }

type
  { caEmutecaCustomEmu class.

    Stores all basic info of an emulator. }
  caEmutecaCustomEmu = class(caCHXStorableIni)
  private
    FExtensionParamFormat : TStringList;
    FExeFile : string;
    FExtraParamFormat : TStringList;
    FFileExt : TStringList;
    FIconFile : string;
    FID : string;
    FInfoFile : string;
    FStats : cEmutecaPlayingStats;
    FWorkingFolder : string;
    procedure SetExeFile(aValue : string);
    procedure SetIconFile(aValue : string);
    procedure SetID(aValue : string);
    procedure SetInfoFile(aValue : string);
    procedure SetWorkingFolder(aValue : string);

  protected
    procedure DoSaveToIni(aIniFile : TMemIniFile; ExportMode : Boolean); virtual;
    {< Saves emulator config to ini file. }

  public
    // Properties with empty getter and setter

    {property} Enabled : Boolean;
    {< Is it enabled? }

    {property} Title : string;
    {< Emulator's name. }

    {property} Developer : string;
    {< Developers. }
    {property} WebPage : string;
    {< WebPage. }

    {property} Parameters : string;
    {< Parameters used with the executable.

       Tip: Following key items can be used:

       @definitionList(
         @itemLabel(%ROM%)
         @item(Full ROM path.)
         @itemLabel(%ROMNOEXT%)
         @item(Full ROM path without extension. Usefull to change file
           extension.)
         @itemLabel(%ROMDIR%)
         @item(ROM's folder.)
         @itemLabel(%ROMLASTDIR%)
         @item(ROM's last folder name.)
         @itemLabel(%ROMNAME%)
         @item(ROM filename with extension, but without folder.)
         @itemLabel(%ROMNAMENOEXT%)
         @item(Only ROM filename, without folder or extension.
           Usefull for MAME.)
         @itemLabel(%ROMEXT%)
         @item(Only ROM extension.)
         @itemLabel(%SYSID%)
         @item(ID for core in multisystem emulators.)
         @itemLabel(%EXTRA%)
         @item(Extra parameters from software ExtraParameter property.)
       )
    }

    {property} CoreIDKey : string;
    {< Key to search core parameter in system. }
    {property} CoreIDParamFormat : string;
    {< String for %SYSID% parameter. }

    {property} ExitCode : Integer;
    {< Code returned by emulator in usual conditions. Emuteca will not show
         an error message if this code is returned. }

    property ID : string read FID write SetID;
    {< ID of the Emulator. }

    property ExeFile : string read FExeFile write SetExeFile;
    {< Path to executable. }
    property WorkingFolder : string read FWorkingFolder write SetWorkingFolder;
    {< Working folder. Emuteca will change to that folder before launching the
         emulator. Following key items can be used:

       @definitionList(
         @itemLabel(%EMUDIR% (default))
         @item(Change to emulator's folder.)
         @itemLabel(%ROMDIR%)
         @item(Change to ROM's folder.)
         @itemLabel(%CURRENTDIR%)
         @item(Use current folder.)
       )
    }

    property ExtensionParamFormat : TStringList read FExtensionParamFormat;
    {< Strings to encapsulate %EXTPARAM% parameters from extension of ROM.
    }
    property ExtraParamFormat : TStringList read FExtraParamFormat;
    {< Strings to encapsulate %EXTRA% parameters from software.
    }

    property FileExt : TStringList read FFileExt;
    {< Extensions used by the emulator.

    Only one extension in every string, without dot.
    }

    property IconFile : string read FIconFile write SetIconFile;
    {< Icon for emulator. }
    property InfoFile : string read FInfoFile write SetInfoFile;
    {< Text info file for emulator. }

    property Stats : cEmutecaPlayingStats read FStats;
    {< Statistics }

    function CompareID(aID : string) : Integer; inline;
    {< Compares Emulator.ID with aID. It's case insensitive. }
    function MatchID(aID : string) : Boolean; inline;
    {< Returns @true if aID matchs Emulator.ID. }

    function Execute(GameFile : string; ExtraParameters : TStringList;
      SysID : string) : Integer;
    {< Executes emulator with a game file.

       @param(GameFile is a string with game filename. Used with Parameters
          property. )
       @param(ExtraParameters is a string list with the extra parameters values
         stored with game. )
       @param(SysID is a string with ID of system. Used with multicore
         emulators. )
       @returns(Integer with emulator exit code. 0 if matches
         Emulator.ExitCode value. -1 if Something is wrong before launch. )
  }
    function ExecuteAlone : Integer;
    {< Executes emulator without parameters. }

    procedure LoadFromIni(aIniFile : TMemIniFile); override;
    procedure SaveToIni(aIniFile : TMemIniFile); override;
    procedure ImportFromIni(aIniFile : TMemIniFile); virtual;
    procedure ExportToIni(aIniFile : TMemIniFile); virtual;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ caEmutecaCustomEmu }

procedure caEmutecaCustomEmu.SetID(aValue : string);
begin
  aValue := UTF8Trim(aValue);
  if FID = aValue then
    Exit;
  FID := aValue;

  FPONotifyObservers(Self, ooChange, nil);
end;

procedure caEmutecaCustomEmu.SetInfoFile(aValue : string);
begin
  FInfoFile := SetAsFile(aValue);
end;

procedure caEmutecaCustomEmu.SetWorkingFolder(aValue : string);
begin
  FWorkingFolder := SetAsFolder(aValue);
end;

procedure caEmutecaCustomEmu.DoSaveToIni(aIniFile : TMemIniFile;
  ExportMode : Boolean);
begin
  if not assigned(aIniFile) then
    Exit;

  aIniFile.WriteString(ID, krsIniKeyTitle, Title);

  aIniFile.WriteString(ID, krsIniKeyWorkingFolder, WorkingFolder);
  aIniFile.WriteString(ID, krsIniKeyParameters, Parameters);
  aIniFile.WriteString(ID, krsIniKeyExtensionParamFmt,
    ExtensionParamFormat.CommaText);

  aIniFile.WriteString(ID, krsIniKeyExtraParamFmt,
    ExtraParamFormat.CommaText);
  aIniFile.WriteString(ID, krsIniKeyCoreIDKey, CoreIDKey);
  aIniFile.WriteString(ID, krsIniKeyCoreIDParamFmt, CoreIDParamFormat);
  aIniFile.WriteString(ID, krsIniKeyExtensions, FileExt.CommaText);
  aIniFile.WriteInteger(ID, krsIniKeyExitCode, ExitCode);

  aIniFile.WriteString(ID, krsIniKeyDeveloper, Developer);
  aIniFile.WriteString(ID, krsIniKeyWebPage, WebPage);

  if ExportMode then
  begin
    aIniFile.DeleteKey(ID, krsIniKeyExeFile);
    aIniFile.DeleteKey(ID, krsIniKeyEnabled);
    aIniFile.DeleteKey(ID, krsIniKeyIcon);
    aIniFile.DeleteKey(ID, krsIniKeyImage);
    aIniFile.DeleteKey(ID, krsIniKeyInfoFile);
  end
  else
  begin
    aIniFile.WriteString(ID, krsIniKeyExeFile, ExeFile);
    aIniFile.WriteBool(ID, krsIniKeyEnabled, Enabled);
    aIniFile.WriteString(ID, krsIniKeyIcon, IconFile);
    aIniFile.WriteString(ID, krsIniKeyInfoFile, InfoFile);
  end;

  Stats.WriteToIni(aIniFile, ID, ExportMode);
end;

procedure caEmutecaCustomEmu.SetExeFile(aValue : string);
begin
  FExeFile := SetAsFile(aValue);
end;

procedure caEmutecaCustomEmu.SetIconFile(aValue : string);
begin
  FIconFile := SetAsFile(aValue);
end;

constructor caEmutecaCustomEmu.Create;
begin
  inherited Create;

  FStats := cEmutecaPlayingStats.Create;

  WorkingFolder := krsEmutecaEmuDirKey;
  Parameters := '"' + krsEmutecaROMPathKey + '"';

  FFileExt := TStringList.Create;

  FExtensionParamFormat := TStringList.Create;
  ExtensionParamFormat.CaseSensitive := False;
  ExtensionParamFormat.Sorted := True;
  ExtensionParamFormat.NameValueSeparator := '=';

  FExtraParamFormat := TStringList.Create;
end;


destructor caEmutecaCustomEmu.Destroy;
begin
  ExtensionParamFormat.Free;
  ExtraParamFormat.Free;
  FileExt.Free;
  Stats.Free;

  inherited Destroy;
end;

function caEmutecaCustomEmu.CompareID(aID : string) : Integer;
begin
  Result := UTF8CompareText(ID, aID);
end;

function caEmutecaCustomEmu.MatchID(aID : string) : Boolean;
begin
  Result := CompareID(aID) = 0;
end;

function caEmutecaCustomEmu.Execute(GameFile : string;
  ExtraParameters : TStringList; SysID : string) : Integer;
var
  i, j : Integer;
  ActualWorkDir, sOutput, sError : string;
  ActualParam, Extra, TempExtra : string;
  aSL : TStringList;
begin
  Result := -1;

  // PARSING COMMAND LINE
  // --------------------

  // Some emulators don't accept linux style in parameters...
  GameFile := SysPath(GameFile);

  // If GameFile is relative to Emuteca directory,
  //   absolute path is better right now.
  if not FilenameIsAbsolute(GameFile) then
    GameFile := CreateAbsoluteSearchPath(GameFile, GetCurrentDirUTF8);

  // Working directory
  ActualWorkDir := WorkingFolder;
  ActualWorkDir := AnsiReplaceText(ActualWorkDir, krsEmutecaEmuDirKey,
    ExtractFileDir(ExeFile));
  ActualWorkDir := AnsiReplaceText(ActualWorkDir, krsEmutecaROMDirKey,
    ExtractFileDir(GameFile));
  ActualWorkDir := AnsiReplaceText(ActualWorkDir,
    krsEmutecaCurrentDirKey, GetCurrentDirUTF8);
  ActualWorkDir := SysPath(ActualWorkDir);

  // Parameters
  ActualParam := Parameters;

  // Setting SysID parameter
  Extra := AnsiReplaceText(CoreIDParamFormat, krsEmutecaROMSysIDKey, SysID);
  ActualParam := AnsiReplaceText(ActualParam, krsEmutecaROMSysIDKey,
    Trim(Extra));

  // Setting Extension specific parameters
  // ext1,ext2,extX=/param "%ROM" blabla
  Extra := '';
  TempExtra := TrimLeftSet(ExtractFileExt(GameFile), ['.']);
  TempExtra := ExtensionParamFormat.Delimiter + TempExtra +
    ExtensionParamFormat.Delimiter;

  j := 0;
  while j < ExtensionParamFormat.Count do
  begin
    if AnsiContainsText(ExtensionParamFormat.Delimiter +
      ExtensionParamFormat.Names[j] + ExtensionParamFormat.Delimiter,
      TempExtra) then
      Extra := Extra + ExtensionParamFormat.ValueFromIndex[j] + ' ';
    Inc(j);
  end;
  if Extra = '' then
    Extra := ExtensionParamFormat.Values['*'];
  ActualParam := AnsiReplaceText(ActualParam, krsEmutecaROMExtensionParamKey,
    Trim(Extra));

  // Setting Extra parameters from software
  Extra := '';
  if assigned(ExtraParameters) and (ExtraParameters.Count > 0) then
  begin
    j := 0;
    while j < ExtraParamFormat.Count do
    begin
      TempExtra := ExtraParamFormat[j];

      i := 0;
      while i < ExtraParameters.Count do
      begin
        if ExtraParameters[i] <> '' then
          TempExtra := AnsiReplaceText(TempExtra, '%' +
            IntToStr(i) + '%', ExtraParameters[i]);
        Inc(i);
      end;

      // Nothing is changed, don't add extra parameter
      if TempExtra = ExtraParamFormat[j] then
        TempExtra := ''
      else
        TempExtra := Trim(TempExtra);

      if TempExtra <> '' then
        Extra := Extra + ' ' + Trim(TempExtra);

      Inc(j);
    end;
  end;
  ActualParam := AnsiReplaceText(ActualParam, krsEmutecaROMExtraParamKey,
    Trim(Extra));

  // Changing common parameters
  ActualParam := AnsiReplaceText(ActualParam, krsEmutecaROMPathKey, GameFile);
  ActualParam := AnsiReplaceText(ActualParam, krsEmutecaROMPathNoExtKey,
    ExtractFileNameWithoutExt(GameFile));
  ActualParam := AnsiReplaceText(ActualParam, krsEmutecaROMDirKey,
    ExtractFileDir(GameFile));
  ActualParam := AnsiReplaceText(ActualParam, krsEmutecaROMLastFolderKey,
    ExtractFileName(ExtractFileDir(GameFile)));
  ActualParam := AnsiReplaceText(ActualParam, krsEmutecaEmuDirKey,
    ExtractFileDir(ExeFile));
  ActualParam := AnsiReplaceText(ActualParam, krsEmutecaROMFileNameKey,
    ExtractFileName(GameFile));
  ActualParam := AnsiReplaceText(ActualParam, krsEmutecaROMFileNameNoExtKey,
    ExtractFileNameWithoutExt(ExtractFileName(GameFile)));
  ActualParam := AnsiReplaceText(ActualParam, krsEmutecaROMFileExtKey,
    ExtractFileExt(GameFile));
  ActualParam := Trim(ActualParam);

  // GO, GO, GO!!
  // ------------
  sOutput := '';
  sError := '';

  // Hack for run system executables ;P
  // ... and try to open with default player
  if ExeFile = '' then
  begin
    if SupportedExtCT(ActualParam, 'exe,com,bat,cmd') then
      ExecuteCMDArray(ActualWorkDir, ActualParam, [], sOutput,
        sError, Result)
    else
      // This don't keep statistics because don't wait until closed
      //   and file is deleted if it's extracted...
      OpenDocument(ActualParam);
  end
  else
    ExecuteCMDString(ActualWorkDir, ExeFile, ActualParam, sOutput,
      sError, Result);

  // TODO: Make this configurable and open from GUI.
  aSL := TStringList.Create;
  aSL.Text := sError;
  if aSL.Count > 0 then
    aSL.SaveToFile('Error.txt');
  aSL.Text := sOutput;
  if aSL.Count > 0 then
    aSL.SaveToFile('Output.txt');
  FreeAndNil(aSL);

  { #done -oChixpy :

    If normal Exit Code <> 0, compare with it and set to 0.

    So, this way 0 always is the correct exit of the program,
        and Managers don't care about wich is the actual code
  }
  if Result = ExitCode then
    Result := 0;
end;

function caEmutecaCustomEmu.ExecuteAlone : Integer;
var
  TempDir : string;
  sError, sOutput : string;
begin
  Result := -1;

  if ExeFile = '' then
    Exit;

  // Changing working folder
  TempDir := SysPath(WorkingFolder);
  TempDir := AnsiReplaceText(TempDir, krsEmutecaEmuDirKey,
    ExtractFileDir(ExeFile));
  // Here ROMDIR is changed to EmuDir too
  TempDir := AnsiReplaceText(TempDir, krsEmutecaROMDirKey,
    ExtractFileDir(ExeFile));
  TempDir := AnsiReplaceText(TempDir, krsEmutecaCurrentDirKey,
    GetCurrentDirUTF8);

  ExecuteCMDArray(TempDir, ExeFile, [], sError, sOutput, Result);

  if Result = ExitCode then
    Result := 0;
end;

procedure caEmutecaCustomEmu.LoadFromIni(aIniFile : TMemIniFile);
begin
  if not assigned(aIniFile) then
    Exit;

  Enabled := aIniFile.ReadBool(ID, krsIniKeyEnabled, Enabled);

  Title := aIniFile.ReadString(ID, krsIniKeyTitle, Title);

  ExeFile := aIniFile.ReadString(ID, krsIniKeyExeFile, ExeFile);
  WorkingFolder := aIniFile.ReadString(ID, krsIniKeyWorkingFolder,
    WorkingFolder);
  Parameters := aIniFile.ReadString(ID, krsIniKeyParameters, Parameters);
  ExtensionParamFormat.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyExtensionParamFmt,
    ExtensionParamFormat.CommaText);
  ExtraParamFormat.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyExtraParamFmt,
    ExtraParamFormat.CommaText);

  CoreIDKey := aIniFile.ReadString(ID, krsIniKeyCoreIDKey, CoreIDKey);
  CoreIDParamFormat := aIniFile.ReadString(ID, krsIniKeyCoreIDParamFmt,
    CoreIDParamFormat);

  FileExt.CommaText := aIniFile.ReadString(ID, krsIniKeyExtensions,
    FileExt.CommaText);
  ExitCode := aIniFile.ReadInteger(ID, krsIniKeyExitCode, ExitCode);

  Developer := aIniFile.ReadString(ID, krsIniKeyDeveloper, Developer);
  WebPage := aIniFile.ReadString(ID, krsIniKeyWebPage, WebPage);

  IconFile := aIniFile.ReadString(ID, krsIniKeyIcon, IconFile);
  InfoFile := aIniFile.ReadString(ID, krsIniKeyInfoFile, InfoFile);

  Stats.LoadFromIni(aIniFile, ID);
end;

procedure caEmutecaCustomEmu.ExportToIni(aIniFile : TMemIniFile);
begin
  DoSaveToIni(aIniFile, True);
end;

procedure caEmutecaCustomEmu.SaveToIni(aIniFile : TMemIniFile);
begin
  DoSaveToIni(aIniFile, False);
end;

procedure caEmutecaCustomEmu.ImportFromIni(aIniFile : TMemIniFile);
begin
  // Simply load from file, when exporting user data is removed
  LoadFromIni(aIniFile);
end;

initialization
  RegisterClass(caEmutecaCustomEmu);

finalization
  UnRegisterClass(caEmutecaCustomEmu);
end.
{
This source is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3 of the License, or (at your option)
any later version.

This code is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

A copy of the GNU General Public License is available on the World Wide Web
at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
MA 02111-1307, USA.
}
