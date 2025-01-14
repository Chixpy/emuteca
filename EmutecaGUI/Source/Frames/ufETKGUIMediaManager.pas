unit ufETKGUIMediaManager;

{< TfmETKGUIMediaManager frame unit.

  This file is part of Emuteca GUI.

  Copyright (C) 2006-2024 Chixpy
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, VirtualTrees, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, ComCtrls, StdCtrls, ActnList, LCLIntf,
  LCLType, Buttons, EditBtn, Menus, LazFileUtils, LazUTF8, IniFiles,
  // CHX units
  uCHXRscStr, uCHXStrUtils, uCHXImageUtils, uCHXFileUtils, uCHXDlgUtils,
  // CHX frames
  ufCHXFrame, ufCHXFileListPreview, ufCHXImgListPreview,
  ufCHXTxtListPreview, ufCHXProgressBar,
  // CHX forms
  ufrCHXForm,
  // Emuteca Core units
  uEmutecaConst, uEmutecaRscStr, uEmutecaCommon,
  // Emuteca Core abstract classes
  uaEmutecaCustomSGItem,
  // Emuteca Core classes
  ucEmuteca, ucEmutecaSystem, ucEmutecaGroup, ucEmutecaSoftware,
  // Emuteca Core frames
  ufEmutecaSystemCBX, ufEmutecaGroupEditor, ufETKGUIFullSoftEditor,
  // Emuteca GUI units
  uETKGUIConst,
  // Emuteca GUI classes
  ucETKGUIConfig;

const
  krsETKMMFormName = 'frmETKGUIMediaManager';

  krsIniETKMediaMngSection = 'Media Manager';
  {< Config file section name. }
  krsIniETKMediaMngVSTColumnsFmt = '%0:s_Column%1:d_Witdh';
  krsIniETKMediaMngPLeftWitdh = 'PLeft_Width';
  krsIniETKMediaMngPRightWidth = 'PRight_Width';
  krsIniETKMediaMngSourceHeight = 'Source_Height';
  krsIniETKMediaMngSoftGHeight = 'SoftG_Height';

resourcestring
  rsETKMMSearching = 'Searching...';
  rsETKMMSomeTime = 'This can take some time';
  rsETKMMFilesGroups = 'Files without group and groups without file';
  rsETKMMFilesSoft = 'Files without soft and soft without file';
  rsETKMMDeleteAll = 'Do you want delete ALL visible files?';
  rsETKMMFormCaption = 'Media Manager';

type
  // Data stored in File Trees
  TFileRow = record
    FileName : string;
    Extension : string;
  end;
  PFileRow = ^TFileRow;

  { TfmETKGUIMediaManager }

  TfmETKGUIMediaManager = class(TfmCHXFrame)
    actAssignFile : TAction;
    actDeleteFile : TAction;
    actDeleteAllFiles : TAction;
    actEditSoft : TAction;
    actAutoAssign : TAction;
    actAssignToGroup : TAction;
    actOpenFileDefApp : TAction;
    actOpenTargetFolder : TAction;
    actRunSoftware : TAction;
    actRenameFile : TAction;
    actRenameSoftTitleWithFilename : TAction;
    actRenameGroupTitleWithFilename : TAction;
    actMoveAllFiles : TAction;
    actMoveFile : TAction;
    actEditGroup : TAction;
    ActionList : TActionList;
    bAutoAssign : TButton;
    bOpenFolder : TButton;
    bRename : TBitBtn;
    cbxImages : TComboBox;
    cbxTexts : TComboBox;
    cbxMusic : TComboBox;
    cbxOtherFolders : TComboBox;
    cbxVideos : TComboBox;
    chkCopyFile : TCheckBox;
    eOtherFolder : TDirectoryEdit;
    gbxImages : TGroupBox;
    gbxMusic : TGroupBox;
    gbxOtherFolders : TGroupBox;
    gbxRename : TGroupBox;
    gbxSource : TGroupBox;
    gbxSystem : TGroupBox;
    gbxTarget : TGroupBox;
    gbxTexts : TGroupBox;
    gbxVideos : TGroupBox;
    ilActions : TImageList;
    lFilterThreshold : TLabel;
    MenuItem1 : TMenuItem;
    MenuItem3 : TMenuItem;
    misfAssignToGroup : TMenuItem;
    migpRunSoftware : TMenuItem;
    miflRenameFile : TMenuItem;
    migpRenameSoftTitleWithFilename : TMenuItem;
    misfEditSoftware : TMenuItem;
    misfAssignFile : TMenuItem;
    migpRenameGroupTitleWithFilename : TMenuItem;
    miflDeleteAllFiles : TMenuItem;
    miflMoveAllFiles : TMenuItem;
    miflMoveFile : TMenuItem;
    MenuItem4 : TMenuItem;
    miflDeleteFile : TMenuItem;
    miflAssignFile : TMenuItem;
    migpEditGroup : TMenuItem;
    MenuItem2 : TMenuItem;
    migpAssignFile : TMenuItem;
    pCenter : TPanel;
    pcSource : TPageControl;
    pcTarget : TPageControl;
    pFilesOtherFolderDir : TPanel;
    pImagePreview : TPanel;
    pLeft : TScrollBox;
    pumVSTFiles : TPopupMenu;
    pRight : TPanel;
    pSimilar : TPanel;
    pTextPreview : TPanel;
    pumVSTGroups : TPopupMenu;
    pumVSTSoft : TPopupMenu;
    rgbFilterMode : TRadioGroup;
    sbSourceList : TStatusBar;
    sbSource : TStatusBar;
    sbTarget : TStatusBar;
    sbTargetList : TStatusBar;
    SelectDirectoryDialog1 : TSelectDirectoryDialog;
    Separator1 : TMenuItem;
    Separator2 : TMenuItem;
    Separator3 : TMenuItem;
    Splitter1 : TSplitter;
    Splitter2 : TSplitter;
    Splitter3 : TSplitter;
    pagAllFiles : TTabSheet;
    pagFilesWOGroup : TTabSheet;
    pagFilesWOSoft : TTabSheet;
    pagFilesOtherFolder : TTabSheet;
    pagAllGroups : TTabSheet;
    pagGroupsWOFile : TTabSheet;
    pagAllSoft : TTabSheet;
    pagSoftWOFile : TTabSheet;
    pagOtherFiles : TTabSheet;
    Splitter4 : TSplitter;
    Splitter5 : TSplitter;
    Splitter6 : TSplitter;
    tbSimilarThresold : TTrackBar;
    vstFilesAll : TVirtualStringTree;
    vstFilesOtherExt : TVirtualStringTree;
    vstFilesWOGroup : TVirtualStringTree;
    vstFilesWOSoft : TVirtualStringTree;
    vstFilesOtherFolder : TVirtualStringTree;
    vstGroupsAll : TVirtualStringTree;
    vstGroupsWOFile : TVirtualStringTree;
    vstSoftOfGroupsAll : TVirtualStringTree;
    vstSoftAll : TVirtualStringTree;
    vstSoftWOFile : TVirtualStringTree;
    vstSoftOfGroupsWOFile : TVirtualStringTree;
    procedure actAssignFileExecute(Sender : TObject);
    procedure actAssignToGroupExecute(Sender : TObject);
    {< Renames (or copies) selected file to required filename by selected
       group or soft. }
    procedure actAutoAssignExecute(Sender : TObject);
    procedure actDeleteAllFilesExecute(Sender : TObject);
    {< Deletes all VISIBLE (i.e. no hidden) files from the current list
       FROM DISC PHYSICALLY. }
    procedure actDeleteFileExecute(Sender : TObject);
    {< Deletes current selected (source) file FROM DISC PHYSICALLY. }
    procedure actEditSoftExecute(Sender : TObject);
    procedure actMoveAllFilesExecute(Sender : TObject);
    {< Moves all VISIBLE (i.e. no hidden) files from the current list to
        another folder. }
    procedure actMoveFileExecute(Sender : TObject);
    {< Moves current selected (source) file to another folder. }
    procedure actEditGroupExecute(Sender : TObject);
    procedure actOpenFileDefAppExecute(Sender : TObject);
    procedure actOpenTargetFolderExecute(Sender : TObject);
    procedure actRenameFileExecute(Sender : TObject);
    {< Renames manually a file. If already exists "(n)" is added automatically.}
    procedure actRenameGroupTitleWithFilenameExecute(Sender : TObject);
    procedure actRenameSoftTitleWithFilenameExecute(Sender : TObject);
    procedure actRunSoftwareExecute(Sender : TObject);
    procedure cbxFolderSelected(Sender : TObject);
    procedure chkSimilarFilesChange(Sender : TObject);
    procedure eOtherFolderAcceptDirectory(Sender : TObject;
      var Value : string);
    procedure pcSourceChange(Sender : TObject);
    procedure pcTargetChange(Sender : TObject);
    procedure rgbFilterModeSelectionChanged(Sender : TObject);
    procedure tbSimilarThresoldClick(Sender : TObject);
    procedure vstFileCompareNodes(Sender : TBaseVirtualTree;
      Node1, Node2 : PVirtualNode; Column : TColumnIndex;
      var Result : Integer);
    procedure vstFileKeyDown(Sender : TObject; var Key : Word;
      Shift : TShiftState);
    procedure vstFilesGetNodeDataSize(Sender : TBaseVirtualTree;
      var NodeDataSize : Integer);
    procedure vstFilesOtherFolderChange(Sender : TBaseVirtualTree;
      Node : PVirtualNode);
    procedure vstFilesChange(Sender : TBaseVirtualTree;
      Node : PVirtualNode);
    procedure vstNodeClick(Sender : TBaseVirtualTree;
      const HitInfo : THitInfo);
    procedure vstGroupCompareNodes(Sender : TBaseVirtualTree;
      Node1, Node2 : PVirtualNode; Column : TColumnIndex;
      var Result : Integer);
    procedure vstSGKeyDown(Sender : TObject; var Key : Word;
      Shift : TShiftState);
    procedure vstFileFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
    procedure vstFileGetText(Sender : TBaseVirtualTree;
      Node : PVirtualNode; Column : TColumnIndex; TextType : TVSTTextType;
      var CellText : string);
    procedure vstSoftGroupChange(Sender : TBaseVirtualTree;
      Node : PVirtualNode);
    procedure vstGroupsAllInitNode(Sender : TBaseVirtualTree;
      ParentNode, Node : PVirtualNode;
      var InitialStates : TVirtualNodeInitStates);
    procedure vstKeyPress(Sender : TObject; var Key : char);
    procedure vstSoftCompareNodes(Sender : TBaseVirtualTree;
      Node1, Node2 : PVirtualNode; Column : TColumnIndex;
      var Result : Integer);
    procedure vstSoftGetText(Sender : TBaseVirtualTree;
      Node : PVirtualNode; Column : TColumnIndex; TextType : TVSTTextType;
      var CellText : string);
    procedure vstGroupGetText(Sender : TBaseVirtualTree;
      Node : PVirtualNode; Column : TColumnIndex; TextType : TVSTTextType;
      var CellText : string);

  private
    FCurrExtFilter : TStringList;
    FCurrSystem : cEmutecaSystem;
    FEmuteca : cEmuteca;
    FfmImagePreview : TfmCHXImgListPreview;
    FfmProgressBar : TfmCHXProgressBar;
    FfmSystemCBX : TfmEmutecaSystemCBX;
    FfmTextPreview : TfmCHXTxtListPreview;
    FGUIConfig : cETKGUIConfig;
    FMediaFiles : TStringList;
    FSHA1Folder : string;
    FSourceFile : string;
    FSourceFolder : string;
    FTargetFile : string;
    FTargetFolder : string;
    procedure SetCurrSystem(aValue : cEmutecaSystem);
    procedure SetEmuteca(aValue : cEmuteca);
    procedure SetGUIConfig(aValue : cETKGUIConfig);
    procedure SetSHA1Folder(const aValue : string);
    procedure SetSourceFile(const aValue : string);
    procedure SetSourceFolder(const aValue : string);
    procedure SetTargetFile(const aValue : string);
    procedure SetTargetFolder(const aValue : string);

  protected
    {property} CurrentSG : caEmutecaCustomSGItem;
    {< Current selected soft or group. }
    {property} CurrPreview : TfmCHXFileListPreview;
    {< Current selected file list. }


    // Frames
    // ------

    property fmSystemCBX : TfmEmutecaSystemCBX read FfmSystemCBX;
    property fmImagePreview : TfmCHXImgListPreview read FfmImagePreview;
    property fmTextPreview : TfmCHXTxtListPreview read FfmTextPreview;
    property fmProgressBar : TfmCHXProgressBar read FfmProgressBar;


    // Properties
    // ----------

    property CurrSystem : cEmutecaSystem read FCurrSystem write SetCurrSystem;
    {< Current selected system. }

    property CurrExtFilter : TStringList read FCurrExtFilter;
    {< Extensions of the current selected Media. }
    property MediaFiles : TStringList read FMediaFiles;
    {< Mediafiles assigned to the current game or group. }

    property SourceFile : string read FSourceFile write SetSourceFile;
    {< Name of the source file. }
    property SourceFolder : string read FSourceFolder write SetSourceFolder;
    {< Folder of the source file. }
    property TargetFile : string read FTargetFile write SetTargetFile;
    {< Name of the target file. Without extension. }
    property TargetFolder : string read FTargetFolder write SetTargetFolder;
    {< Folder of the target file. }

    procedure UpdateVST(aFolder : string);
    {< Update the Virtual String Trees.
      @param(aFolder Folder where search the files and media.)
    }

    procedure FilterLists;
    {< Filters list with similar filename or groups (depending on filter mode) }

    procedure UpdateListCount;
    {< Updates status bars with item count. }

    function SelectSystem(aSystem : cEmutecaSystem) : Boolean;
    {< Selects a system. }

    procedure LoadSysFolders;
    {< Loads CurrSystem folders in lbx. }
    procedure LoadSystemSoft;
    {< Loads software from the system in vstSoftAll, except software wich
      its filename is the same of its group's filename. }


    // File lists
    // ----------

    function GetCurrentFilesVST : TCustomVirtualStringTree;
    {< Returns the current file list shown. }

    function AddFileCB(const aFolder : string; const Info : TSearchRec) : Boolean;
    {< Adds a file to the lists.
      For use with IterateFolder.
      @param(aFolder Folder where the file is in. @(Not used@))
      @param(Info TSearchRec with file data.)
      @return(Always @true; needed for IterateFolder.)
    }
    function AddFileVSTAllFiles(const aName : string) : Boolean;
    {< Adds a file to the lists.

      @param(aName Name of the file with extension.)
      @return(Always @true @(useless until a reason to stop batch operations
        will be found when adding automatically.@).)
    }
    procedure RemoveFileVSTFiles(const aFile : string);
    {< Remove a file from lists (not physically).
      If TargetFolder <> SourceFolder then removed from vstFilesOtherFolder.
      Used for hacky updates.
      @param(aFile Name of the file.)
    }


    // Group / Soft lists
    // ------------------

    function GetCurrentGSVST : TCustomVirtualStringTree;
    {< Returns the current file list shown. }

    procedure RemoveGroupSoftWOFile(const aFile : string);
    {< Remove groups from vstGroupsWOFile and  vstSoftWOFile lists that have
         aFile.
      Used for hacky updates.
      @param(aFile Name of file that maybe is used by groups or soft.)
    }


    // Media
    // -----

    procedure ChangeSGMedia(SGItem : caEmutecaCustomSGItem);
    {< Change the media preview to the current soft or group media.
      @param(SGItem The soft or  group with it's media will be previewed.)
    }

    procedure ChangeFileMedia(const aFolder, aFileName : string);
    {< Change the media preview to the file.
      @param(aFolder Folder were the file is.)
      @param(aName Name of the file.)
    }

    function AddFilesOtherFolderCB(const aFolder : string;
      const Info : TSearchRec) : Boolean;
    {< Add files or folders to vstFilesOtherFolder.
      @param(aFolder Folder where the file is in. @(not used@))
      @param(Info TSearchRec with folder or file data.)
      @return(Always @true; needed for IterateFolder.)
    }

    procedure UpdateFileOtherFolder(aFolder : string);

    procedure OpenGroupEditor(const NewTitle : string = '');
    {< Opens GroupEditor with current selected group, and set a new name.}
    procedure OpenSoftEditor(const NewTitle : string = '');
    {< Opens SoftEditor with current selected group, and set a new name.}

    procedure DoLoadGUIConfig(aIniFile : TIniFile); override;
    procedure DoSaveGUIConfig(aIniFile : TIniFile); override;
    procedure DoLoadGUIIcons(aIconsIni : TIniFile;
      const aBaseFolder : string); override;

  public
    property Emuteca : cEmuteca read FEmuteca write SetEmuteca;
    {< Emuteca Core. }
    property SHA1Folder : string read FSHA1Folder write SetSHA1Folder;
    {< Folder SHA1 caché is stored. }
    property GUIConfig : cETKGUIConfig read FGUIConfig write SetGUIConfig;
    {< Config of GUI. }

    procedure LoadFrameData; override;

    class function SimpleForm(aEmuteca : cEmuteca;
      SelectedSystem : cEmutecaSystem; aGUIConfig : cETKGUIConfig;
      const aGUIIconsIni : string) : Integer;
    {< Creates a form with Media Manager. }

    constructor Create(TheOwner : TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

{ TfmETKGUIMediaManager }

procedure TfmETKGUIMediaManager.SetSHA1Folder(const aValue : string);
begin
  FSHA1Folder := SetAsFolder(aValue);
end;

procedure TfmETKGUIMediaManager.SetSourceFile(const aValue : string);
begin
  FSourceFile := SetAsFile(aValue);
  sbSource.Panels[1].Text := SourceFolder + SourceFile;
end;

procedure TfmETKGUIMediaManager.SetSourceFolder(const aValue : string);
begin
  FSourceFolder := SetAsFolder(aValue);
  sbSource.Panels[1].Text := SourceFolder + SourceFile;
end;

procedure TfmETKGUIMediaManager.SetTargetFile(const aValue : string);
begin
  FTargetFile := SetAsFile(aValue);
  sbTarget.Panels[1].Text := TargetFolder + TargetFile;
end;

procedure TfmETKGUIMediaManager.SetTargetFolder(const aValue : string);
begin
  FTargetFolder := SetAsFolder(aValue);
  sbTarget.Panels[1].Text := TargetFolder + TargetFile;
end;

procedure TfmETKGUIMediaManager.DoLoadGUIIcons(aIconsIni : TIniFile;
  const aBaseFolder : string);
begin
  inherited DoLoadGUIIcons(aIconsIni, aBaseFolder);

  ReadActionsIconsIni(aIconsIni, aBaseFolder, Self.Name,
    ilActions, ActionList);
end;

procedure TfmETKGUIMediaManager.UpdateVST(aFolder : string);
var
  GroupNode, SoftNode, FileNode : PVirtualNode;
  aFileName : TFileRow;
  pFileName : PFileRow;
  aGroup : cEmutecaGroup;
  pGroup : ^cEmutecaGroup;
  aSoft : cEmutecaSoftware;
  pSoft : ^cEmutecaSoftware;
  TmpStr : string;
  FileComp, SkipComp : Integer;
begin
  aFolder := SetAsFolder(aFolder);
  if not DirectoryExistsUTF8(aFolder) then
    Exit;

  TargetFolder := aFolder;
  SourceFolder := aFolder;
  SourceFile := '';
  TargetFile := '';

  // Adding all files/folders of the target folder
  vstFilesAll.BeginUpdate;
  vstFilesAll.Clear;
  vstFilesOtherExt.BeginUpdate;
  vstFilesOtherExt.Clear;
  fmProgressBar.UpdTextAndBar(rsETKMMSearching,
    rsETKMMSomeTime, 1, 4, False);
  IterateFolderObj(aFolder, @AddFileCB, False);
  vstFilesAll.EndUpdate;
  vstFilesOtherExt.EndUpdate;

  // vstFilesAll -> vstFilesWOGroup and
  //   vstGroupsAll -> vstGroupsWOFile.
  // ----------------------------------
  fmProgressBar.UpdTextAndBar(rsETKMMSearching, rsETKMMFilesGroups,
    2, 4, False);

  // Sorting vstFilesAll and vstGroupsAll to iterate them;
  vstFilesAll.SortTree(0, VirtualTrees.sdAscending, True); // By filename
  vstGroupsAll.SortTree(0, VirtualTrees.sdAscending, True); // By filename

  vstFilesWOGroup.BeginUpdate;
  vstFilesWOGroup.Clear;
  vstGroupsWOFile.BeginUpdate;
  vstGroupsWOFile.Clear;
  GroupNode := vstGroupsAll.GetFirstChild(nil);
  FileNode := vstFilesAll.GetFirstChild(nil);
  while assigned(GroupNode) or assigned(FileNode) do
  begin
    if not assigned(GroupNode) then
    begin
      pGroup := nil;
      aGroup := nil;
      pFileName := vstFilesAll.GetNodeData(FileNode);
      aFileName := pFileName^;
      FileComp := -1; // Advance File
    end
    else if not assigned(FileNode) then
    begin
      pGroup := vstGroupsAll.GetNodeData(GroupNode);
      aGroup := pGroup^;
      pFileName := nil;
      Finalize(aFileName);
      FileComp := 1;  // Advance Group
    end
    else
    begin
      pFileName := vstFilesAll.GetNodeData(FileNode);
      aFileName := pFileName^;
      pGroup := vstGroupsAll.GetNodeData(GroupNode);
      aGroup := pGroup^;
      FileComp := CompareFilenames(aFileName.FileName, aGroup.MediaFileName);
    end;


    // Adding to VST if they don't match
    // if FileComp = 0 then Match!! only skip files
    if FileComp < 0 then
    begin // Not match, File is behind Group
      pFileName := vstFilesWOGroup.GetNodeData(
        vstFilesWOGroup.AddChild(nil));
      pFileName^ := aFileName;
    end
    else if FileComp > 0 then // Not match, Group is behind Group File
    begin
      pGroup := vstGroupsWOFile.GetNodeData(
        vstGroupsWOFile.AddChild(nil));
      pGroup^ := aGroup;
    end;

    // Getting next nodes of VST
    // FileComp = 0 executes both
    if FileComp <= 0 then
    begin
      // Next file
      FileNode := vstFilesAll.GetNextSibling(FileNode);

      // Skip repeated file with same name (can be with different extension)
      SkipComp := 0;
      TmpStr := aFileName.FileName; // Old filename
      while Assigned(FileNode) and (SkipComp = 0) do
      begin
        pFileName := vstFilesAll.GetNodeData(FileNode);
        aFileName := pFileName^;
        SkipComp := CompareFilenames(aFileName.FileName, TmpStr);
        if SkipComp = 0 then
          FileNode := vstFilesAll.GetNextSibling(FileNode);
      end;
    end;

    if FileComp >= 0 then
    begin
      // Next group
      GroupNode := vstGroupsAll.GetNextSibling(GroupNode);

      // Skip groups with same media file
      SkipComp := 0;
      TmpStr := aGroup.MediaFileName; // Old MediaFileName
      while Assigned(GroupNode) and (SkipComp = 0) do
      begin
        pGroup := vstGroupsAll.GetNodeData(GroupNode);
        aGroup := pGroup^;
        SkipComp := CompareFilenames(aGroup.MediaFileName, TmpStr);
        if SkipComp = 0 then
          GroupNode := vstGroupsAll.GetNextSibling(GroupNode);
      end;
    end;
  end;
  vstFilesWOGroup.EndUpdate;
  vstGroupsWOFile.EndUpdate;


  // vstFilesWOGroup -> vstFilesWOSoft and
  //   vstSoftAll -> vstSoftWOFile.
  // -------------------------------------
  fmProgressBar.UpdTextAndBar(rsETKMMSearching,
    rsETKMMFilesSoft, 3, 4, False);

  // Sorting vstFilesWOGroup and vstvstAllGroups to iterate them;
  vstFilesWOGroup.SortTree(0, VirtualTrees.sdAscending, True); // By filename
  vstSoftAll.SortTree(0, VirtualTrees.sdAscending, True); // By filename

  vstFilesWOSoft.BeginUpdate;
  vstFilesWOSoft.Clear;
  vstSoftWOFile.BeginUpdate;
  vstSoftWOFile.Clear;
  SoftNode := vstSoftAll.GetFirstChild(nil);
  FileNode := vstFilesWOGroup.GetFirstChild(nil);
  while (assigned(SoftNode)) or (assigned(FileNode)) do
  begin

    // Reading nodes
    if not assigned(SoftNode) then
    begin
      aSoft := nil;
      pSoft := nil;
      pFileName := vstFilesWOGroup.GetNodeData(FileNode);
      aFileName := pFileName^;
      // Advance File
      FileComp := -1;
    end
    else if not assigned(FileNode) then
    begin
      pSoft := vstSoftAll.GetNodeData(SoftNode);
      aSoft := pSoft^;
      pFileName := nil;
      Finalize(aFileName);
      // Advance soft
      FileComp := 1;
    end
    else
    begin
      pFileName := vstFilesWOGroup.GetNodeData(FileNode);
      aFileName := pFileName^;
      pSoft := vstSoftAll.GetNodeData(SoftNode);
      aSoft := pSoft^;

      FileComp := CompareFilenames(aFileName.FileName, aSoft.MediaFileName);
    end;

    // Adding to vst if they don't match
    //if FileComp = 0 then // Match!! only skip files
    if FileComp < 0 then
    begin // Not match, File is behind Soft
      pFileName := vstFilesWOSoft.GetNodeData(
        vstFilesWOSoft.AddChild(nil));
      pFileName^ := aFileName;
    end
    else if FileComp > 0 then // Not match, Soft is behind Group File
    begin
      pSoft := vstSoftWOFile.GetNodeData(vstSoftWOFile.AddChild(nil));
      pSoft^ := aSoft;
    end;


    // Getting next nodes of VST
    // FileComp = 0 executes both
    if FileComp <= 0 then
    begin
      // Skip repeated file with same name (can be with different extension)
      TmpStr := aFileName.FileName;

      SkipComp := 0;
      FileNode := vstFilesWOGroup.GetNextSibling(FileNode);
      while Assigned(FileNode) and (SkipComp = 0) do
      begin
        pFileName := vstFilesWOGroup.GetNodeData(FileNode);
        aFileName := pFileName^;
        SkipComp := CompareFilenames(aFileName.FileName, TmpStr);
        if SkipComp = 0 then
          FileNode := vstFilesWOGroup.GetNextSibling(FileNode);
      end;
    end;

    if FileComp >= 0 then
    begin
      // Skip soft with same media file
      TmpStr := aSoft.MediaFileName;

      SkipComp := 0;
      SoftNode := vstSoftAll.GetNextSibling(SoftNode);
      while Assigned(SoftNode) and (SkipComp = 0) do
      begin
        pSoft := vstSoftAll.GetNodeData(SoftNode);
        aSoft := pSoft^;
        SkipComp := CompareFilenames(aSoft.MediaFileName, TmpStr);
        if SkipComp = 0 then
          SoftNode := vstSoftAll.GetNextSibling(SoftNode);
      end;
    end;
  end;
  vstFilesWOSoft.EndUpdate;
  vstSoftWOFile.EndUpdate;

  fmProgressBar.Finish;

  UpdateListCount;
end;

function TfmETKGUIMediaManager.SelectSystem(aSystem : cEmutecaSystem)
: Boolean;
begin
  Result := True;
  CurrSystem := aSystem;
end;

procedure TfmETKGUIMediaManager.FilterLists;

  procedure FilterFiles(aVST : TCustomVirtualStringTree);
  var
    FileNode : PVirtualNode;
    pFileName : PFileRow;
  begin
    if not Assigned(aVST) then
      Exit;

    aVST.BeginUpdate;
    FileNode := aVST.GetFirstChild(nil);
    while assigned(FileNode) do
    begin

      pFileName := aVST.GetNodeData(FileNode);

      aVST.IsVisible[FileNode] :=
        TextSimilarityDice(TargetFile, pFileName^.FileName) >=
        tbSimilarThresold.Position;

      FileNode := aVST.GetNextSibling(FileNode);
    end;
    aVST.EndUpdate;
  end;

  procedure FilterSoftGroups(aVST : TCustomVirtualStringTree);
  var
    SGNode : PVirtualNode;
    pSoftGroup : ^caEmutecaCustomSGItem;
    SourceFileName : string;
  begin
    if not Assigned(aVST) then
      Exit;

    SourceFileName := ExtractFileNameWithoutExt(SourceFile);

    aVST.BeginUpdate;
    SGNode := aVST.GetFirstChild(nil);
    while assigned(SGNode) do
    begin
      pSoftGroup := aVST.GetNodeData(SGNode);

      aVST.IsVisible[SGNode] :=
        TextSimilarityDice(SourceFileName, pSoftGroup^.MediaFileName) >=
        tbSimilarThresold.Position;

      SGNode := aVST.GetNextSibling(SGNode);

    end;
    aVST.EndUpdate;
  end;

  procedure MakeVSTNodesVisible(aVST : TCustomVirtualStringTree);
  var
    aVSTNode : PVirtualNode;
  begin
    if not Assigned(aVST) then
      Exit;

    aVST.BeginUpdate;
    aVSTNode := aVST.GetFirstChild(nil);
    while assigned(aVSTNode) do
    begin
      aVST.IsVisible[aVSTNode] := True;

      aVSTNode := aVST.GetNextSibling(aVSTNode);
    end;
    aVST.EndUpdate;
  end;
var
  aVST : TCustomVirtualStringTree;
begin // procedure TfmETKGUIMediaManager.FilterLists;

  case rgbFilterMode.ItemIndex of
    1 : begin
      aVST := GetCurrentFilesVST;
      if not Assigned(aVST) then
        Exit;
      if TargetFile = '' then
      begin
        MakeVSTNodesVisible(aVST);
      end
      else
        FilterFiles(aVST);
    end;

    2 : begin
      aVST := GetCurrentGSVST;
      if not Assigned(aVST) then
        Exit;
      if SourceFile = '' then
        MakeVSTNodesVisible(aVST)
      else
        FilterSoftGroups(aVST);
    end;

    else
    begin
      aVST := GetCurrentGSVST;
      if Assigned(aVST) then
      begin
        MakeVSTNodesVisible(aVST);
      end;

      aVST := GetCurrentFilesVST;
      if Assigned(aVST) then
      begin
        MakeVSTNodesVisible(aVST);
      end;
    end;
  end;

  UpdateListCount;
end;

procedure TfmETKGUIMediaManager.UpdateListCount;
var
  aVST : TCustomVirtualStringTree;
begin
  aVST := GetCurrentFilesVST;
  if Assigned(aVST) then
    sbSourceList.SimpleText := Format(rsFmtNItems, [aVST.VisibleCount]);

  aVST := GetCurrentGSVST;
  if Assigned(aVST) then
    sbTargetList.SimpleText := Format(rsFmtNItems, [aVST.VisibleCount]);
end;

function TfmETKGUIMediaManager.AddFileCB(const aFolder : string;
  const Info : TSearchRec) : Boolean;
begin
  Result := True;
  if (Info.Attr and faDirectory) <> 0 then
  begin
    if (Info.Name = '.') or (Info.Name = '..') then
      Exit;
    Result := AddFileVSTAllFiles(Info.Name + krsVirtualFolderExt);
  end
  else
    Result := AddFileVSTAllFiles(Info.Name);
end;

function TfmETKGUIMediaManager.AddFileVSTAllFiles(
  const aName : string) : Boolean;
var
  pFile : PFileRow;
begin
  Result := True;

  if SupportedExtCT(aName, krsVirtualFolderExt) then
  begin
    // It's a folder.
    // TOD0 2: Test if it's empty or not have the current type of mediafiles
    pFile := vstFilesAll.GetNodeData(vstFilesAll.AddChild(nil));

    pFile^.FileName := ExtractFileNameOnly(aName);
    pFile^.Extension := krsVirtualFolderExt;
  end
  else
  begin
    // Look if it is a compressed archive or current type of mediafiles
    //   if CurrExtFilter is empty then add all.
    if (CurrExtFilter.Count = 0) or SupportedExtSL(aName, CurrExtFilter)
    { #todo 3 -oChixpy -cZipMedia :
      Make configurable search media in zip (default off)
    }
    {or
      SupportedExtSL(aName, Emuteca.Config.CompressedExtensions)} then
      pFile := vstFilesAll.GetNodeData(vstFilesAll.AddChild(nil))
    else
      pFile := vstFilesOtherExt.GetNodeData(vstFilesOtherExt.AddChild(nil));

    pFile^.FileName := ExtractFileNameOnly(aName);
    pFile^.Extension := ExtractFileExt(aName);
  end;
end;

procedure TfmETKGUIMediaManager.RemoveFileVSTFiles(const aFile : string);

  procedure RemoveFileFromVST(aVST : TBaseVirtualTree; aFile : string);
  var
    pFileName : PFileRow;
    Nodo : PVirtualNode;
  begin
    // NextSelected := nil;
    aVST.BeginUpdate;

    // From LastChild
    Nodo := aVST.GetLastChild(nil);
    while Assigned(Nodo) do
    begin
      pFileName := aVST.GetNodeData(Nodo);
      if CompareFilenames(pFileName^.FileName + pFileName^.Extension,
        aFile) = 0 then
      begin

        //// Searching contiguos node for selecting
        //if aVST.Selected[Nodo] then
        //begin
        //  NextSelected := aVST.GetNextSibling(Nodo);

        //  if not assigned(NextSelected) then
        //    NextSelected := aVST.GetPreviousSibling(Nodo)
        //end;

        aVST.DeleteNode(Nodo);
        // ...VST is too dynamic, reinit the search
        Nodo := aVST.GetLastChild(nil);
      end
      else
        Nodo := aVST.GetPreviousSibling(Nodo);
    end;
    aVST.EndUpdate;

    //if assigned(NextSelected) then
    //begin
    //  aVST.Selected[NextSelected] := true;
    //end;
  end;
begin
  if CompareFilenames(SourceFolder, TargetFolder) = 0 then
  begin
    RemoveFileFromVST(vstFilesAll, aFile);
    RemoveFileFromVST(vstFilesOtherExt, aFile);
    RemoveFileFromVST(vstFilesWOGroup, aFile);
    RemoveFileFromVST(vstFilesWOSoft, aFile);
  end;

  if CompareFilenames(SourceFolder,
    SetAsFolder(eOtherFolder.Directory)) = 0 then
    RemoveFileFromVST(vstFilesOtherFolder, aFile);

  UpdateListCount;
end;

function TfmETKGUIMediaManager.GetCurrentGSVST : TCustomVirtualStringTree;
begin

  // TODO: Make this... "dinamic"; search vst in current page...

  case pcTarget.ActivePageIndex of
    0 : Result := vstGroupsWOFile;
    1 : Result := vstSoftWOFile;
    2 : Result := vstGroupsAll;
    3 : Result := vstSoftAll;
    else
      Result := nil;
  end;
end;

procedure TfmETKGUIMediaManager.RemoveGroupSoftWOFile(const aFile : string);
var
  Nodo : PVirtualNode;
  PGroup : ^cEmutecaGroup;
  pSoft : ^cEmutecaSoftware;
begin
  // vstGroupsWOFile
  vstGroupsWOFile.BeginUpdate;
  Nodo := vstGroupsWOFile.GetFirstChild(nil);
  while Assigned(Nodo) do
  begin
    PGroup := vstGroupsWOFile.GetNodeData(Nodo);
    if CompareFilenames(PGroup^.MediaFileName, aFile) = 0 then
    begin
      vstGroupsWOFile.DeleteNode(Nodo);
      // See RemoveFileFromVSTWO comment
      Nodo := vstGroupsWOFile.GetFirstChild(nil);
    end
    else
      Nodo := vstGroupsWOFile.GetNextSibling(Nodo);
  end;
  vstGroupsWOFile.EndUpdate;

  // vstSoftWOFile
  vstSoftWOFile.BeginUpdate;
  Nodo := vstSoftWOFile.GetFirstChild(nil);
  while Assigned(Nodo) do
  begin
    pSoft := vstSoftWOFile.GetNodeData(Nodo);
    if CompareFilenames(pSoft^.MediaFileName, aFile) = 0 then
    begin
      vstSoftWOFile.DeleteNode(Nodo);
      // See RemoveFileFromVSTWO comment
      Nodo := vstSoftWOFile.GetFirstChild(nil);
    end
    else
      Nodo := vstSoftWOFile.GetNextSibling(Nodo);
  end;
  vstSoftWOFile.EndUpdate;

end;

procedure TfmETKGUIMediaManager.ChangeSGMedia(SGItem : caEmutecaCustomSGItem);
begin
  if not Assigned(CurrPreview) then
    Exit;
  CurrPreview.FileList := nil;
  MediaFiles.Clear;
  // TODO ZipMedia: Make configurable search media in zip (default off)
  EmuTKSearchAllRelatedFiles(MediaFiles, TargetFolder,
    SGItem.MediaFileName, CurrExtFilter, False, True, Emuteca.TempFolder);
  CurrPreview.FileList := MediaFiles;
end;

procedure TfmETKGUIMediaManager.ChangeFileMedia(const aFolder,
  aFileName : string);
begin
  if not Assigned(CurrPreview) then
    Exit;
  CurrPreview.FileList := nil;
  MediaFiles.Clear;

  if SupportedExtSL(aFileName, CurrExtFilter) then
    // Normal media files
    MediaFiles.Add(aFolder + aFileName)
  else if UTF8CompareText(ExtractFileExt(aFileName),
    krsVirtualFolderExt) = 0 then
    // Hack: Folders: Using EmuTKSearchAllRelatedFiles
    EmuTKSearchAllRelatedFiles(MediaFiles, aFolder,
      ExtractFileNameWithoutExt(aFileName), CurrExtFilter, False, False,
      Emuteca.TempFolder)
  // TODO ZipMedia: Make configurable search media in zip (default off)
    {
    else if SupportedExtSL(aFileName, Emuteca.Config.CompressedExtensions) then
    // Hack: Zips: Using EmuTKSearchAllRelatedFiles
    EmuTKSearchAllRelatedFiles(MediaFiles, aFolder,
      ExtractFileNameWithoutExt(aFileName), ExtFilter, True, True,
      Emuteca.TempFolder)
    };

  CurrPreview.FileList := MediaFiles;
end;

function TfmETKGUIMediaManager.AddFilesOtherFolderCB(const aFolder : string;
  const Info : TSearchRec) : Boolean;
var
  pFile : PFileRow;
begin
  Result := True;

  if (Info.Attr and faDirectory) <> 0 then
  begin
    if (Info.Name = '.') or (Info.Name = '..') then
      Exit;

    // It's a folder
    // TOD0 2: Test if it's empty or not have the current type of mediafiles
    pFile := vstFilesOtherFolder.GetNodeData(
      vstFilesOtherFolder.AddChild(nil));

    pFile^.FileName := Info.Name;
    pFile^.Extension := krsVirtualFolderExt;
  end
  else
  begin
    if not (SupportedExtSL(Info.Name, CurrExtFilter) or
      SupportedExtSL(Info.Name, Emuteca.Config.CompressedExtensions)) then
      Exit;

    pFile := vstFilesOtherFolder.GetNodeData(
      vstFilesOtherFolder.AddChild(nil));

    pFile^.FileName := ExtractFileNameOnly(Info.Name);
    pFile^.Extension := ExtractFileExt(Info.Name);
  end;
end;

procedure TfmETKGUIMediaManager.UpdateFileOtherFolder(aFolder : string);
begin
  vstFilesOtherFolder.Clear;
  aFolder := SetAsFolder(aFolder);

  if not DirectoryExistsUTF8(aFolder) then
    Exit;

  vstFilesOtherFolder.BeginUpdate;
  fmProgressBar.UpdTextAndBar(rsETKMMSearching, rsETKMMSomeTime,
    1, 2, False);
  IterateFolderObj(aFolder, @AddFilesOtherFolderCB, False);
  vstFilesOtherFolder.EndUpdate;

  fmProgressBar.Finish;

  UpdateListCount;
end;

procedure TfmETKGUIMediaManager.OpenGroupEditor(const NewTitle : string);
var
  FormResult : Integer;
  aIconFile, aConfigFile : string;
begin
  if (not Assigned(CurrentSG)) or (not (CurrentSG is cEmutecaGroup)) then
    Exit;

  aIconFile := '';
  aConfigFile := '';

  if Assigned(GUIConfig) then
  begin
    aIconFile := GUIConfig.GUIIcnFile;
    aConfigFile := GUIConfig.DefaultFileName;
  end;

  FormResult := TfmEmutecaGroupEditor.SimpleModalForm(
    cEmutecaGroup(CurrentSG), NewTitle, aConfigFile, aIconFile);

  if FormResult <> mrOk then Exit;

  TargetFile := CurrentSG.MediaFileName;
  ChangeSGMedia(CurrentSG);
  FilterLists;
end;

procedure TfmETKGUIMediaManager.OpenSoftEditor(const NewTitle : string);
var
  FormResult : Integer;
  aIconFile, aConfigFile : string;
begin
  if (not Assigned(CurrentSG)) or (not (CurrentSG is cEmutecaSoftware)) then
    Exit;

  aIconFile := EmptyStr;
  aConfigFile := EmptyStr;

  if Assigned(GUIConfig) then
  begin
    aIconFile := GUIConfig.GUIIcnFile;
    aConfigFile := GUIConfig.DefaultFileName;
  end;

  FormResult := TfmETKGUIFullSoftEditor.SimpleModalForm(
    cEmutecaSoftware(CurrentSG), NewTitle, aConfigFile, aIconFile);

  if FormResult <> mrOk then Exit;

  TargetFile := CurrentSG.MediaFileName;
  ChangeSGMedia(CurrentSG);
  FilterLists;
end;

procedure TfmETKGUIMediaManager.DoLoadGUIConfig(aIniFile : TIniFile);

  procedure LoadVSTConfig(aIniFile : TIniFile; aVST : TVirtualStringTree);
  var
    i : Integer;
  begin
    i := 0;
    while i < aVST.Header.Columns.Count do
    begin
      // Columns width
      aVST.Header.Columns.Items[i].Width :=
        aIniFile.ReadInteger(krsIniETKMediaMngSection,
        Format(krsIniETKMediaMngVSTColumnsFmt, [aVST.Name, i]),
        aVST.Header.Columns.Items[i].Width);

      Inc(i);
    end;
  end;

begin
  inherited DoLoadGUIConfig(aIniFile);

  pLeft.Width := aIniFile.ReadInteger(krsIniETKMediaMngSection,
    krsIniETKMediaMngPLeftWitdh, pLeft.Width);

  pRight.Width := aIniFile.ReadInteger(krsIniETKMediaMngSection,
    krsIniETKMediaMngPRightWidth, pRight.Width);

  gbxSource.Height := aIniFile.ReadInteger(krsIniETKMediaMngSection,
    krsIniETKMediaMngSourceHeight, gbxSource.Height);

  vstSoftOfGroupsWOFile.Height :=
    aIniFile.ReadInteger(krsIniETKMediaMngSection,
    krsIniETKMediaMngSoftGHeight, vstSoftOfGroupsWOFile.Height);

  // Read the same of vstSoftOfGroupsWOFile
  vstSoftOfGroupsAll.Height :=
    aIniFile.ReadInteger(krsIniETKMediaMngSection,
    krsIniETKMediaMngSoftGHeight, vstSoftOfGroupsAll.Height);

  LoadVSTConfig(aIniFile, vstFilesAll);
  LoadVSTConfig(aIniFile, vstFilesOtherExt);
  LoadVSTConfig(aIniFile, vstFilesOtherFolder);
  LoadVSTConfig(aIniFile, vstFilesWOGroup);
  LoadVSTConfig(aIniFile, vstFilesWOSoft);
  LoadVSTConfig(aIniFile, vstGroupsAll);
  LoadVSTConfig(aIniFile, vstGroupsWOFile);
  LoadVSTConfig(aIniFile, vstSoftAll);
  LoadVSTConfig(aIniFile, vstSoftOfGroupsAll);
  LoadVSTConfig(aIniFile, vstSoftOfGroupsWOFile);
  LoadVSTConfig(aIniFile, vstSoftWOFile);
end;

procedure TfmETKGUIMediaManager.DoSaveGUIConfig(aIniFile : TIniFile);

  procedure SaveVSTConfig(aIniFile : TIniFile; aVST : TVirtualStringTree);
  var
    i : Integer;
  begin
    i := 0;
    while i < aVST.Header.Columns.Count do
    begin
      // Columns width
      aIniFile.WriteInteger(krsIniETKMediaMngSection,
        Format(krsIniETKMediaMngVSTColumnsFmt, [aVST.Name, i]),
        aVST.Header.Columns.Items[i].Width);

      Inc(i);
    end;
  end;
begin
  inherited DoSaveGUIConfig(aIniFile);

  aIniFile.WriteInteger(krsIniETKMediaMngSection,
    krsIniETKMediaMngPLeftWitdh, pLeft.Width);

  aIniFile.WriteInteger(krsIniETKMediaMngSection,
    krsIniETKMediaMngPRightWidth, pRight.Width);

  aIniFile.WriteInteger(krsIniETKMediaMngSection,
    krsIniETKMediaMngSourceHeight, gbxSource.Height);

  aIniFile.WriteInteger(krsIniETKMediaMngSection,
    krsIniETKMediaMngSoftGHeight, vstSoftOfGroupsWOFile.Height);

  SaveVSTConfig(aIniFile, vstFilesAll);
  SaveVSTConfig(aIniFile, vstFilesOtherExt);
  SaveVSTConfig(aIniFile, vstFilesOtherFolder);
  SaveVSTConfig(aIniFile, vstFilesWOGroup);
  SaveVSTConfig(aIniFile, vstFilesWOSoft);
  SaveVSTConfig(aIniFile, vstGroupsAll);
  SaveVSTConfig(aIniFile, vstGroupsWOFile);
  SaveVSTConfig(aIniFile, vstSoftAll);
  SaveVSTConfig(aIniFile, vstSoftOfGroupsAll);
  SaveVSTConfig(aIniFile, vstSoftOfGroupsWOFile);
  SaveVSTConfig(aIniFile, vstSoftWOFile);
end;

procedure TfmETKGUIMediaManager.LoadFrameData;
begin
  inherited LoadFrameData;

  Enabled := assigned(Emuteca);

  if not Enabled then
  begin
    ClearFrameData;
    Exit;
  end;
end;

procedure TfmETKGUIMediaManager.LoadSysFolders;
begin
  cbxImages.Clear;
  cbxTexts.Clear;
  cbxMusic.Clear;
  cbxVideos.Clear;
  cbxOtherFolders.Clear;

  vstGroupsAll.Clear;
  vstGroupsWOFile.Clear;
  vstSoftAll.Clear;
  vstSoftOfGroupsAll.Clear;
  vstSoftOfGroupsWOFile.Clear;
  vstSoftWOFile.Clear;
  vstFilesAll.Clear;
  vstFilesOtherExt.Clear;
  vstFilesWOGroup.Clear;
  vstFilesWOSoft.Clear;
  // vstFilesOtherFolder.Clear; Not needed to clear

  SourceFile := '';
  SourceFolder := '';
  TargetFile := '';
  TargetFolder := '';

  if not Assigned(CurrSystem) then
    Exit;

  // Loading data if not already loaded
  Emuteca.SystemManager.LoadSystemData(CurrSystem);

  cbxImages.Clear;
  cbxImages.Items.Add('Icons'); // Special images folder
  cbxImages.Items.Add('Logos'); // Special images folder
  cbxImages.Items.AddStrings(CurrSystem.ImageCaptions, False);
  cbxTexts.Items.Assign(CurrSystem.TextCaptions);
  cbxMusic.Items.Assign(CurrSystem.MusicCaptions);
  cbxVideos.Items.Assign(CurrSystem.VideoCaptions);
  cbxOtherFolders.Items.Assign(CurrSystem.OtherFCapt);

  vstGroupsAll.RootNodeCount := CurrSystem.GroupManager.VisibleList.Count;

  LoadSystemSoft;
end;

procedure TfmETKGUIMediaManager.LoadSystemSoft;
var
  i : Integer;
  pSoft : ^cEmutecaSoftware;
  aSoft : cEmutecaSoftware;
begin
  vstSoftAll.Clear;

  if not Assigned(CurrSystem) then
    Exit;

  // Adding only Soft with different filename for its group.
  vstSoftAll.BeginUpdate;
  i := 0;
  while i < CurrSystem.SoftManager.FullList.Count do
  begin
    aSoft := CurrSystem.SoftManager.FullList[i];
    if not aSoft.MatchGroupFile then
    begin
      pSoft := vstSoftAll.GetNodeData(vstSoftAll.AddChild(nil));
      pSoft^ := aSoft;
    end;
    Inc(i);
  end;
  vstSoftAll.EndUpdate;
end;

function TfmETKGUIMediaManager.GetCurrentFilesVST : TCustomVirtualStringTree;
begin

  // TODO: Make this... "dinamic"; search vst in current page...

  case pcSource.ActivePageIndex of
    0 : Result := vstFilesWOSoft;
    1 : Result := vstFilesWOGroup;
    2 : Result := vstFilesAll;
    3 : Result := vstFilesOtherExt;
    4 : Result := vstFilesOtherFolder;
    else
      Result := nil;
  end;
end;

procedure TfmETKGUIMediaManager.pcSourceChange(Sender : TObject);
var
  aVST : TCustomVirtualStringTree;
begin
  vstFilesAll.ClearSelection;
  vstFilesOtherExt.ClearSelection;
  vstFilesOtherFolder.ClearSelection;
  vstFilesWOGroup.ClearSelection;
  vstFilesWOSoft.ClearSelection;
  SourceFile := '';

  aVST := GetCurrentFilesVST;
  if Assigned(aVST) then
    sbSourceList.SimpleText := format(rsFmtNItems, [aVST.VisibleCount]);
end;

procedure TfmETKGUIMediaManager.pcTargetChange(Sender : TObject);
var
  aVST : TCustomVirtualStringTree;
begin
  vstGroupsAll.ClearSelection;
  vstGroupsWOFile.ClearSelection;
  vstSoftAll.ClearSelection;
  vstSoftOfGroupsAll.Clear; // Clear all items
  vstSoftOfGroupsWOFile.Clear; // Clear all items
  vstSoftWOFile.ClearSelection;
  TargetFile := EmptyStr;

  aVST := GetCurrentGSVST;
  if Assigned(aVST) then
    sbTargetList.SimpleText := format(rsFmtNItems, [aVST.VisibleCount]);
end;

procedure TfmETKGUIMediaManager.rgbFilterModeSelectionChanged(
  Sender : TObject);
begin
  FilterLists;
end;

procedure TfmETKGUIMediaManager.tbSimilarThresoldClick(Sender : TObject);
begin
  // In TrackBar, this method means end of changing it.
  FilterLists;
end;

procedure TfmETKGUIMediaManager.vstFileCompareNodes(Sender : TBaseVirtualTree;
  Node1, Node2 : PVirtualNode; Column : TColumnIndex; var Result : Integer);
var
  pFile1, pFile2 : PFileRow;
begin
  Result := 0;
  pFile1 := Sender.GetNodeData(Node1);
  pFile2 := Sender.GetNodeData(Node2);

  case Column of
    0 : // FileName
      Result := CompareFilenames(pFile1^.FileName, pFile2^.FileName);
    1 : // Extension
      Result := CompareFilenames(pFile1^.Extension, pFile2^.Extension);
    else
      ;
  end;
end;

procedure TfmETKGUIMediaManager.vstFileKeyDown(Sender : TObject;
  var Key : Word; Shift : TShiftState);
begin
  // Secret shortcut
  if Shift = [] then
  begin
    case Key of
      VK_RETURN : actAssignFile.Execute;
      else
        ;
    end;
  end;
end;

procedure TfmETKGUIMediaManager.vstFilesGetNodeDataSize(
  Sender : TBaseVirtualTree; var NodeDataSize : Integer);
begin
  NodeDataSize := SizeOf(TFileRow);
end;

procedure TfmETKGUIMediaManager.vstFilesOtherFolderChange(
  Sender : TBaseVirtualTree; Node : PVirtualNode);
var
  aFileRow : PFileRow;
begin
  SourceFile := EmptyStr;
  SourceFolder := eOtherFolder.Text;

  if assigned(Sender) and assigned(Node) then
  begin
    aFileRow := Sender.GetNodeData(Node);
    SourceFile := aFileRow^.FileName + aFileRow^.Extension;
  end;

  ChangeFileMedia(SourceFolder, SourceFile);

  if rgbFilterMode.ItemIndex = 2 then
    FilterLists;
end;

procedure TfmETKGUIMediaManager.vstFilesChange(Sender : TBaseVirtualTree;
  Node : PVirtualNode);
var
  aFileRow : PFileRow;
begin
  SourceFile := '';
  SourceFolder := TargetFolder;

  if assigned(Sender) and assigned(Node) then
  begin
    aFileRow := Sender.GetNodeData(Node);
    SourceFile := aFileRow^.FileName + aFileRow^.Extension;
  end;

  ChangeFileMedia(SourceFolder, SourceFile);

  if rgbFilterMode.ItemIndex = 2 then
    FilterLists;
end;

procedure TfmETKGUIMediaManager.vstNodeClick(Sender : TBaseVirtualTree;
  const HitInfo : THitInfo);
var
  aTree : TVirtualStringTree;
begin
  // FIX: Clicking on already selected node don't trigger OnChange.
  // Example: Select a File, select a group, when clicked same File again
  //   (or viceversa) Media preview is not updated.
  // On(Node)Click is not called when Keyboard is used, so OnChange must be used.
  // When called On(Node)Click on not selected node OnChange is called too;
  //   so Media Preview is "updated" 2 times ~_~U

  if not (Sender is TVirtualStringTree) then
    Exit;
  aTree := TVirtualStringTree(Sender);

  // We want call OnChange only if same selected node is clicked...
  //   but OnChange is called before... so FocusedNode = HitInfo.HitNode...
  if HitInfo.HitNode <> aTree.FocusedNode then
    Exit;

  if Assigned(aTree.OnChange) then
    aTree.OnChange(aTree, HitInfo.HitNode);
end;

procedure TfmETKGUIMediaManager.vstGroupCompareNodes(Sender : TBaseVirtualTree;
  Node1, Node2 : PVirtualNode; Column : TColumnIndex; var Result : Integer);
var
  pGroup1, pGroup2 : ^cEmutecaGroup;
begin
  Result := 0;
  pGroup1 := Sender.GetNodeData(Node1);
  pGroup2 := Sender.GetNodeData(Node2);

  case Column of
    0 : Result := CompareFilenames(pGroup1^.MediaFileName,
        pGroup2^.MediaFileName);
    1 : Result := UTF8CompareText(pGroup1^.Title, pGroup2^.Title);
    else
      ;
  end;
end;

procedure TfmETKGUIMediaManager.vstSGKeyDown(Sender : TObject;
  var Key : Word; Shift : TShiftState);
begin
  // Secret shortcut when the list is the current component
  if Shift = [] then
  begin
    case Key of
      VK_RETURN : actAssignFile.Execute;
      else
        ;
    end;
  end;
end;

procedure TfmETKGUIMediaManager.chkSimilarFilesChange(Sender : TObject);
begin
  FilterLists;
end;

procedure TfmETKGUIMediaManager.eOtherFolderAcceptDirectory(Sender : TObject;
  var Value : string);
begin
  UpdateFileOtherFolder(Value);
end;

procedure TfmETKGUIMediaManager.actAssignFileExecute(Sender : TObject);
var
  TargetPath : string;
  SourcePath : string;
  SourceIsFolder : Boolean;
  AllOK : Boolean;
begin
  if (SourceFolder = PathDelim) or (SourceFolder = EmptyStr) then
    Exit;
  if (TargetFolder = PathDelim) or (TargetFolder = EmptyStr) then
    Exit;
  if SourceFile = EmptyStr then
    Exit;
  if TargetFile = EmptyStr then
    Exit;

  // Source
  // ------
  SourcePath := SourceFolder + SourceFile;

  // Testing if it's a folder
  SourceIsFolder := CompareFileExt(SourceFile, krsVirtualFolderExt) = 0;
  if SourceIsFolder then // Removing virtual extension of folders
    SourcePath := ExtractFileNameWithoutExt(SourcePath);

  // Checking source existence, may be it's redundant...
  AllOK := False;
  if SourceIsFolder then
    AllOK := DirectoryExistsUTF8(SourcePath)
  else
    AllOK := FileExistsUTF8(SourcePath);
  if not AllOK then
    Exit;

  // Target
  // ------

  TargetPath := TargetFolder + TargetFile;


  // Dragons
  // -------

  AllOK := False;
  if SourceIsFolder then // Source is a folder
  begin
    if DirectoryExistsUTF8(TargetPath) then
    begin
      // Testing if they are the same folder...
      if CompareFilenames(TargetPath, SourcePath) = 0 then
        Exit;

      // Copy all files.

      // TODO: Decide between:
      //   - Overwrite files: add [cffOverwriteFile] flag in CopyDirTree
      //   - Keep and autorename repeated filenames (making a custom function)
      //     or TSearcher (see CopyDirTree)

      // HACK: Where is CopyDirTreeUTF8?
      AllOK := CopyDirTree(UTF8ToSys(SourcePath), UTF8ToSys(TargetPath),
        [cffPreserveTime]);

      // Delete Source only if copy went well and not in copy mode.
      if AllOK and (not chkCopyFile.Checked) then
        // HACK: DeleteDirectoryUTF8 don't exists
        DeleteDirectory(UTF8ToSys(SourcePath), False);
    end
    else // Target folder don't exists
    begin
      if chkCopyFile.Checked then
      begin
        // HACK: Where is CopyDirTreeUTF8?
        AllOK := CopyDirTree(UTF8ToSys(SourcePath),
          UTF8ToSys(TargetPath), [cffCreateDestDirectory, cffPreserveTime]);
      end
      else
      begin
        AllOK := RenameFileUTF8(SourcePath, TargetPath);
      end;
    end;
  end
  else // Source is a file
  begin
    if DirectoryExistsUTF8(TargetPath) then
    begin
      TargetPath := CHXCheckFileRename(SetAsFolder(TargetPath) + SourceFile);
      AllOK := True;
    end
    else // Target is not a folder
    begin
      TargetPath := TargetPath + ExtractFileExt(SourceFile);
      AllOK := True;

      // Testing if they are the same file...
      if CompareFilenames(TargetPath, SourcePath) = 0 then
        Exit;

      if FileExistsUTF8(TargetPath) then
      begin // File already exists, creating new folder and moving both files.

        // Moving already existing file
        AllOK := ForceDirectoriesUTF8(ExtractFileNameWithoutExt(TargetPath));

        if AllOK then
          AllOK := RenameFileUTF8(TargetPath,
            SetAsFolder(ExtractFileNameWithoutExt(TargetPath)) +
            ExtractFileName(TargetPath));

        // Setting the new target file inside the folder
        TargetPath := SetAsFolder(ExtractFileNameWithoutExt(TargetPath)) +
          SourceFile;
      end;
    end;

    if AllOK then
    begin
      // Copy or rename the file
      if chkCopyFile.Checked then
      begin
        AllOK := CopyFile(UTF8ToSys(SourcePath), UTF8ToSys(TargetPath),
          [cffCreateDestDirectory, cffPreserveTime], True);
      end
      else
      begin
        AllOK := RenameFileUTF8(SourcePath, TargetPath);
      end;
    end;
  end;

  if not AllOK then
  begin
    ShowMessageFmt(rsErrorRenamingFile, [SourcePath, TargetPath]);
    Exit;
  end;


   { TODO: Add new filename to AllFiles list... but maybe we want to keep
     already processed files hidden...

  // Quick update of VST lists
  // -------------------------

  // Adding TargetFile.
  case rgbAssignMode.ItemIndex of
    1: // <TargetFolder>/<TargetFile>/<Filename>.<ext>
      AddFileVSTAllFiles(TargetFile + krsVirtualFolderExt);
    2: // <TargetFolder>/<TargetFile>.zip/<Filename>.<ext>
      AddFileVSTAllFiles(TargetFile + '.zip');
    else // 0: // <TargetFolder>/<TargetFile>.<ext>
      AddFileVSTAllFiles(TargetFile + ExtractFileExt(SourceFile));
  end;
  }

  // Removing Source file from ALL vstFiles
  if not chkCopyFile.Checked then
    RemoveFileVSTFiles(SourceFile);

  // Removing Target file from vstGroupWOFile or vstSoftWOFile.
  if not chkCopyFile.Checked then
    RemoveGroupSoftWOFile(TargetFile);

  SourceFile := EmptyStr;

  // Clear TargetFile only if pagGroupsWOFile or vstSoftWOFile is active because
  //  the group is deleted from their list.
  if (GetCurrentFilesVST = vstGroupsWOFile) or
    (GetCurrentFilesVST = vstSoftWOFile) then
  begin
    TargetFile := EmptyStr;
  end;

  FilterLists;
end;

procedure TfmETKGUIMediaManager.actAssignToGroupExecute(Sender : TObject);
var
  aGroup : cEmutecaGroup;
begin
  if not (CurrentSG is cEmutecaSoftware) then Exit;

  aGroup := cEmutecaGroup(cEmutecaSoftware(CurrentSG).CachedGroup);

  if not assigned(aGroup) then Exit;

  TargetFile := aGroup.MediaFileName;

  if TargetFile = EmptyStr then Exit;

  actAssignFile.Execute;
end;

procedure TfmETKGUIMediaManager.actAutoAssignExecute(Sender : TObject);
var
  aVSTFiles, aVSTTarget : TCustomVirtualStringTree;
  PTarget : ^caEmutecaCustomSGItem;
  pFileName : PFileRow;
  NodoF, NodoT : PVirtualNode;
  ContinueOp : Boolean;
  Cont : Integer;
begin
  aVSTFiles := GetCurrentFilesVST;

  // Testing if it is vstFilesOtherFolder
  if (not Assigned(aVSTFiles)) or (aVSTFiles <> vstFilesOtherFolder) then
    Exit;

  aVSTTarget := GetCurrentGSVST;

  { TODO: This is sloooow. }

  ContinueOp := fmProgressBar.UpdTextAndBar(rsETKMMSearching,
    rsETKMMSomeTime, 1, aVSTFiles.VisibleCount, True);
  Cont := 0;
  // From LastChild
  NodoF := aVSTFiles.GetLastChild(nil);
  while Assigned(NodoF) and ContinueOp do
  begin
    pFileName := aVSTFiles.GetNodeData(NodoF);
    NodoF := aVSTFiles.GetPreviousSibling(NodoF);
    Inc(Cont);

    NodoT := aVSTTarget.GetLastChild(nil);
    while Assigned(NodoT) and ContinueOp do
    begin
      PTarget := aVSTTarget.GetNodeData(NodoT);

      if CompareFilenames(pFileName^.FileName, PTarget^.MediaFileName) = 0 then
      begin
        SourceFolder := eOtherFolder.Directory;
        SourceFile := pFileName^.FileName + pFileName^.Extension;
        TargetFile := PTarget^.MediaFileName;

        Dec(Cont);
        ContinueOp := fmProgressBar.UpdTextAndBar(rsETKMMSearching,
          SourceFile, Cont, aVSTFiles.VisibleCount, True);

        actAssignFileExecute(nil);

        NodoT := nil; // Next file
      end
      else
        NodoT := aVSTTarget.GetPreviousSibling(NodoT);
    end;
  end;

  fmProgressBar.UpdTextAndBar(EmptyStr, EmptyStr, 0, 0, True);

  SourceFile := EmptyStr;
  TargetFile := EmptyStr;
end;

procedure TfmETKGUIMediaManager.actDeleteAllFilesExecute(Sender : TObject);
var
  aVSTFiles : TCustomVirtualStringTree;
  aNode : PVirtualNode;
  pFile : PFileRow;
  IsFolder, aBool : Boolean;
  SourcePath : string;
begin
  aVSTFiles := GetCurrentFilesVST;
  if not Assigned(aVSTFiles) then
    Exit;

  if MessageDlg(rsETKMMDeleteAll, mtConfirmation, [mbYes, mbNo],
    -1) = mrNo then
    Exit;

  aNode := aVSTFiles.GetFirstChild(nil);
  while Assigned(aNode) do
  begin
    if aVSTFiles.IsVisible[aNode] then
    begin
      pFile := aVSTFiles.GetNodeData(aNode);

      // SourceFolder is in sync with current VSTFile
      // Testing if it's a folder, and removing virtual folder extension.
      IsFolder := CompareFileExt(pFile^.Extension, krsVirtualFolderExt) = 0;
      if IsFolder then
        SourcePath := SourceFolder + pFile^.FileName
      else
        SourcePath := SourceFolder + pFile^.FileName + pFile^.Extension;

      // Checking source existence, may be it's redundant...
      if IsFolder then
        aBool := DirectoryExistsUTF8(SourcePath)
      else
        aBool := FileExistsUTF8(SourcePath);

      if aBool then
      begin
        if IsFolder then
        begin
          aBool := DeleteDirectory(SourcePath, False);
        end
        else
        begin
          aBool := DeleteFileUTF8(SourcePath);
        end;
      end;

      if not aBool then
      begin
        ShowMessageFmt(rsErrorDeletingFile, [SourcePath]);
        Exit;
      end;
    end;
    aNode := aVSTFiles.GetNextSibling(aNode);
  end;

  // Clear vstFilesOtherFolder if needed
  if CompareFilenames(SourceFolder,
    SetAsFolder(eOtherFolder.Directory)) = 0 then
    UpdateFileOtherFolder(SourceFolder);

  // Full update of VSTs
  if CompareFilenames(SourceFolder, TargetFolder) = 0 then
    UpdateVST(TargetFolder);

  UpdateListCount;
end;

procedure TfmETKGUIMediaManager.actDeleteFileExecute(Sender : TObject);
begin
  if (SourceFile = EmptyStr) or (SourceFolder = EmptyStr) then
    Exit;

  // TODO: Add support for folders

  if MessageDlg(Format(rsCorfirmDeleteFile, [SourceFolder + SourceFile]),
    mtConfirmation, [mbYes, mbNo], -1) = mrNo then
    Exit;

  if not DeleteFileUTF8(SourceFolder + SourceFile) then
  begin
    ShowMessageFmt(rsErrorDeletingFile, [SourceFolder + SourceFile]);
    Exit;
  end;

  RemoveFileVSTFiles(SourceFile);
  SourceFile := EmptyStr;

  UpdateListCount;
end;

procedure TfmETKGUIMediaManager.actEditSoftExecute(Sender : TObject);
begin
  if (not Assigned(CurrentSG)) or (not (CurrentSG is cEmutecaSoftware)) then
    Exit;

  OpenSoftEditor(EmptyStr);
end;

procedure TfmETKGUIMediaManager.actMoveAllFilesExecute(Sender : TObject);
var
  aVSTFiles : TCustomVirtualStringTree;
  aNode : PVirtualNode;
  pFile : pFileRow;
  IsFolder, aBool : Boolean;
  SourcePath, TargetPath : string;
begin
  aVSTFiles := GetCurrentFilesVST;

  if not Assigned(aVSTFiles) then
    Exit;

  SetDlgInitialDir(SelectDirectoryDialog1, SourceFolder);
  if not SelectDirectoryDialog1.Execute then
    Exit;

  aNode := aVSTFiles.GetFirstChild(nil);
  while Assigned(aNode) do
  begin
    if aVSTFiles.IsVisible[aNode] then
    begin
      pFile := aVSTFiles.GetNodeData(aNode);

      // SourceFolder is in sync with current VSTFile
      // Testing if it's a folder, and removing virtual folder extension.
      IsFolder := CompareFileExt(pFile^.Extension, krsVirtualFolderExt) = 0;
      if IsFolder then
        SourcePath := SourceFolder + pFile^.FileName
      else
        SourcePath := SourceFolder + pFile^.FileName + pFile^.Extension;

      // Checking source existence, may be it's redundant...
      if IsFolder then
        aBool := DirectoryExistsUTF8(SourcePath)
      else
        aBool := FileExistsUTF8(SourcePath);

      if aBool then
      begin
        TargetPath := SetAsFolder(SelectDirectoryDialog1.FileName) +
          ExtractFileName(SourcePath);

        // Checking target existence for files
        if IsFolder then
          aBool := DirectoryExistsUTF8(TargetPath)
        else
          aBool := FileExistsUTF8(TargetPath);

        if aBool then
        begin
          if MessageDlg(Format(rsCUExcAlreadyExistsAsk, [TargetPath]),
            mtConfirmation, [mbYes, mbNo], -1) = mrYes then
          begin
            if IsFolder then
              DeleteDirectory(UTF8ToSys(TargetPath), False)
            else
              DeleteFileUTF8(TargetPath);

            RenameFileUTF8(SourcePath, TargetPath);
          end;
          // TODO: Merge Folders
        end
        else
          RenameFileUTF8(SourcePath, TargetPath);
      end;
    end;

    aNode := aVSTFiles.GetNextSibling(aNode);
  end;

  // Clear vstFilesOtherFolder if needed
  if CompareFilenames(SourceFolder,
    SetAsFolder(eOtherFolder.Directory)) = 0 then
    UpdateFileOtherFolder(SourceFolder);

  // Full update of VSTs
  if CompareFilenames(SourceFolder, TargetFolder) = 0 then
    UpdateVST(TargetFolder);

  UpdateListCount;
end;

procedure TfmETKGUIMediaManager.actMoveFileExecute(Sender : TObject);
var
  SourcePath, TargetPath : string;
  IsFolder, aBool : Boolean;
begin
  if (SourceFile = EmptyStr) or (SourceFolder = EmptyStr) then
    Exit;

  SetDlgInitialDir(SelectDirectoryDialog1, SourceFolder);
  if not SelectDirectoryDialog1.Execute then
    Exit;

  // Testing if it's a folder, and removing virtual folder extension.
  IsFolder := CompareFileExt(SourceFile, krsVirtualFolderExt) = 0;
  if IsFolder then
    SourcePath := SourceFolder + ExtractFileNameOnly(SourceFile)
  else
    SourcePath := SourceFolder + SourceFile;

  // Checking source existence, may be it's redundant...
  if IsFolder then
    aBool := DirectoryExistsUTF8(SourcePath)
  else
    aBool := FileExistsUTF8(SourcePath);
  if not aBool then
    Exit;

  TargetPath := SetAsFolder(SelectDirectoryDialog1.FileName) +
    ExtractFileName(SourcePath);

  // Checking target existence for files
  if IsFolder then
    aBool := DirectoryExistsUTF8(TargetPath)
  else
    aBool := FileExistsUTF8(TargetPath);
  if aBool then
  begin
    if MessageDlg(Format(rsCUExcAlreadyExistsAsk, [TargetPath]),
      mtConfirmation, [mbYes, mbNo], -1) = mrNo then
      // TODO 2: Merge folders?
      Exit
    else
    begin
      if IsFolder then
        DeleteDirectory(UTF8ToSys(TargetPath), False)
      else
        DeleteFileUTF8(TargetPath);
    end;
  end;

  RenameFileUTF8(SourcePath, TargetPath);
  // Removing Source file from ALL vstFiles
  RemoveFileVSTFiles(SourceFile);

  SourceFile := '';

  UpdateListCount;
end;

procedure TfmETKGUIMediaManager.actEditGroupExecute(Sender : TObject);
begin
  if (not Assigned(CurrentSG)) or (not (CurrentSG is cEmutecaGroup)) then
    Exit;

  OpenGroupEditor('');
end;

procedure TfmETKGUIMediaManager.actOpenFileDefAppExecute(Sender : TObject);
var
  aFileName : string;
begin
  // Removing fake folder extension
  aFileName := UTF8TextReplace(SourceFile, krsVirtualFolderExt, EmptyStr);
  OpenDocument(SourceFolder + aFileName);
end;

procedure TfmETKGUIMediaManager.actOpenTargetFolderExecute(Sender : TObject);
begin
  OpenDocument(TargetFolder);
end;

procedure TfmETKGUIMediaManager.actRenameFileExecute(Sender : TObject);
var
  NewFileName : string;
begin
  if (SourceFile = EmptyStr) or (SourceFolder = EmptyStr) then
    Exit;

  NewFileName := InputBox(rsRenameFileCaption, rsRenameFile,
    ExtractFileNameWithoutExt(SourceFile));

  NewFileName := NewFileName + ExtractFileExt(SourceFile);

  if CompareFilenames(NewFileName, SourceFile) = 0 then Exit;

  NewFileName := CHXCheckFileRename(SourceFolder + NewFileName);

  // TODO: Add support for folders
  if not RenameFileUTF8(SourceFolder + SourceFile, NewFileName) then
  begin
    ShowMessageFmt(rsErrorRenamingFile,
      [SourceFile, ExtractFileName(NewFileName)]);
    Exit;
  end;

  // FEAT/BUG: It's easier removing from the lists than renaming the items
  RemoveFileVSTFiles(SourceFile);
  SourceFile := '';
end;

procedure TfmETKGUIMediaManager.actRenameGroupTitleWithFilenameExecute(
  Sender : TObject);
begin
  if (not Assigned(CurrentSG)) or (not (CurrentSG is cEmutecaGroup)) or
    (SourceFile = '') then
    Exit;

  OpenGroupEditor(ExtractFileNameOnly(SourceFile));
end;

procedure TfmETKGUIMediaManager.actRenameSoftTitleWithFilenameExecute(
  Sender : TObject);
begin
  if (not Assigned(CurrentSG)) or (not (CurrentSG is cEmutecaSoftware)) or
    (SourceFile = '') then
    Exit;

  OpenSoftEditor(ExtractFileNameOnly(SourceFile));
end;

procedure TfmETKGUIMediaManager.actRunSoftwareExecute(Sender : TObject);
begin
  if (not Assigned(CurrentSG)) or (not (CurrentSG is cEmutecaSoftware)) then
    Exit;
  Emuteca.RunSoftware(cEmutecaSoftware(CurrentSG));
end;

procedure TfmETKGUIMediaManager.cbxFolderSelected(Sender : TObject);
var
  aCBX : TComboBox;
begin
  aCBX := TComboBox(Sender);

  // Unselecting other list boxes
  if aCBX <> cbxImages then
    cbxImages.ItemIndex := -1;
  if aCBX <> cbxTexts then
    cbxTexts.ItemIndex := -1;
  if aCBX <> cbxMusic then
    cbxMusic.ItemIndex := -1;
  if aCBX <> cbxVideos then
    cbxVideos.ItemIndex := -1;
  if aCBX <> cbxOtherFolders then
    cbxOtherFolders.ItemIndex := -1;

  CurrExtFilter.Clear;

  if Assigned(CurrPreview) then
    CurrPreview.FileList := nil;
  CurrPreview := nil;

  SourceFile := '';
  SourceFolder := '';

  vstFilesAll.Clear;
  vstFilesOtherExt.Clear;
  vstFilesWOGroup.Clear;
  vstFilesWOSoft.Clear;
  vstGroupsWOFile.Clear;
  vstSoftWOFile.Clear;

  if aCBX.ItemIndex = -1 then
    Exit;

  if aCBX = cbxImages then
  begin
    if Assigned(GUIConfig) then
      CurrExtFilter.Assign(GUIConfig.ImageExtensions);
    CurrPreview := fmImagePreview;
    case aCBX.ItemIndex of
      0 : UpdateVST(CurrSystem.IconFolder);
      1 : UpdateVST(CurrSystem.LogoFolder);
      else
        UpdateVST(CurrSystem.ImageFolders[aCBX.ItemIndex - 2]);
    end;
  end
  else if aCBX = cbxTexts then
  begin
    if Assigned(GUIConfig) then
      CurrExtFilter.Assign(GUIConfig.TextExtensions);
    CurrPreview := fmTextPreview;
    UpdateVST(CurrSystem.TextFolders[aCBX.ItemIndex]);
  end
  else if aCBX = cbxMusic then
  begin
    if Assigned(GUIConfig) then
      CurrExtFilter.Assign(GUIConfig.MusicExtensions);
    UpdateVST(CurrSystem.MusicFolders[aCBX.ItemIndex]);
  end
  else if aCBX = cbxVideos then
  begin
    if Assigned(GUIConfig) then
      CurrExtFilter.Assign(GUIConfig.VideoExtensions);
    UpdateVST(CurrSystem.VideoFolders[aCBX.ItemIndex]);
  end
  else if aCBX = cbxOtherFolders then
  begin
    CurrExtFilter.Clear;

    //CurrExtFilter.CommaText := CurrSystem.OtherFExt[aCBX.ItemIndex];
    UpdateVST(CurrSystem.OtherFolders[aCBX.ItemIndex]);
  end
  else
    UpdateVST('');
end;

procedure TfmETKGUIMediaManager.vstFileFreeNode(Sender : TBaseVirtualTree;
  Node : PVirtualNode);
var
  pFile : PFileRow;
begin
  pFile := Sender.GetNodeData(Node);
  pFile^.FileName := '';
  pFile^.Extension := '';
  Finalize(pFile^);
  Finalize(pFile);
end;

procedure TfmETKGUIMediaManager.vstFileGetText(Sender : TBaseVirtualTree;
  Node : PVirtualNode; Column : TColumnIndex; TextType : TVSTTextType;
  var CellText : string);
var
  pFile : PFileRow;
begin
  pFile := Sender.GetNodeData(Node);
  if not Assigned(pFile) then
    Exit;

  case TextType of
    ttNormal : case Column of
        0 : CellText := pFile^.FileName;
        1 : CellText := pFile^.Extension;
        else
          ;
      end;
    else
      ;
  end;
end;

procedure TfmETKGUIMediaManager.vstSoftGroupChange(Sender : TBaseVirtualTree;
  Node : PVirtualNode);

  procedure LoadGroupSoft(aVST : TVirtualStringTree; aGroup : cEmutecaGroup);
  var
    i : Integer;
    aSoft : cEmutecaSoftware;
    pSoft : ^cEmutecaSoftware;
  begin
    aVST.Clear;

    if not Assigned(aGroup) then
      Exit;

    aVST.BeginUpdate;
    i := 0;
    while i < aGroup.SoftList.Count do
    begin
      aSoft := aGroup.SoftList[i];

      pSoft := aVST.GetNodeData(aVST.AddChild(nil));
      pSoft^ := aSoft;

      Inc(i);
    end;
    aVST.EndUpdate;
  end;
var
  PData : ^caEmutecaCustomSGItem;
begin
  TargetFile := '';

  // Cleaning Group Softlist
  if Sender = vstGroupsAll then
  begin
    vstSoftOfGroupsAll.Clear;
  end
  else if Sender = vstGroupsWOFile then
  begin
    vstSoftOfGroupsWOFile.Clear;
  end;

  if (not assigned(Sender)) or (not assigned(Node)) then
    Exit;

  PData := Sender.GetNodeData(Node);
  CurrentSG := PData^;

  // Adding soft from group
  if Sender = vstGroupsAll then
  begin
    LoadGroupSoft(vstSoftOfGroupsAll, cEmutecaGroup(CurrentSG));
  end
  else if Sender = vstGroupsWOFile then
  begin
    LoadGroupSoft(vstSoftOfGroupsWOFile, cEmutecaGroup(CurrentSG));
  end;

  TargetFile := CurrentSG.MediaFileName;
  ChangeSGMedia(CurrentSG);

  if rgbFilterMode.ItemIndex = 1 then
    FilterLists;
end;

procedure TfmETKGUIMediaManager.vstGroupsAllInitNode(Sender : TBaseVirtualTree;
  ParentNode, Node : PVirtualNode; var InitialStates : TVirtualNodeInitStates);
var
  pGroup : ^cEmutecaGroup;
begin
  if not assigned(CurrSystem) then
    Exit;
  pGroup := Sender.GetNodeData(Node);
  pGroup^ := CurrSystem.GroupManager.VisibleList[Node^.Index];
end;

procedure TfmETKGUIMediaManager.vstKeyPress(Sender : TObject; var Key : char);
begin
  // Removing "Beep" sound when key Return is pressed
  case Key of
    #13, #10 : Key := #0;
    else
      ;
  end;
end;

procedure TfmETKGUIMediaManager.vstSoftCompareNodes(Sender : TBaseVirtualTree;
  Node1, Node2 : PVirtualNode; Column : TColumnIndex; var Result : Integer);
var
  pSoft1, pSoft2 : ^cEmutecaSoftware;
begin
  Result := 0;
  pSoft1 := Sender.GetNodeData(Node1);
  pSoft2 := Sender.GetNodeData(Node2);

  case Column of
    0 : Result := CompareFilenames(pSoft1^.MediaFileName,
        pSoft2^.MediaFileName);
    1 : begin
      Result := UTF8CompareText(pSoft1^.Zone, pSoft2^.Zone);
      if Result = 0 then
        Result := UTF8CompareText(pSoft1^.Title, pSoft2^.Title);
    end;
    2 : Result := UTF8CompareText(pSoft1^.CachedGroup.Title,
        pSoft2^.CachedGroup.Title);
    else
      ;
  end;
end;

procedure TfmETKGUIMediaManager.vstSoftGetText(Sender : TBaseVirtualTree;
  Node : PVirtualNode; Column : TColumnIndex; TextType : TVSTTextType;
  var CellText : string);
var
  pSoft : ^cEmutecaSoftware;
begin
  pSoft := Sender.GetNodeData(Node);
  if not Assigned(pSoft) then
    Exit;
  if not Assigned(pSoft^) then
    Exit;

  case TextType of
    ttNormal : case Column of
        0 : CellText := pSoft^.MediaFileName;
        1 : CellText := '(' + pSoft^.Zone + ') ' + pSoft^.Title;
        2 : CellText := pSoft^.CachedGroup.Title;
        else
          ;
      end;
    else
      ;
  end;
end;

procedure TfmETKGUIMediaManager.vstGroupGetText(Sender : TBaseVirtualTree;
  Node : PVirtualNode; Column : TColumnIndex; TextType : TVSTTextType;
  var CellText : string);
var
  pGroup : ^cEmutecaGroup;
begin
  pGroup := Sender.GetNodeData(Node);
  if not Assigned(pGroup) then
    Exit;
  if not Assigned(pGroup^) then
    Exit;

  case TextType of
    ttNormal : case Column of
        0 : CellText := pGroup^.MediaFileName;
        1 : CellText := pGroup^.Title;
        else
          ;
      end;
    else
      ;
  end;
end;

procedure TfmETKGUIMediaManager.SetEmuteca(aValue : cEmuteca);
begin
  if FEmuteca = aValue then
    Exit;
  FEmuteca := aValue;

  if Assigned(Emuteca) then
    fmSystemCBX.SystemList := Emuteca.SystemManager.EnabledList
  else
    fmSystemCBX.SystemList := nil;
  fmSystemCBX.SelectedSystem := nil;

  LoadFrameData;
end;

procedure TfmETKGUIMediaManager.SetGUIConfig(aValue : cETKGUIConfig);
begin
  if FGUIConfig = aValue then
    Exit;
  FGUIConfig := aValue;

  if assigned(GUIConfig) then
  begin
    // GUIConfigIni := GUIConfig.ConfigFile;
    SHA1Folder := SetAsAbsoluteFile(GUIConfig.GlobalCache, ProgramDirectory);
  end
  else
  begin
    // GUIConfigIni := '';
    SHA1Folder := '';
  end;
end;

procedure TfmETKGUIMediaManager.SetCurrSystem(aValue : cEmutecaSystem);
begin
  if FCurrSystem = aValue then
    Exit;
  FCurrSystem := aValue;

  LoadSysFolders;
end;

class function TfmETKGUIMediaManager.SimpleForm(aEmuteca : cEmuteca;
  SelectedSystem : cEmutecaSystem; aGUIConfig : cETKGUIConfig;
  const aGUIIconsIni : string) : Integer;
var
  aFrame : TfmETKGUIMediaManager;
begin
  aFrame := TfmETKGUIMediaManager.Create(nil);

  aFrame.Align := alClient;

  aFrame.GUIConfig := aGUIConfig;
  aFrame.Emuteca := aEmuteca;
  aFrame.fmSystemCBX.SelectedSystem := SelectedSystem;
  // fmSystemCBX.SelectedSystem don't trigger SetSystem() callback.
  aFrame.SelectSystem(SelectedSystem);

  Result := GenSimpleModalForm(aFrame, krsETKMMFormName,
    Format(krsFmtWindowCaption, [Application.Title, rsETKMMFormCaption]),
    aGUIConfig.DefaultFileName, aGUIIconsIni);
end;

constructor TfmETKGUIMediaManager.Create(TheOwner : TComponent);

  procedure CreateFrames;
  begin
    FfmSystemCBX := TfmEmutecaSystemCBX.Create(gbxSystem);
    fmSystemCBX.FirstItem := ETKSysCBXFISelect;
    fmSystemCBX.OnSelectSystem := @SetCurrSystem;
    fmSystemCBX.Align := alTop;
    fmSystemCBX.Parent := gbxSystem;

    FfmImagePreview := TfmCHXImgListPreview.Create(pImagePreview);
    fmImagePreview.Align := alClient;
    fmImagePreview.Parent := pImagePreview;

    FfmTextPreview := TfmCHXTxtListPreview.Create(pTextPreview);
    fmTextPreview.Align := alClient;
    fmTextPreview.Parent := pTextPreview;

    FfmProgressBar := TfmCHXProgressBar.SimpleForm('');
  end;
begin
  inherited Create(TheOwner);

  CreateFrames;

  vstGroupsAll.NodeDataSize := SizeOf(cEmutecaGroup);
  vstGroupsWOFile.NodeDataSize := SizeOf(cEmutecaGroup);
  vstSoftAll.NodeDataSize := SizeOf(cEmutecaSoftware);
  vstSoftWOFile.NodeDataSize := SizeOf(cEmutecaSoftware);
  vstSoftOfGroupsAll.NodeDataSize := SizeOf(cEmutecaSoftware);
  vstSoftOfGroupsWOFile.NodeDataSize := SizeOf(cEmutecaSoftware);
  vstFilesAll.NodeDataSize := SizeOf(TFileRow);
  vstFilesOtherExt.NodeDataSize := SizeOf(TFileRow);
  vstFilesWOGroup.NodeDataSize := SizeOf(TFileRow);
  vstFilesWOSoft.NodeDataSize := SizeOf(TFileRow);
  vstFilesOtherFolder.NodeDataSize := SizeOf(TFileRow);

  pcSource.ActivePageIndex := 0;
  pcTarget.ActivePageIndex := 0;

  FMediaFiles := TStringList.Create;
  FCurrExtFilter := TStringList.Create;
end;

destructor TfmETKGUIMediaManager.Destroy;
begin
  CurrExtFilter.Free;
  MediaFiles.Free;

  inherited Destroy;
end;

initialization
  RegisterClass(TfmETKGUIMediaManager);

finalization
  UnRegisterClass(TfmETKGUIMediaManager);
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
