unit ufLEmuTKIcnSoftTree;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LazFileUtils, Forms, Controls,
  Graphics, Dialogs, IniFiles,
  VirtualTrees, LCLIntf, LCLType, ComCtrls, Menus, ActnList, LazUTF8,
  ucCHXImageList, uCHXImageUtils,
  uEmutecaCommon,
  uaEmutecaCustomSoft,
  ucEmutecaGroup, ucEmutecaSoftware,
  ufEmutecaSoftTree;

const
  LazEmuTKIconFiles: array [0..12] of string =
    (krsEDSVerified, krsEDSGood, krsEDSAlternate, krsEDSOverDump,
    krsEDSBadDump, krsEDSUnderDump, 'Fixed', 'Trainer',
    'Translation', 'Pirate', 'Cracked', 'Modified', 'Hack');

type

  { TfmLEmuTKIcnSoftTree }

  TfmLEmuTKIcnSoftTree = class(TfmEmutecaSoftTree)

    procedure VDTDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const CellText: string; const CellRect: TRect; var DefaultDraw: boolean);

  private
    FDefGrpIcon: TPicture;
    FDefSoftIcon: TPicture;
    FDefSysIcon: TPicture;
    FDumpIconList: cCHXImageList;
    FImageExt: TStrings;
    FSoftIconList: cCHXImageList;
    FZoneIconMap: cCHXImageMap;
    procedure SetDefGrpIcon(AValue: TPicture);
    procedure SetDefSoftIcon(AValue: TPicture);
    procedure SetDefSysIcon(AValue: TPicture);
    procedure SetDumpIconList(AValue: cCHXImageList);
    procedure SetImageExt(AValue: TStrings);
    procedure SetSoftIconList(AValue: cCHXImageList);
    procedure SetZoneIconMap(AValue: cCHXImageMap);

    protected
      procedure SetIconColumnsWidth;

      procedure DoLoadGUIConfig(aIniFile: TIniFile); override;

  public
    property DefSysIcon: TPicture read FDefSysIcon write SetDefSysIcon;
    property DefGrpIcon: TPicture read FDefGrpIcon write SetDefGrpIcon;
    property DefSoftIcon: TPicture read FDefSoftIcon write SetDefSoftIcon;

    property DumpIconList: cCHXImageList read FDumpIconList
      write SetDumpIconList;
    //< Icons of dump info.
    property ZoneIconMap: cCHXImageMap read FZoneIconMap write SetZoneIconMap;
    //< Icons for zones
    property ImageExt: TStrings read FImageExt write SetImageExt;

    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

{ TfmLEmuTKIcnSoftTree }

procedure TfmLEmuTKIcnSoftTree.VDTDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const CellText: string; const CellRect: TRect; var DefaultDraw: boolean);

  procedure DrawGroupText(aGroup: cEmutecaGroup; TargetCanvas: TCanvas;
    Node: PVirtualNode; Column: TColumnIndex; const CellText: string;
  const CellRect: TRect; var DefaultDraw: boolean);
  var
    IconRect: TRect;
    aIcon: TPicture;
  begin
    case Column of
      0: // System
      begin
        DefaultDraw := False;

        // Icon space
        IconRect := CellRect;
        IconRect.Right := IconRect.Left + IconRect.Bottom - IconRect.Top;

        aIcon := aGroup.CachedSystem.Stats.Icon;
        if not assigned(aIcon) then
          aIcon := DefSysIcon;

        if assigned(aIcon) then
          TargetCanvas.StretchDraw(CorrectAspectRatio(IconRect, aIcon),
              aIcon.Graphic);

        // Don't draw text

        // Text space
        //  IconRect := CellRect;
        //  IconRect.Left := IconRect.Left + IconRect.Bottom -
        //  IconRect.Top + VST.TextMargin;

        // DrawText(TargetCanvas.Handle, PChar(CellText), -1, IconRect,
        //  DT_NOPREFIX or DT_VCENTER or DT_SINGLELINE or
        //  DT_WORDBREAK or DT_END_ELLIPSIS or DT_EDITCONTROL);
      end;

      1: // Title
      begin
        DefaultDraw := False;

        // Icon space
        IconRect := CellRect;
        IconRect.Right := IconRect.Left + IconRect.Bottom - IconRect.Top;

        aIcon := aGroup.Stats.Icon;
        if not assigned(aIcon) then
          aIcon := DefGrpIcon;

        if assigned(aIcon) then
          TargetCanvas.StretchDraw(CorrectAspectRatio(IconRect, aIcon),
              aIcon.Graphic);

        // Text space
        IconRect := CellRect;
        IconRect.Left := IconRect.Left + IconRect.Bottom -
          IconRect.Top + VDT.TextMargin;

        DrawText(TargetCanvas.Handle, PChar(CellText), -1, IconRect,
          DT_NOPREFIX or DT_VCENTER or DT_SINGLELINE or
          DT_WORDBREAK or DT_END_ELLIPSIS or DT_EDITCONTROL);
      end;

    end;
  end;

  procedure DrawSoftText(aSoft: cEmutecaSoftware; TargetCanvas: TCanvas;
    Node: PVirtualNode; Column: TColumnIndex; const CellText: string;
  const CellRect: TRect; var DefaultDraw: boolean);
  var
    IconRect: TRect;
    aIcon: TPicture;
    i: integer;
    TmpStr: string;
  begin
    case Column of
      0: // System
      begin
        // Don't Draw
        DefaultDraw := False;
      end;

      1: // Title
      begin
        DefaultDraw := False;

        // Icon space
        IconRect := CellRect;
        IconRect.Right := IconRect.Left + IconRect.Bottom - IconRect.Top;

        aIcon := aSoft.Stats.Icon;
        if not assigned(aIcon) then
          aIcon := DefSoftIcon;

        if assigned(aIcon) then
          TargetCanvas.StretchDraw(CorrectAspectRatio(IconRect, aIcon),
              aIcon.Graphic);

        // Text space
        IconRect := CellRect;
        IconRect.Left := IconRect.Left + IconRect.Bottom -
          IconRect.Top + VDT.TextMargin;

        DrawText(TargetCanvas.Handle, PChar(CellText), -1, IconRect,
          DT_NOPREFIX or DT_VCENTER or DT_SINGLELINE or
          DT_WORDBREAK or DT_END_ELLIPSIS or DT_EDITCONTROL);
      end;

      2: // Version
      begin
        if not assigned(ZoneIconMap) then
          Exit;

        DefaultDraw := False;

        // Icon space
        IconRect := CellRect;
        IconRect.Right := IconRect.Left + IconRect.Bottom - IconRect.Top;

        if not ZoneIconMap.TryGetData(aSoft.Zone, aIcon) then
          ZoneIconMap.TryGetData('', aIcon);
        if assigned(aIcon) then
          TargetCanvas.StretchDraw(CorrectAspectRatio(IconRect, aIcon),
            aIcon.Graphic);

        // Text space
        IconRect := CellRect;
        IconRect.Left := IconRect.Left + IconRect.Bottom -
          IconRect.Top + VDT.TextMargin;

        DrawText(TargetCanvas.Handle, PChar(aSoft.Version), -1, IconRect,
          DT_NOPREFIX or DT_VCENTER or DT_SINGLELINE or
          DT_WORDBREAK or DT_END_ELLIPSIS or DT_EDITCONTROL);
      end;

      5: // Flags
      begin
        if not assigned(DumpIconList) then
          Exit;

        DefaultDraw := False;

        IconRect := CellRect;
        IconRect.Right := IconRect.Left + IconRect.Bottom - IconRect.Top;

        // DumpStatus (0-5)
        TargetCanvas.StretchDraw(CorrectAspectRatio(IconRect,
          DumpIconList[Ord(aSoft.DumpStatus)]),
          DumpIconList[Ord(aSoft.DumpStatus)].Graphic);

        // Others
        for i := 6 to High(LazEmuTKIconFiles) do
        begin
          IconRect.Left := IconRect.Left + IconRect.Bottom - IconRect.Top;
          IconRect.Right := IconRect.Right + IconRect.Bottom - IconRect.Top;

          case i of
            6: // Fixed
              TmpStr := aSoft.Fixed;
            7: // Trainer
              TmpStr := aSoft.Trainer;
            8: // Translation;
              TmpStr := aSoft.Translation;
            9: // Pirate
              TmpStr := aSoft.Pirate;
            10: // Cracked
              TmpStr := aSoft.Cracked;
            11: // Modified
              TmpStr := aSoft.Modified;
            12: // Hack
              TmpStr := aSoft.Hack;
            else
              TmpStr := '';
          end;

          // Draw icon
          if (TmpStr <> '') then
          begin
            TargetCanvas.StretchDraw(CorrectAspectRatio(IconRect,
              DumpIconList[i]), DumpIconList[i].Graphic);

            // Some magic
            case i of
              8: // Translation;
              begin
                if (TmpStr[1] = '+') then
                  TmpStr := Trim(UTF8Copy(TmpStr, 2, 3))
                else  // GoodXXX or "-" TOSEC
                  TmpStr := Trim(UTF8Copy(TmpStr, 1, 3));

                //Drawing text over icon
                DrawText(TargetCanvas.Handle, PChar(TmpStr), -1, IconRect,
                  DT_NOPREFIX or DT_VCENTER or DT_SINGLELINE or
                  DT_EDITCONTROL or DT_CENTER);
              end;
              else
                ;
            end;
          end;
        end;
      end;
      else
        DefaultDraw := True;
    end;

  end;

var
  pData: ^TObject;
begin
  pData := Sender.GetNodeData(Node);
  if pData^ = nil then
    Exit;

  if pData^ is cEmutecaGroup then
  begin
    DrawGroupText(cEmutecaGroup(pData^), TargetCanvas, Node,
      Column, CellText, CellRect, DefaultDraw);
  end
  else if pData^ is cEmutecaSoftware then
  begin
    DrawSoftText(cEmutecaSoftware(pData^), TargetCanvas, Node,
      Column, CellText, CellRect, DefaultDraw);
  end;
end;

procedure TfmLEmuTKIcnSoftTree.SetDumpIconList(AValue: cCHXImageList);
begin
  if FDumpIconList = AValue then
    Exit;
  FDumpIconList := AValue;
end;

procedure TfmLEmuTKIcnSoftTree.SetDefGrpIcon(AValue: TPicture);
begin
  if FDefGrpIcon = AValue then Exit;
  FDefGrpIcon := AValue;
end;

procedure TfmLEmuTKIcnSoftTree.SetDefSoftIcon(AValue: TPicture);
begin
  if FDefSoftIcon = AValue then Exit;
  FDefSoftIcon := AValue;
end;

procedure TfmLEmuTKIcnSoftTree.SetDefSysIcon(AValue: TPicture);
begin
  if FDefSysIcon = AValue then Exit;
  FDefSysIcon := AValue;
end;

procedure TfmLEmuTKIcnSoftTree.SetImageExt(AValue: TStrings);
begin
  if FImageExt = AValue then
    Exit;
  FImageExt := AValue;
end;

procedure TfmLEmuTKIcnSoftTree.SetSoftIconList(AValue: cCHXImageList);
begin
  if FSoftIconList = AValue then
    Exit;
  FSoftIconList := AValue;
end;

procedure TfmLEmuTKIcnSoftTree.SetZoneIconMap(AValue: cCHXImageMap);
begin
  if FZoneIconMap = AValue then
    Exit;
  FZoneIconMap := AValue;
end;

procedure TfmLEmuTKIcnSoftTree.SetIconColumnsWidth;
var
  TempOptions: TVTColumnOptions;
begin
  // Set Width of icon columns
  // System
  VDT.Header.Columns[0].Width :=
    VDT.DefaultNodeHeight + VDT.Header.Columns[0].Spacing * 2 +
    VDT.Header.Columns[0].Margin * 2;
  TempOptions := VDT.Header.Columns[0].Options;
  Exclude(TempOptions, coResizable);
  VDT.Header.Columns[0].Options := TempOptions;

  // DumpStatus
  VDT.Header.Columns[5].Width :=
    VDT.DefaultNodeHeight * 8 + VDT.Header.Columns[5].Spacing *
    2 + VDT.Header.Columns[5].Margin * 2;
  TempOptions := VDT.Header.Columns[5].Options;
  Exclude(TempOptions, coResizable);
  VDT.Header.Columns[5].Options := TempOptions;
end;

procedure TfmLEmuTKIcnSoftTree.DoLoadGUIConfig(aIniFile: TIniFile);
begin
  inherited DoLoadGUIConfig(aIniFile);

  // Restoring icons columns to its fixed size
  SetIconColumnsWidth;
end;

constructor TfmLEmuTKIcnSoftTree.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);

  SetIconColumnsWidth;
end;

destructor TfmLEmuTKIcnSoftTree.Destroy;
begin
  inherited Destroy;
end;

end.
