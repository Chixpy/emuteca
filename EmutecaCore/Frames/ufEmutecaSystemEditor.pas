unit ufEmutecaSystemEditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, ExtCtrls, EditBtn,
  CheckLst, ActnList, Buttons,
  ucEmutecaSystem, ucEmutecaEmulator, ucEmutecaEmulatorManager,
  uCHXStrUtils;

resourcestring
  rsSelectEmulator = 'Select a System';

type

  { TfmEmutecaSystemEditor }

  TfmEmutecaSystemEditor = class(TFrame)
    actCancel: TAction;
    actSave: TAction;
    ActionList1: TActionList;
    bCancel: TBitBtn;
    bSave: TBitBtn;
    cbxMainEmulator: TComboBox;
    chkExtractAllFiles: TCheckBox;
    clbOtherEmulators: TCheckListBox;
    eBaseFolder: TDirectoryEdit;
    eCompany: TEdit;
    eModel: TEdit;
    eTempFolder: TDirectoryEdit;
    gbxBasicInfo: TGroupBox;
    gbxEmulators: TGroupBox;
    gbxFiles: TGroupBox;
    lID: TLabel;
    lBaseFolder: TLabel;
    lCompany: TLabel;
    lFileExtensions: TLabel;
    lMainEmulator: TLabel;
    lModel: TLabel;
    lOtherEmulators: TLabel;
    lTempFolder: TLabel;
    mExtensions: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    rgbGameKey: TRadioGroup;
    procedure actCancelExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);

  private
    { private declarations }
    FSystem: cEmutecaSystem;
    FEmuManager: cEmutecaEmulatorManager;
    procedure SetSystem(AValue: cEmutecaSystem);
    procedure SetEmuManager(AValue: cEmutecaEmulatorManager);

  protected
    procedure SaveData;
    procedure UpdateData;
    procedure ClearData;

    procedure UpdateLists;

  public
    { public declarations }

    property System: cEmutecaSystem read FSystem write SetSystem;

    property EmuManager: cEmutecaEmulatorManager
      read FEmuManager write SetEmuManager;
  end;

implementation

{$R *.lfm}

{ TfmEmutecaSystemEditor }

procedure TfmEmutecaSystemEditor.actSaveExecute(Sender: TObject);
begin
  SaveData;
end;

procedure TfmEmutecaSystemEditor.actCancelExecute(Sender: TObject);
begin
  UpdateData;
end;

procedure TfmEmutecaSystemEditor.SetSystem(AValue: cEmutecaSystem);
begin
  if FSystem = AValue then
    Exit;
  FSystem := AValue;
  UpdateData;
end;

procedure TfmEmutecaSystemEditor.SetEmuManager(AValue:
  cEmutecaEmulatorManager);
begin
  if FEmuManager = AValue then
    Exit;
  FEmuManager := AValue;
  UpdateLists;
end;

procedure TfmEmutecaSystemEditor.SaveData;
var
  i, j: integer;
begin
  System.Model := eModel.Text;
  System.Company := eCompany.Text;

  if cbxMainEmulator.ItemIndex <> -1 then
    System.MainEmulator := cEmutecaEmulator(
      cbxMainEmulator.Items.Objects[cbxMainEmulator.ItemIndex]).ID;

  // Adding/Removing other emulators,
  // but keeping not listed ones...
  i := 0;
  while i < clbOtherEmulators.Count do
  begin
    if clbOtherEmulators.Checked[i] then
      AddToStringList(System.OtherEmulators,
        cEmutecaEmulator(clbOtherEmulators.Items.Objects[i]).ID)
    else
    begin
      j := System.OtherEmulators.IndexOf(
        cEmutecaEmulator(clbOtherEmulators.Items.Objects[i]).ID);
      if j <> -1 then
        System.OtherEmulators.Delete(j);
    end;
    Inc(i);
  end;

  System.BaseFolder := eBaseFolder.Text;
  System.TempFolder := eTempFolder.Text;
  system.ExtractAll := chkExtractAllFiles.Checked;

  case rgbGameKey.ItemIndex of
    1: System.GameKey := TEFKCRC32;
    2: System.GameKey := TEFKFileName;
    3: System.GameKey := TEFKCustom;
    else  // SHA1 by default
      System.GameKey := TEFKSHA1;
  end;

  System.Extensions.Assign(mExtensions.Lines);
end;

procedure TfmEmutecaSystemEditor.UpdateData;
var
  aEmulator: cEmutecaEmulator;
  i: Integer;
begin
  ClearData;

  if not assigned(System) then
    Exit;

  lID.Caption := System.ID;

  eCompany.Text := System.Company;
  eModel.Text := System.Model;

  aEmulator := EmuManager.ItemById(System.MainEmulator);
  cbxMainEmulator.ItemIndex := cbxMainEmulator.Items.IndexOfObject(aEmulator);

  i := 0;
  while i < clbOtherEmulators.Count do
  begin
    aEmulator := cEmutecaEmulator(clbOtherEmulators.Items.Objects[i]);
    if System.OtherEmulators.IndexOf(aEmulator.ID) <> -1 then
      clbOtherEmulators.Checked[i] := True
    else
      clbOtherEmulators.Checked[i] := False;
    Inc(i);
  end;

  eBaseFolder.Text := SysPath(System.BaseFolder);
  eTempFolder.Text := SysPath(System.TempFolder);

  case System.GameKey of
    TEFKCRC32: rgbGameKey.ItemIndex := 1;
    TEFKFileName: rgbGameKey.ItemIndex := 2;
    TEFKCustom: rgbGameKey.ItemIndex := 3;
    else  // SHA1 by default
      rgbGameKey.ItemIndex := 0;
  end;

  chkExtractAllFiles.Checked := System.ExtractAll;

  mExtensions.Lines.Assign(System.Extensions);

end;

procedure TfmEmutecaSystemEditor.ClearData;
begin
  eModel.Clear;
  eCompany.Clear;
  cbxMainEmulator.ItemIndex := -1;
  clbOtherEmulators.CheckAll(cbUnchecked);
  eBaseFolder.Clear;
  eTempFolder.Clear;
  rgbGameKey.ItemIndex := 0;
  chkExtractAllFiles.Checked := False;
  mExtensions.Clear;
end;

procedure TfmEmutecaSystemEditor.UpdateLists;
begin
  clbOtherEmulators.Clear;
  cbxMainEmulator.Clear;

  if not assigned(EmuManager) then
    exit;

  EmuManager.AssingEnabledTo(clbOtherEmulators.Items);
  cbxMainEmulator.Items.Assign(clbOtherEmulators.Items);
end;

end.