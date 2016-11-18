{ This file is part of Emuteca

  Copyright (C) 2006-2016 Chixpy

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

{ cSystem unit. }
unit ucEmutecaSystem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, LazFileUtils, LazUTF8, contnrs,
  uCHXStrUtils,
  uEmutecaCommon, uaCHXStorable,
  ucEmutecaPlayingStats;

const
  // Ini file Keys
  // -------------
  krsIniKeyEnabled = 'Enabled';  // TODO: uEmutecaCommon.pas?
  krsIniKeyTitle = 'Title';
  krsIniKeyFileName = 'FileName';
  krsIniKeyExtensions = 'Extensions';
  krsIniKeyBaseFolder = 'BaseFolder';
  krsIniKeyTempFolder = 'TempFolder';
  krsIniKeyMainEmulator = 'MainEmulator';
  krsIniKeyOtherEmulators = 'OtherEmulators';
  krsIniKeyIcon = 'Icon';
  krsIniKeyImage = 'Image';
  krsIniKeyBackImage = 'BackImage';
  krsIniKeyIconFolder = 'IconFolder';
  krsIniKeyImageFolders = 'ImageFolders';
  krsIniKeyImageCaptions = 'ImageCaptions';
  krsIniKeyText = 'Text';
  krsIniKeyTextFolders = 'TextFolders';
  krsIniKeyTextCaptions = 'TextCaptions';
  krsIniKeyGamesKey = 'GamesKey';
  krsIniKeyExtractAll = 'ExtractAll';

resourcestring
  rsLoadingSystemList = 'Loading system list...';
  rsSavingSystemList = 'Saving system list...';
  rsAllSystems = 'All Systems';


type

  TEmutecaFileKey = (TEFKSHA1, TEFKCRC32, TEFKFileName, TEFKCustom);

  { cEmutecaSystem }

  cEmutecaSystem = class(caCHXStorableIni)
  private
    FBackImage: string;
    FBaseFolder: string;
    FEnabled: boolean;
    FExtensions: TStringList;
    FExtractAll: boolean;
    FFileName: string;
    FGameKey: TEmutecaFileKey;
    FIcon: string;
    FIconFolder: string;
    FID: string;
    FImage: string;
    FImageCaptions: TStringList;
    FImageFolders: TStringList;
    FInfoText: string;
    FMainEmulator: string;
    FOtherEmulators: TStringList;
    FStats: cEmutecaPlayingStats;
    FTempFolder: string;
    FTextCaptions: TStringList;
    FTextFolders: TStringList;
    FTitle: string;
    procedure SetBackImage(AValue: string);
    procedure SetBaseFolder(AValue: string);
    procedure SetEnabled(AValue: boolean);
    procedure SetExtractAll(AValue: boolean);
    procedure SetFileName(AValue: string);
    procedure SetGameKey(AValue: TEmutecaFileKey);
    procedure SetIcon(AValue: string);
    procedure SetIconFolder(AValue: string);
    procedure SetID(AValue: string);
    procedure SetImage(AValue: string);
    procedure SetInfoText(AValue: string);
    procedure SetMainEmulator(AValue: string);
    procedure SetStats(AValue: cEmutecaPlayingStats);
    procedure SetTempFolder(AValue: string);
    procedure SetTitle(AValue: string);

  protected
    procedure FixFolderListData(FolderList, CaptionList: TStrings);
    {< Try to fix some incosistences in folders and its captions.

    Who knows if somebody edited the .ini file by hand...
    }

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadFromFileIni(IniFile: TCustomIniFile); override;
    procedure SaveToFileIni(IniFile: TCustomIniFile;
      const ExportMode: boolean); override;

  published

    // Basic Info
    // ----------
    property ID: string read FID write SetID;
    {< ID of the system. }

    property Title: string read FTitle write SetTitle;
    {< Visible name (Usually "%Company%: %Model% %(info)%"}

    property FileName: string read FFileName write SetFileName;
    {< Name used for files }

    property Enabled: boolean read FEnabled write SetEnabled;
    {< Is the system visible }

    property ExtractAll: boolean read FExtractAll write SetExtractAll;
    {< Must all files be extracted from compressed archives? }

    property BaseFolder: string read FBaseFolder write SetBaseFolder;
    {< System base folder

       Used by default to store some data if the file isn't defined
         (System image or text).
    }

    property TempFolder: string read FTempFolder write SetTempFolder;
    {< Temp folder for decompress Software, it's recommended leave it empty
         so Emuteca will use OS Temp folder.

       Some cases of use it:
       @unorderedList(
         @item(File must extracted to a specific folder. So emulator
           can recognize it.)
         @item(Emulator can't run from command line and you must browse to the
           file with the emulator... :-@ )
         @item(Lazy testing... >_<U )
       )
     }

    // Emulator related
    // ----------------
    property MainEmulator: string read FMainEmulator write SetMainEmulator;
    {< Main emulator ID. }
    property OtherEmulators: TStringList read FOtherEmulators;
    {< Ids of other emulators for the system. }

    // Images
    // ------
    property Icon: string read FIcon write SetIcon;
    {< Path to the icon of the system. }
    property Image: string read FImage write SetImage;
    {< Path to image of the system. }
    property BackImage: string read FBackImage write SetBackImage;
    {< Image used for as background. }

    property IconFolder: string read FIconFolder write SetIconFolder;
    {< Folder for the icons of the games. }
    property ImageFolders: TStringList read FImageFolders;
    {< Folders for the game images. }
    property ImageCaptions: TStringList read FImageCaptions;
    {< Captions for the folders of game's images. }

    // Texts
    // -----
    property InfoText: string read FInfoText write SetInfoText;
    {< Path to text file of the system. }

    property TextFolders: TStringList read FTextFolders;
    {< Folders for game texts. }
    property TextCaptions: TStringList read FTextCaptions;
    {< Captions for the folders of game's texts. }

    // Import
    // ------
    property GameKey: TEmutecaFileKey read FGameKey write SetGameKey;
    {< Default key (CRC/SHA) to be used as game identifiers
       (when importing/exporting data). }
    property Extensions: TStringList read FExtensions;
    {< Extensions used by the system.

    Only one extension in every string, without dot.
    }

    // Usage statitics
    // ---------------
    property Stats: cEmutecaPlayingStats read FStats write SetStats;
  end;

  // After many test with generics implementing Observer...Keep it simple
  cEmutecaSystemList = TComponentList;

  TEmutecaReturnSystemCB = function(aSystem: cEmutecaSystem): boolean of
    object;

{< For CallBack functions }

function EmutecaFileKey2Str(aEFK: TEmutecaFileKey): string;
function Str2EmutecaFileKey(aString: string): TEmutecaFileKey;


implementation

function EmutecaFileKey2Str(aEFK: TEmutecaFileKey): string;
begin
  case aEFK of
    TEFKCRC32: Result := krsCRC32;
    TEFKSHA1: Result := krsSHA1;
    TEFKCustom: Result := krsCustom;
    TEFKFileName: Result := krsFileName;
    else  // SHA1 by default
      Result := krsSHA1;
  end;
end;

function Str2EmutecaFileKey(aString: string): TEmutecaFileKey;
begin

  // In Emuteca <= 0.7, True => CRC32 / False => FileName
  aString := UTF8UpperCase(aString);

  // I don't like this "else if" format but it's clearer...
  if (aString = UTF8UpperCase(krsCRC32)) or
    (StrToBoolDef(aString, False)) then
    Result := TEFKCRC32
  else if (aString = UTF8UpperCase(krsFileName)) or
    (not StrToBoolDef(aString, True)) then
    Result := TEFKFileName
  else if (aString = UTF8UpperCase(krsSHA1)) then
    Result := TEFKSHA1
  else if (aString = UTF8UpperCase(krsCustom)) then
    Result := TEFKCustom
  else // Default
    Result := TEFKSHA1;
end;

{ cEmutecaSystem }

procedure cEmutecaSystem.LoadFromFileIni(IniFile: TCustomIniFile);
begin
  if IniFile = nil then
    Exit;

  // Basic data
  Title := IniFile.ReadString(ID, krsIniKeyTitle, Title);

  FileName := IniFile.ReadString(ID, krsIniKeyFileName, FileName);
  if FileName = '' then
    FileName := Title;

  Enabled := IniFile.ReadBool(ID, krsIniKeyEnabled, Enabled);

  ExtractAll := IniFile.ReadBool(ID, krsIniKeyExtractAll, ExtractAll);

  BaseFolder := IniFile.ReadString(ID, krsIniKeyBaseFolder, BaseFolder);
  TempFolder := IniFile.ReadString(ID, krsIniKeyTempFolder, TempFolder);

  // Emulators
  MainEmulator := IniFile.ReadString(ID, krsIniKeyMainEmulator, MainEmulator);
  OtherEmulators.CommaText :=
    IniFile.ReadString(ID, krsIniKeyOtherEmulators, OtherEmulators.CommaText);

  // Images
  Icon := IniFile.ReadString(ID, krsIniKeyIcon, Icon);
  Image := IniFile.ReadString(ID, krsIniKeyImage, Image);
  BackImage := IniFile.ReadString(ID, krsIniKeyBackImage, BackImage);

  IconFolder := IniFile.ReadString(ID, krsIniKeyIconFolder, IconFolder);
  ImageFolders.CommaText :=
    IniFile.ReadString(ID, krsIniKeyImageFolders, ImageFolders.CommaText);
  ImageCaptions.CommaText :=
    IniFile.ReadString(ID, krsIniKeyImageCaptions, ImageCaptions.CommaText);

  // Texts
  InfoText := IniFile.ReadString(ID, krsIniKeyText, InfoText);

  TextFolders.CommaText :=
    IniFile.ReadString(ID, krsIniKeyTextFolders, TextFolders.CommaText);
  TextCaptions.CommaText :=
    IniFile.ReadString(ID, krsIniKeyTextCaptions, TextCaptions.CommaText);

  // Import
  GameKey := Str2EmutecaFileKey(IniFile.ReadString(ID,
    krsIniKeyGamesKey, EmutecaFileKey2Str(GameKey)));
  Extensions.CommaText := IniFile.ReadString(ID, krsIniKeyExtensions,
    Extensions.CommaText);

  // Fixing lists...
  FixFolderListData(ImageFolders, ImageCaptions);
  FixFolderListData(TextFolders, TextCaptions);
end;

procedure cEmutecaSystem.SaveToFileIni(IniFile: TCustomIniFile;
  const ExportMode: boolean);
begin
  if IniFile = nil then
    Exit;

  // Basic data
  IniFile.WriteString(ID, krsIniKeyTitle, Title);
  IniFile.WriteString(ID, krsIniKeyFileName, FileName);
  IniFile.WriteBool(ID, krsIniKeyExtractAll, ExtractAll);

  // Emulators
  IniFile.WriteString(ID, krsIniKeyMainEmulator, MainEmulator);
  IniFile.WriteString(ID, krsIniKeyOtherEmulators, OtherEmulators.CommaText);

  // Import
  IniFile.WriteString(ID, krsIniKeyGamesKey, EmutecaFileKey2Str(GameKey));
  IniFile.WriteString(ID, krsIniKeyExtensions, Extensions.CommaText);

  if ExportMode then
  begin // Las borramos por si acaso existen
    // Basic data
    IniFile.DeleteKey(ID, krsIniKeyEnabled);
    IniFile.DeleteKey(ID, krsIniKeyBaseFolder);
    IniFile.DeleteKey(ID, krsIniKeyTempFolder);

    // Images
    IniFile.DeleteKey(ID, krsIniKeyIcon);
    IniFile.DeleteKey(ID, krsIniKeyImage);
    IniFile.DeleteKey(ID, krsIniKeyBackImage);

    IniFile.DeleteKey(ID, krsIniKeyIconFolder);
    IniFile.DeleteKey(ID, krsIniKeyImageFolders);
    IniFile.DeleteKey(ID, krsIniKeyImageCaptions);

    // Texts
    IniFile.DeleteKey(ID, krsIniKeyText);

    IniFile.DeleteKey(ID, krsIniKeyTextFolders);
    IniFile.DeleteKey(ID, krsIniKeyTextCaptions);
  end
  else
  begin
    // Basic data
    IniFile.WriteBool(ID, krsIniKeyEnabled, Enabled);
    IniFile.WriteString(ID, krsIniKeyBaseFolder, BaseFolder);
    IniFile.WriteString(ID, krsIniKeyTempFolder, TempFolder);

    // Images
    IniFile.WriteString(ID, krsIniKeyIcon, Icon);
    IniFile.WriteString(ID, krsIniKeyImage, Image);
    IniFile.WriteString(ID, krsIniKeyBackImage, BackImage);

    IniFile.WriteString(ID, krsIniKeyIconFolder, IconFolder);
    IniFile.WriteString(ID, krsIniKeyImageFolders, ImageFolders.CommaText);
    IniFile.WriteString(ID, krsIniKeyImageCaptions, ImageCaptions.CommaText);

    // Texts
    IniFile.WriteString(ID, krsIniKeyText, InfoText);

    IniFile.WriteString(ID, krsIniKeyTextFolders, TextFolders.CommaText);
    IniFile.WriteString(ID, krsIniKeyTextCaptions, TextCaptions.CommaText);
  end;
end;

procedure cEmutecaSystem.SetBaseFolder(AValue: string);
begin
  FBaseFolder := SetAsFolder(AValue);
end;

procedure cEmutecaSystem.SetBackImage(AValue: string);
begin
  FBackImage := SetAsFile(AValue);
end;

procedure cEmutecaSystem.SetEnabled(AValue: boolean);
begin
  if FEnabled = AValue then
    Exit;
  FEnabled := AValue;
end;

procedure cEmutecaSystem.SetExtractAll(AValue: boolean);
begin
  if FExtractAll = AValue then
    Exit;
  FExtractAll := AValue;
end;

procedure cEmutecaSystem.SetFileName(AValue: string);
begin
  FFileName := CleanFileName(AValue);
end;

procedure cEmutecaSystem.SetGameKey(AValue: TEmutecaFileKey);
begin
  if FGameKey = AValue then
    Exit;
  FGameKey := AValue;
end;

procedure cEmutecaSystem.SetIcon(AValue: string);
begin
  FIcon := SetAsFile(AValue);
end;

procedure cEmutecaSystem.SetIconFolder(AValue: string);
begin
  FIconFolder := SetAsFolder(AValue);
end;

procedure cEmutecaSystem.SetID(AValue: string);
begin
  FID := SetAsID(AValue);
end;

procedure cEmutecaSystem.SetImage(AValue: string);
begin
  FImage := SetAsFile(AValue);
end;

procedure cEmutecaSystem.SetInfoText(AValue: string);
begin
  FInfoText := SetAsFile(AValue);
end;

procedure cEmutecaSystem.SetMainEmulator(AValue: string);
begin
  FMainEmulator := SetAsID(AValue);
end;

procedure cEmutecaSystem.SetStats(AValue: cEmutecaPlayingStats);
begin
  if FStats = AValue then Exit;
  FStats := AValue;
end;

procedure cEmutecaSystem.SetTempFolder(AValue: string);
begin
  FTempFolder := SetAsFolder(AValue);
end;

procedure cEmutecaSystem.SetTitle(AValue: string);
begin
  if FTitle = AValue then
    Exit;
  FTitle := AValue;
end;

procedure cEmutecaSystem.FixFolderListData(FolderList, CaptionList: TStrings);
var
  i: integer;
begin
  // Removing empty Folders and asociated captions.
  i := 0;
  while i < FolderList.Count do
  begin
    FolderList[i] := SetAsFolder(FolderList[i]);
    if FolderList[i] = '' then
    begin
      FolderList.Delete(i);
      if i < CaptionList.Count then
        CaptionList.Delete(i);
    end
    else
      Inc(i);
  end;

  // Adding text (folder name) to empty Captions
  if FolderList.Count > CaptionList.Count then
  begin
    i := CaptionList.Count;
    while i < FolderList.Count do
    begin
      CaptionList.Add(ExtractFileName(ExcludeTrailingPathDelimiter(
        FolderList[i])));
      Inc(i);
    end;
  end;

  // Removing exceed of captions
  while FolderList.Count < CaptionList.Count do
    CaptionList.Delete(CaptionList.Count - 1);
end;

constructor cEmutecaSystem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FStats := cEmutecaPlayingStats.Create(Self);

  Self.Enabled := False;
  Self.GameKey := TEFKSHA1;

  Self.FExtensions := TStringList.Create;
  Self.Extensions.CaseSensitive := False;
  self.Extensions.Sorted := True;

  Self.FOtherEmulators := TStringList.Create;
  Self.OtherEmulators.CaseSensitive := False;
  Self.OtherEmulators.Sorted := True;

  Self.FImageCaptions := TStringList.Create;
  Self.FImageFolders := TStringList.Create;

  Self.FTextCaptions := TStringList.Create;
  Self.FTextFolders := TStringList.Create;
end;

destructor cEmutecaSystem.Destroy;
begin
  FreeAndNil(Self.FExtensions);
  FreeAndNil(Self.FOtherEmulators);

  FreeAndNil(Self.FImageCaptions);
  FreeAndNil(Self.FImageFolders);

  FreeAndNil(Self.FTextCaptions);
  FreeAndNil(Self.FTextFolders);

  FreeAndNil(FStats);

  inherited Destroy;
end;

end.
