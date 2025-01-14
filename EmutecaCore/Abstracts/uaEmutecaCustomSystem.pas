unit uaEmutecaCustomSystem;

{< caEmutecaCustomSystem abstract class unit.

  This file is part of Emuteca Core.

  Copyright (C) 2006-2024 Chixpy
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, LazFileUtils, LazUTF8, fgl,
  // CHX units
  uCHXStrUtils,
  // CHX abstracts
  uaCHXStorable,
  // Emuteca Core units
  uEmutecaConst, uEmutecaCommon,
  // Emuteca classes
  ucEmutecaPlayingStats;

type
  { caEmutecaCustomSystem }

  caEmutecaCustomSystem = class(caCHXStorableIni)
  private
    FBaseFolder : string;
    FCoreIDs : TStringList;
    FExtensions : TStringList;
    FListFileName : string;
    FLogoFolder : string;
    FOtherFCapt : TStringList;
    FOtherFExt : TStringList;
    FOtherFolders : TStringList;
    FIconFile : string;
    FIconFolder : string;
    FID : string;
    FImage : string;
    FImageCaptions : TStringList;
    FImageFolders : TStringList;
    FInfoText : string;
    FMainEmulator : string;
    FMusicCaptions : TStringList;
    FMusicFolders : TStringList;
    FOtherEmulators : TStringList;
    FSoftIconFile : string;
    FStats : cEmutecaPlayingStats;
    FTempFolder : string;
    FWorkingFolder : string;
    FTextCaptions : TStringList;
    FTextFolders : TStringList;
    FVideoCaptions : TStringList;
    FVideoFolders : TStringList;
    function GetListFileName : string;
    procedure SetBaseFolder(AValue : string);
    procedure SetListFileName(AValue : string);
    procedure SetLogoFolder(AValue : string);
    procedure SetIconFile(AValue : string);
    procedure SetIconFolder(AValue : string);
    procedure SetID(AValue : string);
    procedure SetImage(AValue : string);
    procedure SetInfoText(AValue : string);
    procedure SetMainEmulator(AValue : string);
    procedure SetSoftIconFile(AValue : string);
    procedure SetTempFolder(AValue : string);
    procedure SetWorkingFolder(AValue : string);

  protected
    procedure FixFolderListData(FolderList, CaptionList : TStrings);
    {< Try to fix some incosistences in folders and its captions.

    Who knows if somebody edited the .ini file by hand...
    }
    procedure DoSaveToIni(aIniFile : TIniFile; const ExportMode : boolean); virtual;

  public
    {property} Title : string;
    {< Visible name (Usually "%Company%: %Model% %(info)%"}

    {property} Enabled : boolean;
    {< Is the system visible? }

    {property} ExtractAll : boolean;
    {< Must all files be extracted from compressed archives? }

    {property} MergeableGroups : boolean;

    {property} SoftExportKey : TEmutecaSoftExportKey;
    {< Default key (CRC/SHA) to be used as game identifiers
       (when importing/exporting data). }

    // Basic Info
    // ----------
    property ID : string read FID write SetID;
    {< ID of the system. }

    property ListFileName : string read GetListFileName write SetListFileName;
    {< Name used for soft and group files. }

    property BaseFolder : string read FBaseFolder write SetBaseFolder;
    {< System base folder

       Used by default to store some data if the file isn't defined
         (System image or text).
    }

    property WorkingFolder : string read FWorkingFolder write SetWorkingFolder;
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
    property MainEmulator : string read FMainEmulator write SetMainEmulator;
    {< Main emulator ID. }
    property OtherEmulators : TStringList read FOtherEmulators;
    {< Ids of other emulators for the system.

    It holds enabled, disabled and inexistent emulator ids too.
      This is different from EmulatorList only current enabled ones.}
    property CoreIDs : TStringList read FCoreIDs;
    {< MultiEmulator Core IDs }

    // System Images
    // -------------
    property IconFile : string read FIconFile write SetIconFile;
    {< Path to the icon of the system. }
    property ImageFile : string read FImage write SetImage;
    {< Path to image of the system. }
    property SoftIconFile : string read FSoftIconFile write SetSoftIconFile;
    {< Default soft icon. }

    // Soft image dirs
    // ---------------
    property IconFolder : string read FIconFolder write SetIconFolder;
    {< Folder for the icons of the games. }
    property LogoFolder : string read FLogoFolder write SetLogoFolder;
    {< Folder for the logos of the games. }
    property ImageFolders : TStringList read FImageFolders;
    {< Folders for the game images. }
    property ImageCaptions : TStringList read FImageCaptions;
    {< Captions for the folders of game's images. }

    // Texts
    // -----
    property InfoText : string read FInfoText write SetInfoText;
    {< Path to text file of the system. }

    property TextFolders : TStringList read FTextFolders;
    {< Folders for game texts. }
    property TextCaptions : TStringList read FTextCaptions;
    {< Captions for the folders of game's texts. }

    // Music
    // -----
    property MusicFolders : TStringList read FMusicFolders;
    {< Folders for game music. }
    property MusicCaptions : TStringList read FMusicCaptions;
    {< Captions for the folders of game's music. }

    // Video
    // -----
    property VideoFolders : TStringList read FVideoFolders;
    {< Folders for game videos. }
    property VideoCaptions : TStringList read FVideoCaptions;
    {< Captions for the folders of game's video. }

    // Other folders
    // -------------
    property OtherFolders : TStringList read FOtherFolders;
    {< Other Folders for game files not suported by Emuteca. }
    property OtherFExt : TStringList read FOtherFExt;
    {< Extensions searched in OtherFolders. }
    property OtherFCapt : TStringList read FOtherFCapt;
    {< Captions for the OtherFolders. }

    // Import
    // ------
    property Extensions : TStringList read FExtensions;
    {< Extensions used by the system.

    Only one extension in every string, without dot.
    }

    property Stats : cEmutecaPlayingStats read FStats;

    property TempFolder : string read FTempFolder write SetTempFolder;
    {< System temp folder for decompressing media. }

    function MatchID(const aID : string) : boolean; inline;
    function CompareID(const aID : string) : integer; inline;

    procedure LoadFromIni(aIniFile : TMemIniFile); override;
    procedure SaveToIni(aIniFile : TMemIniFile); override;
    procedure ExportToIni(aIniFile : TMemIniFile); virtual;
    procedure ImportFromIni(aIniFile : TMemIniFile); virtual;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ caEmutecaCustomSystem }

procedure caEmutecaCustomSystem.LoadFromIni(aIniFile : TMemIniFile);
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
  MergeableGroups := aIniFile.ReadBool(ID, krsIniKeyMergeableGroups,
    MergeableGroups);

  BaseFolder := aIniFile.ReadString(ID, krsIniKeyBaseFolder, BaseFolder);
  WorkingFolder := aIniFile.ReadString(ID, krsIniKeyWorkingFolder,
    WorkingFolder);

  // Emulators
  MainEmulator := aIniFile.ReadString(ID, krsIniKeyMainEmulator, MainEmulator);
  OtherEmulators.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyOtherEmulators, OtherEmulators.CommaText);
  CoreIDs.CommaText := aIniFile.ReadString(ID, krsIniKeyCoreIDs,
    CoreIDs.CommaText);

  // Images
  IconFile := aIniFile.ReadString(ID, krsIniKeyIcon, IconFile);
  ImageFile := aIniFile.ReadString(ID, krsIniKeyImage, ImageFile);
  SoftIconFile := aIniFile.ReadString(ID, krsIniKeySoftIcon, SoftIconFile);

  IconFolder := aIniFile.ReadString(ID, krsIniKeyIconFolder, IconFolder);
  LogoFolder := aIniFile.ReadString(ID, krsIniKeyLogoFolder, LogoFolder);
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

  // Other Folders
  OtherFolders.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyOtherFolders, OtherFolders.CommaText);
  OtherFExt.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyOtherFExt, OtherFExt.CommaText);
  OtherFCapt.CommaText :=
    aIniFile.ReadString(ID, krsIniKeyOtherFCapt, OtherFCapt.CommaText);

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
  FixFolderListData(OtherFolders, OtherFCapt);

  // We can't use FixFolderListData for this
  while OtherFolders.Count > OtherFExt.Count do
    OtherFExt.Add(EmptyStr);
end;

procedure caEmutecaCustomSystem.ExportToIni(aIniFile : TMemIniFile);
begin
  DoSaveToIni(aIniFile, True);
end;

procedure caEmutecaCustomSystem.ImportFromIni(aIniFile : TMemIniFile);
begin
  // Simply load from file, when exporting user data is removed
  LoadFromIni(aIniFile);
end;

procedure caEmutecaCustomSystem.SaveToIni(aIniFile : TMemIniFile);
begin
  DoSaveToIni(aIniFile, False);
end;

procedure caEmutecaCustomSystem.SetBaseFolder(AValue : string);
begin
  FBaseFolder := SetAsFolder(AValue);
end;

function caEmutecaCustomSystem.GetListFileName : string;
begin
  if FListFileName = '' then
    ListFileName := ID;
  Result := FListFileName;
end;

procedure caEmutecaCustomSystem.SetListFileName(AValue : string);
begin
  FListFileName := CleanFileName(AValue);
end;

procedure caEmutecaCustomSystem.SetLogoFolder(AValue : string);
begin
  FLogoFolder := SetAsFolder(AValue);
end;

procedure caEmutecaCustomSystem.SetIconFile(AValue : string);
begin
  FIconFile := SetAsFile(AValue);
end;

procedure caEmutecaCustomSystem.SetIconFolder(AValue : string);
begin
  FIconFolder := SetAsFolder(AValue);
end;

procedure caEmutecaCustomSystem.SetID(AValue : string);
begin
  AValue := UTF8Trim(AValue);
  if FID = AValue then
    Exit;
  FID := AValue;

  if ListFileName = '' then
    ListFileName := ID;

  FPONotifyObservers(Self, ooChange, nil);
end;

procedure caEmutecaCustomSystem.SetImage(AValue : string);
begin
  FImage := SetAsFile(AValue);
end;

procedure caEmutecaCustomSystem.SetInfoText(AValue : string);
begin
  FInfoText := SetAsFile(AValue);
end;

procedure caEmutecaCustomSystem.SetMainEmulator(AValue : string);
begin
  AValue := UTF8Trim(AValue);
  if FMainEmulator = AValue then
    Exit;
  FMainEmulator := AValue;

  if OtherEmulators.IndexOf(MainEmulator) = -1 then
    OtherEmulators.Add(MainEmulator);
end;

procedure caEmutecaCustomSystem.SetSoftIconFile(AValue : string);
begin
  FSoftIconFile := SetAsFile(AValue);
end;

procedure caEmutecaCustomSystem.SetTempFolder(AValue : string);
begin
  FTempFolder := SetAsFolder(AValue) + SetAsFolder(ID);
end;

procedure caEmutecaCustomSystem.SetWorkingFolder(AValue : string);
begin
  FWorkingFolder := SetAsFolder(AValue);
end;

procedure caEmutecaCustomSystem.FixFolderListData(FolderList,
  CaptionList : TStrings);
var
  i : integer;
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

procedure caEmutecaCustomSystem.DoSaveToIni(aIniFile : TIniFile;
  const ExportMode : boolean);
begin
  if not Assigned(aIniFile) then
    Exit;

  // Basic data
  aIniFile.WriteString(ID, krsIniKeyTitle, Title);
  aIniFile.WriteString(ID, krsIniKeyFileName, ListFileName);
  aIniFile.WriteBool(ID, krsIniKeyExtractAll, ExtractAll);
  aIniFile.WriteBool(ID, krsIniKeyMergeableGroups, MergeableGroups);

  aIniFile.WriteString(ID, krsIniKeyMainEmulator, MainEmulator);

  aIniFile.WriteString(ID, krsIniKeyOtherEmulators, OtherEmulators.CommaText);
  aIniFile.WriteString(ID, krsIniKeyCoreIDs, CoreIDs.CommaText);

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
    aIniFile.DeleteKey(ID, krsIniKeyLogoFolder);
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

    // Other Folders
    aIniFile.DeleteKey(ID, krsIniKeyOtherFolders);
    aIniFile.DeleteKey(ID, krsIniKeyOtherFExt);
    aIniFile.DeleteKey(ID, krsIniKeyOtherFCapt);

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
    aIniFile.WriteString(ID, krsIniKeySoftIcon, SoftIconFile);

    aIniFile.WriteString(ID, krsIniKeyIconFolder, IconFolder);
    aIniFile.WriteString(ID, krsIniKeyLogoFolder, LogoFolder);
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

    // Other Folders
    aIniFile.WriteString(ID, krsIniKeyOtherFolders, OtherFolders.CommaText);
    aIniFile.WriteString(ID, krsIniKeyOtherFExt, OtherFExt.CommaText);
    aIniFile.WriteString(ID, krsIniKeyOtherFCapt, OtherFCapt.CommaText);

  end;

  Stats.WriteToIni(aIniFile, ID, ExportMode);
end;

function caEmutecaCustomSystem.MatchID(const aID : string) : boolean;
begin
  Result := CompareID(aID) = 0;
end;

function caEmutecaCustomSystem.CompareID(const aID : string) : integer;
begin
  Result := UTF8CompareText(Self.ID, UTF8Trim(aID));
end;

constructor caEmutecaCustomSystem.Create;
begin
  inherited Create;

  Enabled := False;
  ExtractAll := False;
  MergeableGroups := False;
  SoftExportKey := TEFKSHA1;

  FExtensions := TStringList.Create;
  Extensions.CaseSensitive := False;
  Extensions.Sorted := True;

  FCoreIDs := TStringList.Create;
  CoreIDs.CaseSensitive := False;
  CoreIDs.Sorted := True;
  CoreIDs.NameValueSeparator := '=';

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

  FOtherFolders := TStringList.Create;
  FOtherFExt := TStringList.Create;
  FOtherFCapt := TStringList.Create;

  FStats := cEmutecaPlayingStats.Create;
end;

destructor caEmutecaCustomSystem.Destroy;
begin
  Extensions.Free;
  CoreIDs.Free;

  OtherEmulators.Free;

  ImageCaptions.Free;
  ImageFolders.Free;

  TextCaptions.Free;
  TextFolders.Free;

  MusicCaptions.Free;
  MusicFolders.Free;

  VideoCaptions.Free;
  VideoFolders.Free;

  OtherFolders.Free;
  OtherFExt.Free;
  OtherFCapt.Free;

  Stats.Free;

  inherited Destroy;
end;

initialization
  RegisterClass(caEmutecaCustomSystem);

finalization
  UnRegisterClass(caEmutecaCustomSystem);
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
