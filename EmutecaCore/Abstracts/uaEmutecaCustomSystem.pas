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

unit uaEmutecaCustomSystem;


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, LazFileUtils, LazUTF8,
  uCHXStrUtils,
  uaCHXStorable,
  uEmutecaCommon,
  ucEmutecaEmulatorList, ucEmutecaEmulator,
  ucEmutecaPlayingStats;

type
  { caEmutecaCustomSystem }

  caEmutecaCustomSystem = class(caCHXStorableIni)
  private
    FBackgroundFile: string;
    FBaseFolder: string;
    FCurrentEmulator: cEmutecaEmulator;
    FEmulatorList: cEmutecaEmulatorList;
    FEnabled: boolean;
    FExtensions: TStringList;
    FExtractAll: boolean;
    FListFileName: string;
    FSoftExportKey: TEmutecaSoftExportKey;
    FIconFile: string;
    FIconFolder: string;
    FID: string;
    FImage: string;
    FImageCaptions: TStringList;
    FImageFolders: TStringList;
    FInfoText: string;
    FMainEmulator: string;
    FMusicCaptions: TStringList;
    FMusicFolders: TStringList;
    FOtherEmulators: TStringList;
    FSoftIconFile: string;
    FStats: cEmutecaPlayingStats;
    FTempFolder: string;
    FWorkingFolder: string;
    FTextCaptions: TStringList;
    FTextFolders: TStringList;
    FTitle: string;
    FVideoCaptions: TStringList;
    FVideoFolders: TStringList;
    function GetListFileName: string;
    procedure SetBackgroundFile(AValue: string);
    procedure SetBaseFolder(AValue: string);
    procedure SetCurrentEmulator(AValue: cEmutecaEmulator);
    procedure SetEnabled(AValue: boolean);
    procedure SetExtractAll(AValue: boolean);
    procedure SetListFileName(AValue: string);
    procedure SetSoftExportKey(AValue: TEmutecaSoftExportKey);
    procedure SetIconFile(AValue: string);
    procedure SetIconFolder(AValue: string);
    procedure SetID(AValue: string);
    procedure SetImage(AValue: string);
    procedure SetInfoText(AValue: string);
    procedure SetMainEmulator(AValue: string);
    procedure SetSoftIconFile(AValue: string);
    procedure SetTempFolder(AValue: string);
    procedure SetWorkingFolder(AValue: string);
    procedure SetTitle(AValue: string);

  protected
    procedure FixFolderListData(FolderList, CaptionList: TStrings);
    {< Try to fix some incosistences in folders and its captions.

    Who knows if somebody edited the .ini file by hand...
    }
    procedure DoSaveToIni(aIniFile: TIniFile; ExportMode: Boolean); virtual;

  public
    property TempFolder: string read FTempFolder write SetTempFolder;
    {< System temp folder for decompressing media
    }

    property EmulatorList: cEmutecaEmulatorList read FEmulatorList;
    {< List of current assigned and enabled emulators. }
    property CurrentEmulator: cEmutecaEmulator
      read FCurrentEmulator write SetCurrentEmulator;
    {< Current assigned emulator. }

    function MatchID(aID: string): boolean;
    function CompareID(aID: string): integer;

    procedure LoadEmulatorsFrom(aEmuList: cEmutecaEmulatorList);
    {< Updates EmulatorList from aEmuList. }

    procedure LoadFromIni(aIniFile: TMemIniFile); override;
    procedure SaveToIni(aIniFile: TMemIniFile); override;
    procedure ExportToIni(aIniFile: TMemIniFile); virtual;
    procedure ImportFromIni(aIniFile: TMemIniFile); virtual;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published

    // Basic Info
    // ----------
    property ID: string read FID write SetID;
    {< ID of the system. }

    property Title: string read FTitle write SetTitle;
    {< Visible name (Usually "%Company%: %Model% %(info)%"}

    property ListFileName: string read GetListFileName write SetListFileName;
    {< Name used for soft and group files. }

    property Enabled: boolean read FEnabled write SetEnabled;
    {< Is the system visible? }

    property ExtractAll: boolean read FExtractAll write SetExtractAll;
    {< Must all files be extracted from compressed archives? }

    property BaseFolder: string read FBaseFolder write SetBaseFolder;
    {< System base folder

       Used by default to store some data if the file isn't defined
         (System image or text).
    }

    property WorkingFolder: string read FWorkingFolder write SetWorkingFolder;
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
    {< Ids of other emulators for the system.

    It holds enabled, disabled and inexistent emulator ids too.
      This is different from EmulatorList only current enabled ones.}

    // System Images
    // -------------
    property IconFile: string read FIconFile write SetIconFile;
    {< Path to the icon of the system. }
    property ImageFile: string read FImage write SetImage;
    {< Path to image of the system. }
    property BackgroundFile: string read FBackgroundFile
      write SetBackgroundFile;
    {< Image used for as background. }
    property SoftIconFile: string read FSoftIconFile write SetSoftIconFile;
    {< Default soft icon. }

    // Soft image dirs
    // ---------------
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

    // Music
    // -----
    property MusicFolders: TStringList read FMusicFolders;
    {< Folders for game music. }
    property MusicCaptions: TStringList read FMusicCaptions;
    {< Captions for the folders of game's music. }

    // Video
    // -----
    property VideoFolders: TStringList read FVideoFolders;
    {< Folders for game videos. }
    property VideoCaptions: TStringList read FVideoCaptions;
    {< Captions for the folders of game's video. }

    // Import
    // ------
    property SoftExportKey: TEmutecaSoftExportKey
      read FSoftExportKey write SetSoftExportKey;
    {< Default key (CRC/SHA) to be used as game identifiers
       (when importing/exporting data). }
    property Extensions: TStringList read FExtensions;
    {< Extensions used by the system.

    Only one extension in every string, without dot.
    }

    property Stats: cEmutecaPlayingStats read FStats;

  end;

implementation

{ caEmutecaCustomSystem }

procedure caEmutecaCustomSystem.LoadFromIni(aIniFile: TMemIniFile);
begin
  if not Assigned(aIniFile) then
    Exit;

  // Basic data
  Title := aIniFile.ReadString(ID, krsIniKeyTitle, Title);

  ListFileName := aIniFile.ReadString(ID, krsIniKeyFileName, ListFileName);
  if ListFileName = '' then
    ListFileName := Title;

  Enabled := aIniFile.ReadBool(ID, krsIniKeyEnabled, Enabled);

  ExtractAll := aIniFile.ReadBool(ID, krsIniKeyExtractAll, ExtractAll);

  BaseFolder := aIniFile.ReadString(ID, krsIniKeyBaseFolder, BaseFolder);
  WorkingFolder := aIniFile.ReadString(ID, krsIniKeyWorkingFolder,
    WorkingFolder);

  // Emulators
  MainEmulator := aIniFile.ReadString(ID, krsIniKeyMainEmulator, MainEmulator);
  OtherEmulators.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyOtherEmulators, OtherEmulators.CommaText);

  // Images
  IconFile := aIniFile.ReadString(ID, krsIniKeyIcon, IconFile);
  ImageFile := aIniFile.ReadString(ID, krsIniKeyImage, ImageFile);
  BackgroundFile := aIniFile.ReadString(ID, krsIniKeyBackImage,
    BackgroundFile);
  SoftIconFile := aIniFile.ReadString(ID, krsIniKeySoftIcon, SoftIconFile);

  IconFolder := aIniFile.ReadString(ID, krsIniKeyIconFolder, IconFolder);
  ImageFolders.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyImageFolders, ImageFolders.CommaText);
  ImageCaptions.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyImageCaptions, ImageCaptions.CommaText);

  // Texts
  InfoText := aIniFile.ReadString(ID, krsIniKeyText, InfoText);

  TextFolders.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyTextFolders, TextFolders.CommaText);
  TextCaptions.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyTextCaptions, TextCaptions.CommaText);

  // Music
  MusicFolders.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyMusicFolders, MusicFolders.CommaText);
  MusicCaptions.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyMusicCaptions, MusicCaptions.CommaText);

  // Video
  VideoFolders.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyVideoFolders, VideoFolders.CommaText);
  VideoCaptions.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyVideoCaptions, VideoCaptions.CommaText);

  // Import
  SoftExportKey := Str2SoftExportKey(
    aIniFile.ReadString(ID, krsIniKeySoftExportKey,
    SoftExportKey2StrK(SoftExportKey)));
  Extensions.CommaText := aIniFile.ReadString(ID, krsIniKeyExtensions,
    Extensions.CommaText);

  Stats.LoadFromIni(aIniFile, ID);

  // Fixing lists...
  FixFolderListData(ImageFolders, ImageCaptions);
  FixFolderListData(TextFolders, TextCaptions);
  FixFolderListData(MusicFolders, MusicCaptions);
  FixFolderListData(VideoFolders, VideoCaptions);
end;

procedure caEmutecaCustomSystem.ExportToIni(aIniFile: TMemIniFile);
begin
  DoSaveToIni(aIniFile, True);
end;

procedure caEmutecaCustomSystem.ImportFromIni(aIniFile: TMemIniFile);
begin
  // Simply load from file, when exporting user data is removed
  LoadFromIni(aIniFile);
end;

procedure caEmutecaCustomSystem.SaveToIni(aIniFile: TMemIniFile);
begin
  DoSaveToIni(aIniFile, False);
end;

procedure caEmutecaCustomSystem.SetBaseFolder(AValue: string);
begin
  FBaseFolder := SetAsFolder(AValue);
end;

procedure caEmutecaCustomSystem.SetCurrentEmulator(AValue: cEmutecaEmulator);
begin
  if FCurrentEmulator = AValue then
    Exit;
  FCurrentEmulator := AValue;

  // if not already added then add to list
  if Assigned(CurrentEmulator) then
  begin
    if EmulatorList.IndexOf(CurrentEmulator) = -1 then
      EmulatorList.Add(CurrentEmulator);
    MainEmulator := CurrentEmulator.ID;
  end
  else
  ; // MainEmulator := ''; ?
end;

procedure caEmutecaCustomSystem.SetBackgroundFile(AValue: string);
begin
  FBackgroundFile := SetAsFile(AValue);
end;

function caEmutecaCustomSystem.GetListFileName: string;
begin
  if FListFileName = '' then
    ListFileName := ID;
  Result := FListFileName;
end;

procedure caEmutecaCustomSystem.SetEnabled(AValue: boolean);
begin
  if FEnabled = AValue then
    Exit;
  FEnabled := AValue;
end;

procedure caEmutecaCustomSystem.SetExtractAll(AValue: boolean);
begin
  if FExtractAll = AValue then
    Exit;
  FExtractAll := AValue;
end;

procedure caEmutecaCustomSystem.SetListFileName(AValue: string);
begin
  FListFileName := CleanFileName(AValue);
end;

procedure caEmutecaCustomSystem.SetSoftExportKey(
  AValue: TEmutecaSoftExportKey);
begin
  if FSoftExportKey = AValue then
    Exit;
  FSoftExportKey := AValue;
end;

procedure caEmutecaCustomSystem.SetIconFile(AValue: string);
begin
  FIconFile := SetAsFile(AValue);
end;

procedure caEmutecaCustomSystem.SetIconFolder(AValue: string);
begin
  FIconFolder := SetAsFolder(AValue);
end;

procedure caEmutecaCustomSystem.SetID(AValue: string);
begin
  if FID = AValue then
    Exit;
  FID := AValue;

  if ListFileName = '' then
    ListFileName := ID;

  FPONotifyObservers(Self, ooChange, nil);
end;

procedure caEmutecaCustomSystem.SetImage(AValue: string);
begin
  FImage := SetAsFile(AValue);
end;

procedure caEmutecaCustomSystem.SetInfoText(AValue: string);
begin
  FInfoText := SetAsFile(AValue);
end;

procedure caEmutecaCustomSystem.SetMainEmulator(AValue: string);
begin
  if FMainEmulator = AValue then
    Exit;
  FMainEmulator := AValue;

  if OtherEmulators.IndexOf(MainEmulator) = -1 then
    OtherEmulators.Add(MainEmulator);
end;

procedure caEmutecaCustomSystem.SetSoftIconFile(AValue: string);
begin
  FSoftIconFile := SetAsFile(AValue)
end;

procedure caEmutecaCustomSystem.SetTempFolder(AValue: string);
begin
  FTempFolder := SetAsFolder(AValue) + SetAsFolder(ID);
end;

procedure caEmutecaCustomSystem.SetWorkingFolder(AValue: string);
begin
  FWorkingFolder := SetAsFolder(AValue);
end;

procedure caEmutecaCustomSystem.SetTitle(AValue: string);
begin
  if FTitle = AValue then
    Exit;
  FTitle := AValue;
end;

procedure caEmutecaCustomSystem.FixFolderListData(FolderList,
  CaptionList: TStrings);
var
  i: integer;
begin
  // Removing empty Folders and associated captions.
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

procedure caEmutecaCustomSystem.DoSaveToIni(aIniFile: TIniFile;
  ExportMode: Boolean);
var
  i: integer;
begin
  if not Assigned(aIniFile) then
    Exit;

  // Basic data
  aIniFile.WriteString(ID, krsIniKeyTitle, Title);
  aIniFile.WriteString(ID, krsIniKeyFileName, ListFileName);
  aIniFile.WriteBool(ID, krsIniKeyExtractAll, ExtractAll);

  // Emulators
  if Assigned(CurrentEmulator) then
    aIniFile.WriteString(ID, krsIniKeyMainEmulator, CurrentEmulator.ID)
  else
    aIniFile.WriteString(ID, krsIniKeyMainEmulator, MainEmulator);

  // Adding EmulatorList ones if not already added
  i := 0;
  while i < EmulatorList.Count do
  begin
    if OtherEmulators.IndexOf(EmulatorList[i].ID) = -1 then
      OtherEmulators.Add(EmulatorList[i].ID);
    Inc(i);
  end;
  aIniFile.WriteString(ID, krsIniKeyOtherEmulators,
    OtherEmulators.CommaText);

  // Import
  aIniFile.WriteString(ID, krsIniKeySoftExportKey,
    SoftExportKey2StrK(SoftExportKey));
  aIniFile.WriteString(ID, krsIniKeyExtensions, Extensions.CommaText);

  if ExportMode then
  begin // Las borramos por si acaso existen
    // Basic data
    aIniFile.DeleteKey(ID, krsIniKeyEnabled);
    aIniFile.DeleteKey(ID, krsIniKeyBaseFolder);
    aIniFile.DeleteKey(ID, krsIniKeyWorkingFolder);

    // Images
    aIniFile.DeleteKey(ID, krsIniKeyIcon);
    aIniFile.DeleteKey(ID, krsIniKeyImage);
    aIniFile.DeleteKey(ID, krsIniKeyBackImage);
    aIniFile.DeleteKey(ID, krsIniKeySoftIcon);

    aIniFile.DeleteKey(ID, krsIniKeyIconFolder);
    aIniFile.DeleteKey(ID, krsIniKeyImageFolders);
    aIniFile.DeleteKey(ID, krsIniKeyImageCaptions);

    // Texts
    aIniFile.DeleteKey(ID, krsIniKeyText);

    aIniFile.DeleteKey(ID, krsIniKeyTextFolders);
    aIniFile.DeleteKey(ID, krsIniKeyTextCaptions);

    // Music
    aIniFile.DeleteKey(ID, krsIniKeyMusicFolders);
    aIniFile.DeleteKey(ID, krsIniKeyMusicCaptions);

    // Video
    aIniFile.DeleteKey(ID, krsIniKeyVideoFolders);
    aIniFile.DeleteKey(ID, krsIniKeyVideoCaptions);
  end
  else
  begin
    // Basic data
    aIniFile.WriteBool(ID, krsIniKeyEnabled, Enabled);
    aIniFile.WriteString(ID, krsIniKeyBaseFolder, BaseFolder);
    aIniFile.WriteString(ID, krsIniKeyWorkingFolder, WorkingFolder);

    // Images
    aIniFile.WriteString(ID, krsIniKeyIcon, IconFile);
    aIniFile.WriteString(ID, krsIniKeyImage, ImageFile);
    aIniFile.WriteString(ID, krsIniKeyBackImage, BackgroundFile);
    aIniFile.WriteString(ID, krsIniKeySoftIcon, SoftIconFile);

    aIniFile.WriteString(ID, krsIniKeyIconFolder, IconFolder);
    aIniFile.WriteString(ID, krsIniKeyImageFolders, ImageFolders.CommaText);
    aIniFile.WriteString(ID, krsIniKeyImageCaptions, ImageCaptions.CommaText);

    // Texts
    aIniFile.WriteString(ID, krsIniKeyText, InfoText);

    aIniFile.WriteString(ID, krsIniKeyTextFolders, TextFolders.CommaText);
    aIniFile.WriteString(ID, krsIniKeyTextCaptions, TextCaptions.CommaText);

    // Music
    aIniFile.WriteString(ID, krsIniKeyMusicFolders, MusicFolders.CommaText);
    aIniFile.WriteString(ID, krsIniKeyMusicCaptions, MusicCaptions.CommaText);

    // Video
    aIniFile.WriteString(ID, krsIniKeyVideoFolders, VideoFolders.CommaText);
    aIniFile.WriteString(ID, krsIniKeyVideoCaptions, VideoCaptions.CommaText);
  end;

  Stats.WriteToIni(aIniFile, ID, ExportMode);
end;

function caEmutecaCustomSystem.MatchID(aID: string): boolean;
begin
  Result := CompareID(aID) = 0;
end;

function caEmutecaCustomSystem.CompareID(aID: string): integer;
begin
  Result := UTF8CompareText(Self.ID, aID);
end;

procedure caEmutecaCustomSystem.LoadEmulatorsFrom(aEmuList:
  cEmutecaEmulatorList);
var
  i: integer;
begin
  EmulatorList.Clear;

  if not Assigned(aEmuList) then
    Exit;

  i := 0;
  while i < aEmuList.Count do
  begin
    if (aEmuList[i].Enabled) and
      (OtherEmulators.IndexOf(aEmuList[i].ID) <> -1) then
    begin
      EmulatorList.Add(aEmuList[i]);
      if aEmuList[i].MatchID(MainEmulator) then
        CurrentEmulator := aEmuList[i];
    end;
    Inc(i);
  end;
end;

constructor caEmutecaCustomSystem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Enabled := False;
  SoftExportKey := TEFKSHA1;

  FExtensions := TStringList.Create;
  Extensions.CaseSensitive := False;
  Extensions.Sorted := True;

  FEmulatorList := cEmutecaEmulatorList.Create(False);

  FOtherEmulators := TStringList.Create;
  OtherEmulators.CaseSensitive := False;
  OtherEmulators.Sorted := True;

  FImageCaptions := TStringList.Create;
  FImageFolders := TStringList.Create;

  FTextCaptions := TStringList.Create;
  FTextFolders := TStringList.Create;

  FMusicCaptions := TStringList.Create;
  FMusicFolders := TStringList.Create;

  FVideoCaptions := TStringList.Create;
  FVideoFolders := TStringList.Create;

  FStats := cEmutecaPlayingStats.Create(Self);
end;

destructor caEmutecaCustomSystem.Destroy;
begin
  Extensions.Free;

  FEmulatorList.Free;
  OtherEmulators.Free;

  ImageCaptions.Free;
  ImageFolders.Free;

  TextCaptions.Free;
  TextFolders.Free;

  MusicCaptions.Free;
  MusicFolders.Free;

  VideoCaptions.Free;
  VideoFolders.Free;

  Stats.Free;

  inherited Destroy;
end;

initialization
  RegisterClass(caEmutecaCustomSystem);

finalization
  UnRegisterClass(caEmutecaCustomSystem);
end.
