{ This file is part of Emuteca

  Copyright (C) 2006-2018 Chixpy

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

{ cEmutecaEmulator unit. }
unit ucEmutecaEmulator;

{$mode objfpc}{$H+}

interface

uses  Classes, SysUtils, FileUtil, StrUtils, LazUTF8, LazFileUtils,
  IniFiles, lclintf,
  // CHX units
  uCHXStrUtils,
  // CHX abstracts
  uaCHXStorable,
  // Emuteca common
  uEmutecaCommon,
  // Emuteca clases
  ucEmutecaPlayingStats;

const

  // Keys for command line parameters for emulators
  // ----------------------------------------------
  // Working folders
  kEmutecaEmuDirKey = '%EMUDIR%';
  {< Emulator's directory key. }
  kEmutecaROMDirKey = '%ROMDIR%';
  {< ROM's directory key. }
  kEmutecaCurrentDirKey = '%CURRENTDIR%';
  {< Current directory key. }

  // Parameters
  //kEmutecaROMDirKey = '%ROMDIR%'; <- Same as Working Folders
  kEmutecaROMPathKey = '%ROM%';
  {< ROM full path. }
  kEmutecaROMFileNameKey = '%ROMNAME%';
  {< ROM filename. }
  kEmutecaROMFileNameNoExtKey = '%ROMNAMENOEXT%';
  {< ROM filename without extension. }
  kEmutecaROMFileExtKey = '%ROMEXT%';
  {< ROM file extension. }
  kEmutecaROMExtraParamKey = '%EXTRA%';
{< Extra parameter from Software.ExtraParameter }

type
  { cEmutecaEmulator class.

    Stores all basic info of an emulator. }
  cEmutecaEmulator = class(caCHXStorableIni)
  private
    FDeveloper: string;
    FTitle: string;
    FEnabled: boolean;
    FExeFile: string;
    FExitCode: integer;
    FExtraParamFormat: TStringList;
    FFileExt: TStringList;
    FIcon: string;
    FID: string;
    FImage: string;
    FInfoFile: string;
    FParameters: string;
    FStats: cEmutecaPlayingStats;
    FWebPage: string;
    FWorkingFolder: string;
    procedure SetDeveloper(AValue: string);
    procedure SetTitle(AValue: string);
    procedure SetEnabled(AValue: boolean);
    procedure SetExeFile(AValue: string);
    procedure SetExitCode(AValue: integer);
    procedure SetFileExt(AValue: TStringList);
    procedure SetIcon(AValue: string);
    procedure SetID(AValue: string);
    procedure SetImage(AValue: string);
    procedure SetInfoFile(AValue: string);
    procedure SetParameters(AValue: string);
    procedure SetWebPage(AValue: string);
    procedure SetWorkingFolder(AValue: string);

  protected
    procedure DoSaveToIni(aIniFile: TMemIniFile; ExportMode: boolean); virtual;

  public
    function CompareID(aID: string): integer;
    function MatchID(aID: string): boolean;

    function Execute(GameFile: string; ExtraParameters: TStringList): integer;
    function ExecuteAlone: integer;

    procedure LoadFromIni(aIniFile: TMemIniFile); override;
    procedure SaveToIni(aIniFile: TMemIniFile); override;
    procedure ImportFromIni(aIniFile: TMemIniFile); virtual;
    procedure ExportToIni(aIniFile: TMemIniFile); virtual;

    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

  published
    property ID: string read FID write SetID;
    {< ID of the Emulator. }

    property Enabled: boolean read FEnabled write SetEnabled;
    {< Is it enabled? }

    property Title: string read FTitle write SetTitle;
    {< Emulator's name. }
    property ExeFile: string read FExeFile write SetExeFile;
    {< Path to executable. }
    property WorkingFolder: string read FWorkingFolder write SetWorkingFolder;
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
    property Parameters: string read FParameters write SetParameters;
    {< Parameters used with the executable.

       Tip: Following key items can be used:

       @definitionList(
         @itemLabel(%ROM%)
         @item(Full ROM path.)
         @itemLabel(%ROMDIR%)
         @item(ROM's folder.)
         @itemLabel(%ROMNAME%)
         @item(ROM filename with extension, but without folder.)
         @itemLabel(%ROMNAMENOEXT%)
         @item(Only ROM filename, without folder or extension.
           Usefull for MAME.)
         @itemLabel(%ROMEXT%)
         @item(Only ROM extension.)
         @itemLabel(%EXTRA%)
         @item(Extra parameters from software ExtraParameter property.)
       )
    }
    property ExtraParamFormat: TStringList read FExtraParamFormat;
    {< Strings to encapsulate %EXTRA% parameters from software.
    }
    property FileExt: TStringList read FFileExt write SetFileExt;
    {< Extensions used by the emulator.

    Only one extension in every string, without dot.
    }

    property ExitCode: integer read FExitCode write SetExitCode;
    {< Code returned by emulator in usual conditions. Emuteca will not show
         an error message if this code is returned. }

    // Additional info data
    // --------------------
    property Developer: string read FDeveloper write SetDeveloper;
    property WebPage: string read FWebPage write SetWebPage;
    property Icon: string read FIcon write SetIcon;
    property Image: string read FImage write SetImage;
    property InfoFile: string read FInfoFile write SetInfoFile;

    // Usage statitics
    // ---------------
    property Stats: cEmutecaPlayingStats read FStats;
  end;

  TEmutecaReturnEmulatorCB = function(aEmulator: cEmutecaEmulator): boolean of
    object;

implementation

{ cEmutecaEmulator }

procedure cEmutecaEmulator.SetID(AValue: string);
begin
  if FID = AValue then
    Exit;
  FID := AValue;

  FPONotifyObservers(Self, ooChange, nil);
end;

procedure cEmutecaEmulator.SetImage(AValue: string);
begin
  if FImage = AValue then
    Exit;
  FImage := AValue;
end;

procedure cEmutecaEmulator.SetInfoFile(AValue: string);
begin
  if FInfoFile = AValue then
    Exit;
  FInfoFile := AValue;
end;

procedure cEmutecaEmulator.SetParameters(AValue: string);
begin
  if FParameters = AValue then
    Exit;
  FParameters := AValue;
end;

procedure cEmutecaEmulator.SetWebPage(AValue: string);
begin
  if FWebPage = AValue then
    Exit;
  FWebPage := AValue;
end;

procedure cEmutecaEmulator.SetWorkingFolder(AValue: string);
begin
  //if FWorkingFolder = AValue then
  //  Exit;
  FWorkingFolder := SetAsFolder(AValue);
end;

procedure cEmutecaEmulator.DoSaveToIni(aIniFile: TMemIniFile;
  ExportMode: boolean);
begin
  if not assigned(aIniFile) then
    Exit;

  aIniFile.WriteString(ID, krsIniKeyTitle, Title);

  aIniFile.WriteString(ID, krsIniKeyWorkingFolder, WorkingFolder);
  aIniFile.WriteString(ID, krsIniKeyParameters, Parameters);
  aIniFile.WriteString(ID, krsIniKeyExtraParamFmt,
    ExtraParamFormat.CommaText);
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
    aIniFile.WriteString(ID, krsIniKeyIcon, Icon);
    aIniFile.WriteString(ID, krsIniKeyImage, Image);
    aIniFile.WriteString(ID, krsIniKeyInfoFile, InfoFile);
  end;

  Stats.WriteToIni(aIniFile, ID, ExportMode);
end;

procedure cEmutecaEmulator.SetEnabled(AValue: boolean);
begin
  if FEnabled = AValue then
    Exit;
  FEnabled := AValue;
end;

procedure cEmutecaEmulator.SetTitle(AValue: string);
begin
  if FTitle = AValue then
    Exit;
  FTitle := AValue;
end;

procedure cEmutecaEmulator.SetDeveloper(AValue: string);
begin
  if FDeveloper = AValue then
    Exit;
  FDeveloper := AValue;
end;

procedure cEmutecaEmulator.SetExeFile(AValue: string);
begin
  FExeFile := SetAsFile(AValue);
end;

procedure cEmutecaEmulator.SetExitCode(AValue: integer);
begin
  if FExitCode = AValue then
    Exit;
  FExitCode := AValue;
end;

procedure cEmutecaEmulator.SetFileExt(AValue: TStringList);
begin
  if FFileExt = AValue then
    Exit;
  FFileExt := AValue;
end;

procedure cEmutecaEmulator.SetIcon(AValue: string);
begin
  if FIcon = AValue then
    Exit;
  FIcon := AValue;
end;

constructor cEmutecaEmulator.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  FStats := cEmutecaPlayingStats.Create(Self);

  WorkingFolder := kEmutecaEmuDirKey;
  Parameters := '"' + kEmutecaROMPathKey + '"';

  FFileExt := TStringList.Create;
  FExtraParamFormat := TStringList.Create;
end;


destructor cEmutecaEmulator.Destroy;
begin
  ExtraParamFormat.Free;
  FileExt.Free;
  Stats.Free;

  inherited Destroy;
end;

function cEmutecaEmulator.CompareID(aID: string): integer;
begin
  Result := UTF8CompareText(ID, aID);
end;

function cEmutecaEmulator.MatchID(aID: string): boolean;
begin
  Result := CompareID(aID) = 0;
end;

function cEmutecaEmulator.Execute(GameFile: string;
  ExtraParameters: TStringList): integer;
var
  i, j: integer;
  CurrFolder: string;
  TempDir: string;
  TempParam, Extra, TempExtra: string;
begin
  CurrFolder := GetCurrentDirUTF8;

  GameFile := SysPath(GameFile);

  // If GameFile is relative to emuteca directory,
  //   absolute path is better right now.
  if not FilenameIsAbsolute(GameFile) then
    GameFile := CreateAbsoluteSearchPath(GameFile, CurrFolder);

  // Changing current directory
  TempDir := SysPath(WorkingFolder);
  TempDir := AnsiReplaceText(TempDir, kEmutecaEmuDirKey,
    ExtractFileDir(ExeFile));
  TempDir := AnsiReplaceText(TempDir, kEmutecaROMDirKey,
    ExtractFileDir(GameFile));
  TempDir := AnsiReplaceText(TempDir, kEmutecaCurrentDirKey,
    ExtractFileDir(CurrFolder));
  TempDir := SetAsFolder(TempDir);
  if TempDir <> '' then
    if DirectoryExistsUTF8(TempDir) then
      ChDir(TempDir);

  // Changing parameters
  TempParam := Parameters;
  TempParam := AnsiReplaceText(TempParam, kEmutecaROMPathKey, GameFile);
  TempParam := AnsiReplaceText(TempParam, kEmutecaROMDirKey,
    ExtractFileDir(GameFile));
  TempParam := AnsiReplaceText(TempParam, kEmutecaROMFileNameKey,
    ExtractFileName(GameFile));
  TempParam := AnsiReplaceText(TempParam, kEmutecaROMFileNameNoExtKey,
    ExtractFileNameWithoutExt(ExtractFileName(GameFile)));
  TempParam := AnsiReplaceText(TempParam, kEmutecaROMFileExtKey,
    ExtractFileExt(GameFile));

  // Extra parameters from software
  if assigned(ExtraParameters) and (ExtraParameters.Count > 0) then
  begin
    Extra := '';

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

    TempParam := AnsiReplaceText(TempParam, kEmutecaROMExtraParamKey,
      Trim(Extra));
  end
  else
    // Removing %EXTRA% from parameters.
    TempParam := AnsiReplaceText(TempParam, kEmutecaROMExtraParamKey, '');

  TempParam := Trim(TempParam);

  try
    // Hack for run system executables ;P
    // ... and try to open with default player
    if ExeFile = '' then
    begin
      { TODO : OpenDocument can execute executables? }
      if SupportedExtCT(TempParam, 'exe,com,bat,cmd') then
        Result := ExecuteProcess(UTF8ToWinCP(TempParam), '')
      else
        // This don't keep statistics because don't wait until closed
        //   and file is deleted if it's extracted.
        OpenDocument(TempParam);
    end
    else
      Result := ExecuteProcess(UTF8ToWinCP(SysPath(ExeFile)),
        UTF8ToWinCP(TempParam));

    // Hack: If normal exit code <> 0, compare and set to 0
    //   So, this way 0 always is the correct exit of the program,
    //     and Managers don't care about wich is the actual code
    if Result = ExitCode then
      Result := 0;

  finally
    ChDir(CurrFolder);
  end;
end;

function cEmutecaEmulator.ExecuteAlone: integer;
var
  CurrFolder: string;
  TempDir: string;
begin
  if ExeFile = '' then
    Exit;

  // Changing current file
  CurrFolder := GetCurrentDirUTF8;
  TempDir := WorkingFolder;
  TempDir := AnsiReplaceText(TempDir, kEmutecaEmuDirKey,
    ExtractFileDir(ExeFile));
  TempDir := AnsiReplaceText(TempDir, kEmutecaROMDirKey,
    ExtractFileDir(ExeFile));
  TempDir := AnsiReplaceText(TempDir, kEmutecaCurrentDirKey,
    ExtractFileDir(CurrFolder));
  if TempDir <> '' then
    ChDir(TempDir);

  try
    Result := SysUtils.ExecuteProcess(UTF8ToSys(ExeFile), '');

    if (ExitCode <> 0) then
      if Result = 0 then
        Result := ExitCode
      else
        Result := 0;

  finally
    ChDir(CurrFolder);
  end;
end;

procedure cEmutecaEmulator.LoadFromIni(aIniFile: TMemIniFile);
begin
  if not assigned(aIniFile) then
    Exit;

  Enabled := aIniFile.ReadBool(ID, krsIniKeyEnabled, Enabled);

  Title := aIniFile.ReadString(ID, krsIniKeyTitle, Title);

  ExeFile := aIniFile.ReadString(ID, krsIniKeyExeFile, ExeFile);
  WorkingFolder := aIniFile.ReadString(ID, krsIniKeyWorkingFolder,
    WorkingFolder);
  Parameters := aIniFile.ReadString(ID, krsIniKeyParameters, Parameters);
  ExtraParamFormat.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyExtraParamFmt,
    ExtraParamFormat.CommaText);
  FileExt.CommaText := aIniFile.ReadString(ID, krsIniKeyExtensions,
    FileExt.CommaText);
  ExitCode := aIniFile.ReadInteger(ID, krsIniKeyExitCode, ExitCode);

  Developer := aIniFile.ReadString(ID, krsIniKeyDeveloper, Developer);
  WebPage := aIniFile.ReadString(ID, krsIniKeyWebPage, WebPage);

  Icon := aIniFile.ReadString(ID, krsIniKeyIcon, Icon);
  Image := aIniFile.ReadString(ID, krsIniKeyImage, Image);
  InfoFile := aIniFile.ReadString(ID, krsIniKeyInfoFile, InfoFile);

  Stats.LoadFromIni(aIniFile, ID);
end;

procedure cEmutecaEmulator.ExportToIni(aIniFile: TMemIniFile);
begin
  DoSaveToIni(aIniFile, True);
end;

procedure cEmutecaEmulator.SaveToIni(aIniFile: TMemIniFile);
begin
  DoSaveToIni(aIniFile, False);
end;

procedure cEmutecaEmulator.ImportFromIni(aIniFile: TMemIniFile);
begin
  // Simply load from file, when exporting user data is removed
  LoadFromIni(aIniFile);
end;

end.
