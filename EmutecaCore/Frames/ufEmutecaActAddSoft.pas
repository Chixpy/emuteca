unit ufEmutecaActAddSoft;

{ Frame to add sofware.

  This file is part of Emuteca Core.

  Copyright (C) 2011-2023 Chixpy
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, ActnList, StdCtrls, EditBtn, LazFileUtils,
  // CHX units
  uCHX7zWrapper, uCHXStrUtils, uCHXFileUtils,
  // CHX forms
  ufrCHXForm,
  // CHX frames
  ufCHXPropEditor,
  // Emuteca Core units
  uEmutecaConst, uEmutecaRscStr,
  // Emuteca Core abstracts
  uaEmutecaCustomSystem,
  // Emuteca Core classes
  ucEmuteca, ucEmutecaSystem, ucEmutecaSoftList, ucEmutecaGroup,
  ucEmutecaSoftware,
  // Emuteca Core frames
  ufEmutecaSoftEditor, ufEmutecaSystemCBX, ufEmutecaGroupCBX;

type

  { TfmEmutecaActAddSoft }

  TfmEmutecaActAddSoft = class(TfmCHXPropEditor)
    actAddNewGroup : TAction;
    bAddNewGroup : TSpeedButton;
    cbxInnerFile : TComboBox;
    chkOpenAsArchive : TCheckBox;
    eFile : TFileNameEdit;
    eVersionKey : TEdit;
    gbxFileSelection : TGroupBox;
    gbxDuplicates : TGroupBox;
    gbxGroup : TGroupBox;
    gbxSelectSystem : TGroupBox;
    gbxSoftInfo : TGroupBox;
    lCompressedError : TLabel;
    lDupFile : TLabel;
    lSystemInfo : TLabel;
    pInfo : TPanel;
    pSelectFile : TPanel;
    rgbSoftKey : TRadioGroup;
    Splitter1 : TSplitter;
    procedure actAddNewGroupExecute(Sender : TObject);
    procedure cbxInnerFileChange(Sender : TObject);
    procedure chkOpenAsArchiveChange(Sender : TObject);
    procedure eFileAcceptFileName(Sender : TObject; var Value : string);
    procedure eFileEditingDone(Sender : TObject);
    procedure eVersionKeyEditingDone(Sender : TObject);
    procedure rgbSoftKeySelectionChanged(Sender : TObject);

  private
    FfmSystemCBX : TfmEmutecaSystemCBX;
    FfmSoftEditor : TfmEmutecaSoftEditor;

  private
    FEmuteca : cEmuteca;
    FfmGroupCBX : TfmEmutecaGroupCBX;
    FSoftware : cEmutecaSoftware;
    procedure SetEmuteca(aValue : cEmuteca);
    procedure SetSoftware(aValue : cEmutecaSoftware);

  protected
    property fmSoftEditor : TfmEmutecaSoftEditor read FfmSoftEditor;
    property fmSystemCBX : TfmEmutecaSystemCBX read FfmSystemCBX;
    property fmGroupCBX : TfmEmutecaGroupCBX read FfmGroupCBX;

    property Software : cEmutecaSoftware read FSoftware write SetSoftware;

    procedure SelectFile;
    procedure UpdateFileData;
    procedure UpdateInnerFileData;
    procedure UpdateSoftKey;
    procedure UpdateDupInfo;

    procedure SelectSystem(aSystem : cEmutecaSystem);
    procedure SelectGroup(aGroup : cEmutecaGroup);


  public
    property Emuteca : cEmuteca read FEmuteca write SetEmuteca;

    procedure ClearFrameData; override;
    procedure LoadFrameData; override;
    procedure SaveFrameData; override;

    class function SimpleForm(aEmuteca : cEmuteca;
      SelectedSystem : cEmutecaSystem;
      const aGUIConfigIni, aGUIIconsIni : string) : Integer;
    //< Creates a form with TfmEmutecaActAddSoft frame.

    constructor Create(TheOwner : TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

{ TfmEmutecaActAddSoft }

procedure TfmEmutecaActAddSoft.ClearFrameData;
begin
  inherited ClearFrameData;

  fmSystemCBX.SelectedSystem := nil;
  fmGroupCBX.SelectedGroup := nil;
  fmSoftEditor.Software := nil;

  rgbSoftKey.ItemIndex := 0;
  eFile.Clear;
  chkOpenAsArchive.Checked := False;
  cbxInnerFile.ItemIndex := -1;
  eVersionKey.Clear;
  lDupFile.Caption := ' ';
  lCompressedError.Caption := ' ';
end;

procedure TfmEmutecaActAddSoft.UpdateFileData;
begin
  fmSoftEditor.Software := nil;

  if not Assigned(Software) then
    Exit;

  Software.Folder := ExtractFileDir(eFile.FileName);
  Software.FileName := ExtractFileName(eFile.FileName);
  Software.SHA1 := kCHXSHA1Empty;

  Software.CachedGroup := fmGroupCBX.SelectedGroup;
  if not Assigned(Software.CachedGroup) then
    Software.GroupKey := ExtractFileNameOnly(
      ExcludeTrailingPathDelimiter(Software.Folder));

  Software.Title := ExtractFileNameOnly(Software.FileName);

  UpdateSoftKey;
  UpdateDupInfo;

  fmSoftEditor.Software := Software;
end;

procedure TfmEmutecaActAddSoft.UpdateInnerFileData;
begin
  fmSoftEditor.Software := nil;

  if not Assigned(Software) then
    Exit;

  Software.Folder := eFile.FileName;
  Software.FileName := cbxInnerFile.Text;
  Software.SHA1 := kCHXSHA1Empty;

  Software.CachedGroup := fmGroupCBX.SelectedGroup;
  if not Assigned(Software.CachedGroup) then
    Software.GroupKey := ExtractFileNameOnly(
      ExcludeTrailingPathDelimiter(Software.Folder));
  Software.Title := ExtractFileNameOnly(Software.FileName);

  UpdateSoftKey;
  UpdateDupInfo;

  fmSoftEditor.Software := Software;
end;

procedure TfmEmutecaActAddSoft.UpdateSoftKey;
var
  aFile : string;
begin
  // We use selected rgbSoftKey, not system default
  if not chkOpenAsArchive.Checked then
  begin // Non compressed file
    aFile := Software.Folder + Software.FileName;
    if not FileExistsUTF8(aFile) then
      Exit;

    case rgbSoftKey.ItemIndex of
      0 : // TEFKSHA1
        Software.ID := '';
      1 : // TEFKCRC32
        Software.ID := CRC32FileStr(aFile);

      2, 3 : // TEFKCustom and TEFKFileName
        Software.ID := ExtractFileNameOnly(Software.FileName);
      else // By default TEFKSHA1
      begin
        Software.ID := '';
      end;
    end;
  end
  else  // Compressed file
  begin
    aFile := ExcludeTrailingPathDelimiter(Software.Folder);
    if not FileExistsUTF8(aFile) then
      Exit;

    case rgbSoftKey.ItemIndex of
      0 : //TEFKSHA1
        Software.ID := '';
      1 : // TEFKCRC32
      begin
        Software.ID := w7zCRC32InnerFileStr(aFile, Software.FileName, '');
      end;

      2, 3 : // TEFKCustom and TEFKFileName
        Software.ID := ExtractFileNameOnly(Software.FileName);

      else // By default TEFKSHA1
      begin
        Software.ID := '';
      end;
    end;
  end;

  eVersionKey.Text := Software.ID;
  eVersionKey.Enabled := rgbSoftKey.ItemIndex = 2;
end;

procedure TfmEmutecaActAddSoft.UpdateDupInfo;
var
  aSoftList : cEmutecaSoftList;
  i : Integer;
  FoundFile : Boolean;
begin
  lDupFile.Caption := '';

  if not assigned(fmSystemCBX.SelectedSystem) then
    Exit;

  aSoftList := fmSystemCBX.SelectedSystem.SoftManager.FullList;

  i := 0;
  FoundFile := False;
  while (not FoundFile) and (i < aSoftList.Count) do
  begin
    if Software.MatchFile(aSoftList[i].Folder, aSoftList[i].FileName) then
      FoundFile := True;

    Inc(i);
  end;

  if FoundFile then
    lDupFile.Caption := rsFileAlreadyAdded;
end;

procedure TfmEmutecaActAddSoft.SelectSystem(aSystem : cEmutecaSystem);
var
  ExtFilter : string;
begin
  fmSoftEditor.Software := nil;

  Software.CachedSystem := aSystem;

  if Assigned(aSystem) then
  begin
    // Loading data if not already loaded
    Emuteca.SystemManager.LoadSystemData(aSystem);
    fmGroupCBX.GroupList := aSystem.GroupManager.FullList;
  end
  else
    fmGroupCBX.GroupList := nil;

  gbxFileSelection.Enabled := assigned(Software.CachedSystem);
  rgbSoftKey.Enabled := gbxFileSelection.Enabled;

  fmSoftEditor.Software := Software;

  if not assigned(Software.CachedSystem) then
    Exit;

  // Autoselecting Key Type
  case Software.CachedSystem.SoftExportKey of
    TEFKSHA1 : rgbSoftKey.ItemIndex := 0;
    TEFKCRC32 : rgbSoftKey.ItemIndex := 1;
    TEFKCustom : rgbSoftKey.ItemIndex := 2;
    TEFKFileName : rgbSoftKey.ItemIndex := 3;
    else  // SHA1 by default
      rgbSoftKey.ItemIndex := 0;
  end;

  lSystemInfo.Caption := Software.CachedSystem.Extensions.CommaText;

  ExtFilter := 'All suported files' + '|';
  if Software.CachedSystem.Extensions.Count > 0 then
    ExtFilter := ExtFilter + FileMaskFromStringList(
      Software.CachedSystem.Extensions) + ';';
  ExtFilter := ExtFilter + FileMaskFromCommaText(w7zGetFileExts);
  ExtFilter := ExtFilter + '|' + 'All files' + '|' + AllFilesMask;
  eFile.Filter := ExtFilter;

  eFile.InitialDir := CreateAbsolutePath(Software.CachedSystem.BaseFolder,
    ProgramDirectory);

  UpdateSoftKey;
end;

procedure TfmEmutecaActAddSoft.SelectGroup(aGroup : cEmutecaGroup);
begin
  Software.CachedGroup := aGroup;
end;

procedure TfmEmutecaActAddSoft.cbxInnerFileChange(Sender : TObject);
begin
  UpdateInnerFileData;
end;

procedure TfmEmutecaActAddSoft.actAddNewGroupExecute(Sender : TObject);
var
  GroupTitle : string;
  aGroup : cEmutecaGroup;
  aSystem : cEmutecaSystem;
begin
  if not Assigned(Software) then Exit;
  if not Assigned(Software.CachedSystem) then Exit;

  fmGroupCBX.GroupList := nil;

  GroupTitle := Software.Title;

  if InputQuery('New group', 'Name of the new group.', GroupTitle) = False then
    Exit;

  aGroup := cEmutecaGroup.Create;
  aGroup.ID := GroupTitle;
  aGroup.Title := GroupTitle;

  aSystem := cEmutecaSystem(Software.CachedSystem);

  aSystem.AddGroup(aGroup);

  fmGroupCBX.GroupList := aSystem.GroupManager.FullList;
  fmGroupCBX.SelectedGroup := aGroup;

  Software.CachedGroup := aGroup;
end;

procedure TfmEmutecaActAddSoft.chkOpenAsArchiveChange(Sender : TObject);

  procedure AnError(aText : string);
  begin
    lCompressedError.Caption := aText;
    chkOpenAsArchive.Checked := False;
    cbxInnerFile.ItemIndex := -1;
    cbxInnerFile.Enabled := False;
  end;
begin
  cbxInnerFile.Clear;

  if chkOpenAsArchive.Checked then
  begin
    if not SupportedExtSL(eFile.FileName,
      Emuteca.Config.CompressedExtensions) then
    begin
      AnError('It''s not a compressed file.');
      Exit;
    end;

    if not FileExistsUTF8(eFile.FileName) then
    begin
      AnError('Compressed file not found.');
      Exit;
    end;

    w7zListFiles(eFile.FileName, cbxInnerFile.Items, True, '');

    if cbxInnerFile.Items.Count = 0 then
    begin
      AnError('No files found.');
      Exit;
    end;

    lCompressedError.Caption :=
      format('%0:d files found.', [cbxInnerFile.Items.Count]);
    cbxInnerFile.Enabled := True;
  end
  else
  begin
    // Reverting to normal file data
    lCompressedError.Caption := ' ';
    cbxInnerFile.ItemIndex := -1;
    cbxInnerFile.Enabled := False;
    UpdateFileData;
  end;
end;

procedure TfmEmutecaActAddSoft.eFileAcceptFileName(Sender : TObject;
  var Value : string);
begin
  // It's called before Text is updated
  eFile.Text := Value;

  SelectFile;
end;

procedure TfmEmutecaActAddSoft.eFileEditingDone(Sender : TObject);
begin
  SelectFile;
end;

procedure TfmEmutecaActAddSoft.eVersionKeyEditingDone(Sender : TObject);
begin
  Software.ID := eVersionKey.Text;
end;

procedure TfmEmutecaActAddSoft.rgbSoftKeySelectionChanged(Sender : TObject);
begin
  UpdateSoftKey;
end;

procedure TfmEmutecaActAddSoft.SetEmuteca(aValue : cEmuteca);
begin
  if FEmuteca = aValue then
    Exit;
  FEmuteca := aValue;

  if assigned(Emuteca) then
    fmSystemCBX.SystemList := Emuteca.SystemManager.EnabledList
  else
    fmSystemCBX.SystemList := nil;
  fmSystemCBX.SelectedSystem := nil;

  fmSoftEditor.Software := Software;

  LoadFrameData;
end;

procedure TfmEmutecaActAddSoft.SetSoftware(aValue : cEmutecaSoftware);
begin
  if FSoftware = aValue then
    Exit;
  FSoftware := aValue;

  LoadFrameData;
end;

procedure TfmEmutecaActAddSoft.SelectFile;
begin
  chkOpenAsArchive.Checked := False;
  cbxInnerFile.Enabled := False;
  cbxInnerFile.Clear;

  UpdateFileData;

  // Recognized ext of an archive (from cEmutecaConfig, not u7zWrapper)
  chkOpenAsArchive.Enabled :=
    SupportedExtSL(eFile.FileName, Emuteca.Config.CompressedExtensions);
end;

procedure TfmEmutecaActAddSoft.LoadFrameData;
begin
  inherited LoadFrameData;

  Enabled := Assigned(Software) and Assigned(Emuteca);

  if not Enabled then
  begin
    ClearFrameData;
    Exit;
  end;
end;

procedure TfmEmutecaActAddSoft.SaveFrameData;
var
  aSystem : cEmutecaSystem;
begin
  inherited SaveFrameData;

  if not assigned(Emuteca) then
    Exit;

  fmSoftEditor.SaveFrameData;

  // No group was assigned
  if not Assigned(Software.CachedGroup) then
    Software.GroupKey := Software.Title;

  aSystem := cEmutecaSystem(Software.CachedSystem);

  if not assigned(aSystem) then
    Exit;

  // Loading data if not already loaded
  Emuteca.SystemManager.LoadSystemData(aSystem);
  Emuteca.CacheDataStop;

  aSystem.AddSoft(Software);

  // If we don't close then prepare to add a new software
  //   if we close, it will be freed on destroy
  FSoftware := cEmutecaSoftware.Create;
  ClearFrameData;

  Emuteca.CacheData;

  fmSoftEditor.Software := Software;
end;

class function TfmEmutecaActAddSoft.SimpleForm(aEmuteca : cEmuteca;
  SelectedSystem : cEmutecaSystem;
  const aGUIConfigIni, aGUIIconsIni : string) : Integer;
var
  aFrame : TfmEmutecaActAddSoft;
begin
  aFrame := TfmEmutecaActAddSoft.Create(nil);
  aFrame.SaveButtons := True;
  aFrame.ButtonClose := True;
  aFrame.Align := alClient;

  aFrame.Emuteca := aEmuteca;
  aFrame.fmSystemCBX.SelectedSystem := SelectedSystem;
  // fmSystemCBX.SelectedSystem don't trigger SetSystem() callback.
  aFrame.SelectSystem(SelectedSystem);

  Result := GenSimpleModalForm(aFrame, 'frmEmutecaActAddSoft',
    Format(krsFmtWindowCaption, [Application.Title, rsFormAddSoftware]),
    aGUIConfigIni, aGUIIconsIni);
end;

constructor TfmEmutecaActAddSoft.Create(TheOwner : TComponent);

  procedure CreateFrames;
  begin
    FfmSystemCBX := TfmEmutecaSystemCBX.Create(gbxSelectSystem);
    fmSystemCBX.Align := alTop;
    fmSystemCBX.OnSelectSystem := @SelectSystem;
    fmSystemCBX.FirstItem := ETKSysCBXFISelect;
    fmSystemCBX.Parent := gbxSelectSystem;

    FfmGroupCBX := TfmEmutecaGroupCBX.Create(gbxGroup);
    fmGroupCBX.Align := alClient;
    fmGroupCBX.OnSelectGroup := @SelectGroup;
    fmGroupCBX.Parent := gbxGroup;

    FfmSoftEditor := TfmEmutecaSoftEditor.Create(gbxSoftInfo);
    fmSoftEditor.Align := alClient;
    fmSoftEditor.SaveButtons := False;
    fmSoftEditor.ButtonClose := False;
    fmSoftEditor.Parent := gbxSoftInfo;
  end;
begin
  inherited Create(TheOwner);

  Enabled := False;

  CreateFrames;

  FSoftware := cEmutecaSoftware.Create;
end;

destructor TfmEmutecaActAddSoft.Destroy;
begin
  FreeAndNil(FSoftware);
  inherited Destroy;
end;

initialization
  RegisterClass(TfmEmutecaActAddSoft);

finalization
  UnRegisterClass(TfmEmutecaActAddSoft);
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
