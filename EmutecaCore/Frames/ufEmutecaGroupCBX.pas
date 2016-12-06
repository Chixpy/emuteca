unit ufEmutecaGroupCBX;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls,
  ucEmutecaGroup;

type

  { TfmEmutecaGroupCBX }

  TfmEmutecaGroupCBX = class(TFrame, IFPObserver)
    cbxGroup: TComboBox;
    procedure cbxGroupChange(Sender: TObject);

  private
    FSelectedGroup: cEmutecaGroup;
    FOnSelectGroup: TEmutecaReturnGroupCB;
    FGroupList: cEmutecaGroupList;
    procedure SetSelectedGroup(AValue: cEmutecaGroup);
    procedure SetOnSelectGroup(AValue: TEmutecaReturnGroupCB);
    procedure SetGroupList(AValue: cEmutecaGroupList);

  protected
    procedure UpdateGroups;
    {< Update drop down list. }

  public
    property GroupList: cEmutecaGroupList
      read FGroupList write SetGroupList;
    {< List of parents observed. }

    property SelectedGroup: cEmutecaGroup
      read FSelectedGroup write SetSelectedGroup;
    {< Returns current selected parent or select it in cbx. }

    property OnSelectGroup: TEmutecaReturnGroupCB
      read FOnSelectGroup write SetOnSelectGroup;
    {< Callback when selecting a parent. }

    procedure FPOObservedChanged(ASender: TObject;
      Operation: TFPObservedOperation; Data: Pointer);
    {< Subject has changed. }

    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

{ TfmEmutecaGroupCBX }

procedure TfmEmutecaGroupCBX.cbxGroupChange(Sender: TObject);
begin
  if cbxGroup.ItemIndex <> -1 then
    SelectedGroup := cEmutecaGroup(
      cbxGroup.Items.Objects[cbxGroup.ItemIndex])
  else
    SelectedGroup := nil;

  if Assigned(OnSelectGroup) then
    {Var := } OnSelectGroup(SelectedGroup);

  // TODO: True, change Emuteca.CurrentSystem?
end;

procedure TfmEmutecaGroupCBX.SetOnSelectGroup(AValue:
  TEmutecaReturnGroupCB);
begin
  if FOnSelectGroup = AValue then
    Exit;
  FOnSelectGroup := AValue;
end;

procedure TfmEmutecaGroupCBX.SetSelectedGroup(AValue: cEmutecaGroup);
var
  aPos: integer;
begin
  if FSelectedGroup = AValue then
    Exit;
  FSelectedGroup := AValue;

  if not assigned(SelectedGroup) then
  begin
    cbxGroup.ItemIndex := -1;
    Exit;
  end;

  aPos := cbxGroup.Items.IndexOfObject(SelectedGroup);
  if aPos = -1 then
  begin
    // Uhm....
    cbxGroup.ItemIndex :=
      cbxGroup.Items.AddObject(SelectedGroup.Title, SelectedGroup);
  end
  else
    cbxGroup.ItemIndex := aPos;
end;

procedure TfmEmutecaGroupCBX.SetGroupList(AValue: cEmutecaGroupList);
begin
  if FGroupList = AValue then
    Exit;

  if Assigned(FGroupList) then
    FGroupList.FPODetachObserver(Self);

  FGroupList := AValue;

  if Assigned(GroupList) then
    GroupList.FPOAttachObserver(Self);

  UpdateGroups;
end;

procedure TfmEmutecaGroupCBX.UpdateGroups;
var
  i: integer;
  aGroup: cEmutecaGroup;
begin
  cbxGroup.Items.BeginUpdate;
  cbxGroup.Clear;
  if assigned(GroupList) then
  begin
    i := 0;
    while i < GroupList.Count do
    begin
      aGroup := cEmutecaGroup(GroupList[i]);
      cbxGroup.Items.AddObject(aGroup.Title, aGroup);
      Inc(i);
    end;
  end;
  cbxGroup.Items.EndUpdate;
end;

procedure TfmEmutecaGroupCBX.FPOObservedChanged(ASender: TObject;
  Operation: TFPObservedOperation; Data: Pointer);
begin
  case Operation of
    ooChange: UpdateGroups;
    ooFree: GroupList := nil;
    ooAddItem: UpdateGroups; // TODO: Quick add Item
    ooDeleteItem: UpdateGroups; // TODO: Quick delete Item
    ooCustom: UpdateGroups;
  end;
end;

constructor TfmEmutecaGroupCBX.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

destructor TfmEmutecaGroupCBX.Destroy;
begin
  if Assigned(GroupList) then
    GroupList.FPODetachObserver(Self);

  inherited Destroy;
end;

end.