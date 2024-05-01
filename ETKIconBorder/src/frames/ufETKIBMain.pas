unit ufETKIBMain;

{< TfmETKIBMain main frame unit.

  (C) 2024 Chixpy https://github.com/Chixpy
}
{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  EditBtn, ActnList, Buttons, ComCtrls, ColorBox, IniFiles, BGRABitmap,
  BGRABitmapTypes, FileUtil, LazFileUtils, LCLIntf, Spin, Math,
  // CHX units
  uCHXConst, uCHXRscStr, uCHXDlgUtils, uCHXFileUtils, uCHXStrUtils, uCHXMath,
  // CHX frames
  ufCHXFrame, ufCHXBGRAImgViewer, ufCHXBGRAImgViewerEx,
  // ETKIconBorder classes
  ucEIBConfig;

resourcestring
  rsFillColor = 'L-Click: Fill with color. | R-Click: Fill while dragging. | '
    + 'M-Click: Pick color from pixel.';
  rsHintPaintingPixel = 'Drag to paint with desired color and transparency.';
  rsHintPaintPixel =
    'L-Click: Paint a pixel. | R-Click: Pick color from pixel.';
  rsHintPickingPaintColor = 'Color is selected when click release.';
  rsHintReplaceColor = 'L-Click: Replace clicked color with desired color and '
    + 'transparency.';
  rsHintReplacingColor = 'Color is replaced when click is finished.';
  rsHintSelect = 'Drag to select a rectangle. | R-Click: Make transparent. | '
    + 'M-Click: Cut.';
  rsHintSelecting = 'Drag until desired size.';

type
  TMouseActionInput = (
    maiSelectRect,         // Selecting a rectangle
    maiSelectingRect,
    maiPaintPixel,         // Removing pixels by hand
    maiPaintingPixel,
    maiPickingPaintColor,
    maiFillColor,          // Fill near pixels by color
    maiFillingColor,
    maiReplaceColor,
    maiReplacingColor      //Replacing color in full image
    );

  TProcessOutputFilter = (
    pofEmutecaIconBorder,         // Emuteca border style icons
    pofRemoveIconBorder           // Remove semitransparent pixels
    );

type

  { TfmETKIBMain }

  TfmETKIBMain = class(TfmCHXFrame)
    actAddFile : TAction;
    actAddFolder : TAction;
    actClearList : TAction;
    actDeleteFile : TAction;
    actInputFlipH : TAction;
    actInputFlipV : TAction;
    actInputZoomIn : TAction;
    actInputZoomOut : TAction;
    actInputZoomAuto : TAction;
    actInputZoomOrig : TAction;
    actOutputBlackBorder : TAction;
    actInputCutSelection : TAction;
    actOutputDefaultBorder : TAction;
    actInputTransparentPaint : TAction;
    actInputTransparentReplace : TAction;
    actInputTransparentFill : TAction;
    actInputSelectionTransparent : TAction;
    actProcessOutput : TAction;
    actOutputZoomOrig : TAction;
    actOutputZoomAuto : TAction;
    actOutputZoomOut : TAction;
    actOutputZoomIn : TAction;
    actInputRotateCCW : TAction;
    actInputRotateCW : TAction;
    actOpenInpDir : TAction;
    actOpenOutDir : TAction;
    actRemoveItem : TAction;
    actReplaceFile : TAction;
    actReplaceInpFile : TAction;
    actSaveOutput : TAction;
    alMain : TActionList;
    bBlackIconBorder : TButton;
    bColorBorderEmutecaIcon : TColorButton;
    bColorFillInput : TColorButton;
    bColorReplaceInput : TColorButton;
    bCutSelectionInput : TButton;
    bDefaultIconBorder : TButton;
    bFlipHInput : TBitBtn;
    bFlipVInput : TBitBtn;
    bRotateCCWInput : TBitBtn;
    bRotateCWInput : TBitBtn;
    bSelectionTransparentInput : TButton;
    bTransparentFill : TButton;
    bTransparentReplace : TButton;
    cbxColorBackground : TColorBox;
    chkAutoCropTransparency : TCheckBox;
    chkCopyReplaceToFill : TCheckBox;
    chkDiagonalNeightbours : TCheckBox;
    chkOverwriteOutput : TCheckBox;
    chkRemoveTransEmutecaIcon : TCheckBox;
    eOpacityBorderEmutecaIcon : TSpinEdit;
    eOpacityFillInput : TSpinEdit;
    eOpacityReplaceInput : TSpinEdit;
    eOutputFolder : TDirectoryEdit;
    eToleranceFillInput : TSpinEdit;
    FileList : TListBox;
    gbxFiles : TGroupBox;
    gbxInput : TGroupBox;
    gbxOutput : TGroupBox;
    gbxTransformInput : TGroupBox;
    ilMain : TImageList;
    lColorFillInput : TLabel;
    lColorReplaceInput : TLabel;
    lOpacityFillInput : TLabel;
    lOpacityReplaceInput : TLabel;
    lOutputFolder : TLabel;
    lToleranceFillInput : TLabel;
    OpenFilesDialog : TOpenDialog;
    pagCommonInput : TTabSheet;
    pagEmutecaIconBorder : TTabSheet;
    pagFillInput : TTabSheet;
    pagPaintInput : TTabSheet;
    pagRemoveEmutecaBorder : TTabSheet;
    pagReplaceInput : TTabSheet;
    pagSelectInput : TTabSheet;
    pFiles : TPanel;
    pgcImageInput : TPageControl;
    pgcImageOutput : TPageControl;
    pInputTools : TPanel;
    pOutputTools : TPanel;
    rgbBackGround : TRadioGroup;
    rgbRemoveTrans : TRadioGroup;
    SelectDirectoryDialog : TSelectDirectoryDialog;
    Splitter1 : TSplitter;
    Splitter2 : TSplitter;
    StatusBar : TStatusBar;
    tbbReplaceFile : TToolButton;
    tbbOutputZoom1 : TToolButton;
    tbbOutputZoomAuto : TToolButton;
    tbbOutputZoomIn : TToolButton;
    tbbOutputZoomOut : TToolButton;
    tbbOpenOutDir : TToolButton;
    tbbSaveOutput : TToolButton;
    tbFiles : TToolBar;
    tbbAddFile : TToolButton;
    tbbAddFolder : TToolButton;
    tbInput : TToolBar;
    tbbRemoveItem : TToolButton;
    tbbClearList : TToolButton;
    tbbDeleteFile : TToolButton;
    tbOutput : TToolBar;
    tbInputZoom : TToolBar;
    tbbInputZoomOut : TToolButton;
    tbOutputZoom : TToolBar;
    ToolButton1 : TToolButton;
    ToolButton2 : TToolButton;
    tbbOpenInpDir : TToolButton;
    tbbReplaceInpFile : TToolButton;
    tbbInputZoom1 : TToolButton;
    tbbInputZoomIn : TToolButton;
    tbbInputZoomAuto : TToolButton;
    tbbProcessOutput : TToolButton;
    ToolButton3 : TToolButton;
    procedure actAddFileExecute(Sender : TObject);
    procedure actAddFolderExecute(Sender : TObject);
    procedure actClearListExecute(Sender : TObject);
    procedure actDeleteFileExecute(Sender : TObject);
    procedure actInputCutSelectionExecute(Sender : TObject);
    procedure actInputFlipHExecute(Sender : TObject);
    procedure actInputFlipVExecute(Sender : TObject);
    procedure actInputRotateCCWExecute(Sender : TObject);
    procedure actInputRotateCWExecute(Sender : TObject);
    procedure actInputSelectionTransparentExecute(Sender : TObject);
    procedure actInputTransparentReplaceExecute(Sender : TObject);
    procedure actInputZoomAutoExecute(Sender : TObject);
    procedure actInputZoomInExecute(Sender : TObject);
    procedure actInputZoomOrigExecute(Sender : TObject);
    procedure actInputZoomOutExecute(Sender : TObject);
    procedure actOpenInpDirExecute(Sender : TObject);
    procedure actOpenOutDirExecute(Sender : TObject);
    procedure actOutputBlackBorderExecute(Sender : TObject);
    procedure actOutputDefaultBorderExecute(Sender : TObject);
    procedure actOutputZoomAutoExecute(Sender : TObject);
    procedure actOutputZoomInExecute(Sender : TObject);
    procedure actOutputZoomOrigExecute(Sender : TObject);
    procedure actOutputZoomOutExecute(Sender : TObject);
    procedure actProcessOutputExecute(Sender : TObject);
    procedure actRemoveItemExecute(Sender : TObject);
    procedure actReplaceFileExecute(Sender : TObject);
    procedure actReplaceInpFileExecute(Sender : TObject);
    procedure actSaveOutputExecute(Sender : TObject);
    procedure FileListClick(Sender : TObject);
    procedure pgcImageInputChange(Sender : TObject);
    procedure pgcImageOutputChange(Sender : TObject);
    procedure rgbBackGroundSelectionChanged(Sender : TObject);

  private
    FActualInputImage : TBGRABitmap;
    FActualOutputImage : TBGRABitmap;
    FEIBConfig : cEIBConfig;
    FInputViewer : TfmCHXBGRAImgViewerEx;
    FMouseActionInput : TMouseActionInput;
    FOutputViewer : TfmCHXBGRAImgViewerEx;
    FProcessOutputFilter : TProcessOutputFilter;
    FSelectionInput : TRect;
    FXOffset : LongInt;
    FYOffset : LongInt;
    procedure SetEIBConfig(const AValue : cEIBConfig);
    procedure SetMouseActionInput(const AValue : TMouseActionInput);
    procedure SetProcessOutputFilter(const AValue : TProcessOutputFilter);
    procedure SetSelectionInput(const AValue : TRect);
    procedure SetXOffset(const AValue : LongInt);
    procedure SetYOffset(const AValue : LongInt);

  protected
    property ActualInputImage : TBGRABitmap read FActualInputImage;
    property ActualOutputImage : TBGRABitmap read FActualOutputImage;
    {< Actual images. }

    property XOffset : LongInt read FXOffset write SetXOffset;
    property YOffset : LongInt read FYOffset write SetYOffset;
    {< Offset diference between Input image and Output image.

      if we click on output image we can know what pixels is in the input image.
    }
    property SelectionInput : TRect read FSelectionInput
      write SetSelectionInput;

    property InputViewer : TfmCHXBGRAImgViewerEx read FInputViewer;
    property OutputViewer : TfmCHXBGRAImgViewerEx read FOutputViewer;

    procedure DrawImageInput;
    procedure DrawImageOutput;

    procedure DoLoadGUIConfig(aIniFile : TIniFile); override;
    procedure DoSaveGUIConfig(aIniFile : TIniFile); override;

    procedure DoLoadGUIIcons(aIniFile : TIniFile;
      const aBaseFolder : string); override;

  public
    property EIBConfig : cEIBConfig read FEIBConfig write SetEIBConfig;

    property MouseActionInput : TMouseActionInput
      read FMouseActionInput write SetMouseActionInput;

    property ProcessOutputFilter : TProcessOutputFilter
      read FProcessOutputFilter write SetProcessOutputFilter;

    procedure ClearFrameData; override;
    procedure LoadFrameData; override;

    constructor Create(TheOwner : TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

{ TfmETKIBMain }

procedure TfmETKIBMain.actAddFileExecute(Sender : TObject);
begin
  SetDlgInitialDir(OpenFilesDialog, EIBConfig.LastInFolder);

  if not OpenFilesDialog.Execute then Exit;

  if OpenFilesDialog.Files.Count > 0 then
    EIBConfig.LastInFolder := ExtractFileDir(OpenFilesDialog.Files[0]);

  FileList.Items.AddStrings(OpenFilesDialog.Files, False);
end;

procedure TfmETKIBMain.actAddFolderExecute(Sender : TObject);
var
  i : integer;
  slFiles : TStringList;
begin
  SetDlgInitialDir(SelectDirectoryDialog, EIBConfig.LastInFolder);

  if not SelectDirectoryDialog.Execute then Exit;

  if SelectDirectoryDialog.Files.Count > 0 then
    EIBConfig.LastInFolder := ExtractFileDir(SelectDirectoryDialog.Files[0]);

  i := 0;
  slFiles := TStringList.Create;
  while i < SelectDirectoryDialog.Files.Count do
  begin
    slFiles.Clear;
    slFiles.BeginUpdate;
    FindAllFiles(slFiles, SelectDirectoryDialog.Files[i], '*.png', True);
    FileList.Items.AddStrings(slFiles, False);
    slFiles.EndUpdate;
    Inc(i);
  end;
  slFiles.Free;
end;

procedure TfmETKIBMain.actClearListExecute(Sender : TObject);
begin
  FileList.Clear;
  FreeAndNil(FActualInputImage);
  DrawImageInput;
  FreeAndNil(FActualOutputImage);
  DrawImageOutput;
end;

procedure TfmETKIBMain.actDeleteFileExecute(Sender : TObject);
begin
  if FileList.ItemIndex < 0 then
    Exit;

  if not FileExists(FileList.Items[FileList.ItemIndex]) then
    Exit;

  if not DeleteFileUTF8(FileList.Items[FileList.ItemIndex]) then
    Exit;

  actRemoveItem.Execute;
end;

procedure TfmETKIBMain.actInputCutSelectionExecute(Sender : TObject);
begin
  if SelectionInput.isEmpty then
    Exit;

  BGRAReplace(FActualInputImage, ActualInputImage.GetPart(SelectionInput));

  SelectionInput := SelectionInput.Empty;
  StatusBar.Panels[2].Text := '';

  DrawImageInput;
end;

procedure TfmETKIBMain.actInputFlipHExecute(Sender : TObject);
begin
  ActualInputImage.HorizontalFlip;
  DrawImageInput;
end;

procedure TfmETKIBMain.actInputFlipVExecute(Sender : TObject);
begin
  ActualInputImage.VerticalFlip;
  DrawImageInput;
end;

procedure TfmETKIBMain.actInputRotateCCWExecute(Sender : TObject);
begin
  BGRAReplace(FActualInputImage, ActualInputImage.RotateCCW);
  DrawImageInput;
end;

procedure TfmETKIBMain.actInputRotateCWExecute(Sender : TObject);
begin
  BGRAReplace(FActualInputImage, ActualInputImage.RotateCW);
  DrawImageInput;
end;

procedure TfmETKIBMain.actInputSelectionTransparentExecute(Sender : TObject);
begin
  if SelectionInput.isEmpty then
    Exit;

  ActualInputImage.FillRect(SelectionInput, BGRA(0, 0, 0, 0));

  DrawImageInput;
end;

procedure TfmETKIBMain.actInputTransparentReplaceExecute(Sender : TObject);
begin
  bColorReplaceInput.Enabled := False;
  bColorReplaceInput.ButtonColor := clBlack;
  eOpacityReplaceInput.Value := 0;
end;

procedure TfmETKIBMain.actInputZoomAutoExecute(Sender : TObject);
begin
  InputViewer.AutoZoom;
end;

procedure TfmETKIBMain.actInputZoomInExecute(Sender : TObject);
begin
  InputViewer.ZoomInX2;
end;

procedure TfmETKIBMain.actInputZoomOrigExecute(Sender : TObject);
begin
  InputViewer.Zoom := 100;
end;

procedure TfmETKIBMain.actInputZoomOutExecute(Sender : TObject);
begin
  InputViewer.ZoomOutX2;
end;

procedure TfmETKIBMain.actOpenInpDirExecute(Sender : TObject);
begin
  if FileList.ItemIndex < 0 then
    Exit;

  OpenDocument(ExtractFileDir(FileList.Items[FileList.ItemIndex]));
end;

procedure TfmETKIBMain.actOpenOutDirExecute(Sender : TObject);
begin
  if DirectoryExistsUTF8(eOutputFolder.Directory) then
    OpenDocument(eOutputFolder.Directory);
end;

procedure TfmETKIBMain.actOutputBlackBorderExecute(Sender : TObject);
begin
    bColorBorderEmutecaIcon.Enabled := True;
  bColorBorderEmutecaIcon.ButtonColor := clBlack;
  eOpacityBorderEmutecaIcon.Value := 255;
end;

procedure TfmETKIBMain.actOutputDefaultBorderExecute(Sender : TObject);
begin
    bColorBorderEmutecaIcon.Enabled := True;
  bColorBorderEmutecaIcon.ButtonColor := clGray;
  eOpacityBorderEmutecaIcon.Value := 128;
end;

procedure TfmETKIBMain.actOutputZoomAutoExecute(Sender : TObject);
begin
  OutputViewer.AutoZoom;
end;

procedure TfmETKIBMain.actOutputZoomInExecute(Sender : TObject);
begin
  OutputViewer.ZoomInX2;
end;

procedure TfmETKIBMain.actOutputZoomOrigExecute(Sender : TObject);
begin
  OutputViewer.Zoom := 100;
end;

procedure TfmETKIBMain.actOutputZoomOutExecute(Sender : TObject);
begin
  OutputViewer.ZoomOutX2;
end;

procedure TfmETKIBMain.actProcessOutputExecute(Sender : TObject);

  procedure AutoCropTransparentOutput;

    function AutoCropTransparentFirstRow : Boolean;
    var
      aColor : PBGRAPixel;
      i : integer;
    begin
      Result := False;
      if ActualOutputImage.Height <= 1 then
        Exit;

      aColor := ActualOutputImage.ScanLine[0];
      i := ActualOutputImage.Width;

      repeat
        Result := aColor^.alpha = 0;
        Inc(aColor);
        Dec(i);
      until (not Result) or (i <= 0);

      if Result then
      begin
        YOffset := YOffset + 1;
        BGRAReplace(FActualOutputImage, ActualOutputImage.GetPart(
          Rect(0, 1, ActualOutputImage.Width, ActualOutputImage.Height)));
      end;
    end;

    function AutoCropTransparentLastRow : Boolean;
    var
      aColor : PBGRAPixel;
      i : integer;
    begin
      Result := False;
      if ActualOutputImage.Height <= 1 then
        Exit;

      aColor := ActualOutputImage.ScanLine[ActualOutputImage.Height - 1];
      i := ActualOutputImage.Width - 1;

      repeat
        Result := aColor^.alpha = 0;
        Inc(aColor);
        Dec(i);
      until (not Result) or (i < 0);

      if Result then
        BGRAReplace(FActualOutputImage, ActualOutputImage.GetPart(
          Rect(0, 0, ActualOutputImage.Width, ActualOutputImage.Height - 1)));
    end;

    function AutoCropTransparentFirstCol : Boolean;
    var
      i : integer;
      aColor : PBGRAPixel;
    begin
      Result := False;
      if ActualOutputImage.Width <= 1 then
        Exit;

      i := ActualOutputImage.Height - 1;
      repeat
        aColor := ActualOutputImage.ScanLine[i];
        Result := aColor^.Alpha = 0;
        Dec(i);
      until (not Result) or (i < 0);

      if Result then
      begin
        XOffset := XOffset + 1;
        BGRAReplace(FActualOutputImage, ActualOutputImage.GetPart(
          Rect(1, 0, ActualOutputImage.Width, ActualOutputImage.Height)));
      end;
    end;

    function AutoCropTransparentLastCol : Boolean;
    var
      i : integer;
      aColor : PBGRAPixel;
    begin
      Result := False;
      if ActualOutputImage.Width <= 1 then
        Exit;

      i := ActualOutputImage.Height - 1;
      repeat
        aColor := ActualOutputImage.ScanLine[i];
        Inc(aColor, ActualOutputImage.Width - 1);
        Result := aColor^.Alpha = 0;
        Dec(i);
      until (not Result) or (i < 0);

      if Result then
        BGRAReplace(FActualOutputImage, ActualOutputImage.GetPart(
          Rect(0, 0, ActualOutputImage.Width - 1, ActualOutputImage.Height)));
    end;

  var
    Cont : Boolean;
  begin
    repeat
      Cont := AutoCropTransparentFirstRow;
      Cont := Cont or AutoCropTransparentLastRow;
      Cont := Cont or AutoCropTransparentFirstCol;
      Cont := Cont or AutoCropTransparentLastCol;
    until (not Cont);
  end;

  procedure RemoveSemitransparentPixels;
  var
    aColor : PBGRAPixel;
    i : integer;
  begin
    aColor := ActualOutputImage.Data;
    for i := 1 to ActualOutputImage.NbPixels do
    begin
      if aColor^.alpha < 255 then
        aColor^.Alpha := 0;
      Inc(aColor);
    end;
  end;

  procedure OpaqueSemitransparentPixels;
  var
    aColor : PBGRAPixel;
    i : integer;
  begin
    aColor := ActualOutputImage.Data;
    for i := 1 to ActualOutputImage.NbPixels do
    begin
      if aColor^.alpha > 0 then
        aColor^.Alpha := 255;
      Inc(aColor);
    end;
  end;

  procedure AutoReduceOutput;
  var
    x, y, i : integer;
    Factor : integer;
    CurrColor : PBGRAPixel;
  begin

    Factor := Min(ActualOutputImage.Width, ActualOutputImage.Height);

    x := 0;
    while (x < ActualOutputImage.Width) and (Factor > 1) do
    begin
      CurrColor := ActualOutputImage.ScanLine[0] + x;

      i := 0;
      y := 0;
      while (y < ActualOutputImage.Height) and (Factor > 1) do
      begin
        if (ActualOutputImage.ScanLine[y] + x)^ = CurrColor^ then
        begin
          Inc(i);
        end
        else
        begin
          Factor := GCD(Factor, i);
          CurrColor := ActualOutputImage.ScanLine[y] + x;
          i := 1;
        end;

        Inc(y);
      end;
      Factor := GCD(Factor, i);

      Inc(x);
    end;

    if Factor <= 1 then
      Exit;

    y := 0;
    while (y < ActualOutputImage.Height) and (Factor > 1) do
    begin
      CurrColor := ActualOutputImage.ScanLine[y];

      i := 0;
      x := 0;
      while (x < ActualOutputImage.Width) and (Factor > 1) do
      begin
        if (ActualOutputImage.ScanLine[y] + x)^ = CurrColor^ then
        begin
          Inc(i);
        end
        else
        begin
          Factor := GCD(Factor, i);
          CurrColor := ActualOutputImage.ScanLine[y] + x;
          i := 1;
        end;

        Inc(x);
      end;
      Factor := GCD(Factor, i);

      Inc(y);
    end;

    if Factor <= 1 then
      Exit;

    BGRAReplace(FActualOutputImage, ActualOutputImage.Resample(
      ActualOutputImage.Width div Factor, ActualOutputImage.Height div
      Factor, rmSimpleStretch));

  end;

  procedure AddSemitransparentBorder;
  var
    aColor, TempColor : PBGRAPixel;
    TempImg : TBGRABitmap;
    i : integer;
  begin

    // Hack (1/2): If opacity is 255, it will fail. So we change it to 254,
    //   a then we will revert again to 255

    if eOpacityBorderEmutecaIcon.Value = 255 then
      eOpacityBorderEmutecaIcon.Value := 254;

    // Adding transparent border, and making sure that there are not solid
    //   pixel in the borders
    TempImg := TBGRABitmap.Create(ActualOutputImage.Width +
      2, ActualOutputImage.Height + 2, BGRA(0, 0, 0, 0));

    TempImg.PutImage(1, 1, ActualOutputImage, dmDrawWithTransparency);

    BGRAReplace(FActualOutputImage, TempImg);
    // Output image OffSet moved
    XOffset := XOffset - 1;
    YOffset := YOffset - 1;


    aColor := ActualOutputImage.Data;

    for i := 1 to ActualOutputImage.NbPixels do
    begin

      // Sombra izquierda
      if aColor^.Alpha = 0 then
      begin
        if i mod ActualOutputImage.Width <> 0 then
        begin
          TempColor := aColor + 1;
          if TempColor^.Alpha = 255 then
          begin
            aColor^ := ColorToBGRA(bColorBorderEmutecaIcon.ButtonColor,
              eOpacityBorderEmutecaIcon.Value);
          end;
        end;
      end;


      // Sombra superior (Win)
      if aColor^.Alpha = 0 then
      begin
        if i > ActualOutputImage.Width then
        begin
          TempColor := aColor - ActualOutputImage.Width;
          if TempColor^.Alpha = 255 then
          begin
            aColor^ := ColorToBGRA(bColorBorderEmutecaIcon.ButtonColor,
              eOpacityBorderEmutecaIcon.Value);
          end;
        end;
      end;

      // Sombra derecha
      if aColor^.Alpha = 0 then
      begin
        if i mod ActualOutputImage.Width <> 1 then
        begin
          TempColor := aColor - 1;
          if TempColor^.Alpha = 255 then
          begin
            aColor^ := ColorToBGRA(bColorBorderEmutecaIcon.ButtonColor,
              eOpacityBorderEmutecaIcon.Value);
          end;
        end;
      end;


      // Sombra inferior (Win)
      if aColor^.Alpha = 0 then
      begin
        if i + ActualOutputImage.Width <= ActualOutputImage.NbPixels then
        begin
          TempColor := aColor + ActualOutputImage.Width;
          if TempColor^.Alpha = 255 then
          begin
            aColor^ := ColorToBGRA(bColorBorderEmutecaIcon.ButtonColor,
              eOpacityBorderEmutecaIcon.Value);
          end;
        end;
      end;

      Inc(aColor);
    end;

    // Hack (2/2): Reverting again to 255
    if eOpacityBorderEmutecaIcon.Value = 254 then
    begin
      eOpacityBorderEmutecaIcon.Value := 255;

      aColor := ActualOutputImage.Data;
      for i := 1 to ActualOutputImage.NbPixels do
      begin
        if aColor^.alpha = 254 then
          aColor^.Alpha := 255;
        Inc(aColor);
      end;
    end;

  end;

begin
  FreeAndNil(FActualOutputImage);

  if not Assigned(ActualInputImage) then
    Exit;

  FActualOutputImage := ActualInputImage.Duplicate;
  XOffset := 0;
  YOffset := 0;

  case ProcessOutputFilter of
    pofEmutecaIconBorder :
    begin
      if chkRemoveTransEmutecaIcon.Checked then
        RemoveSemitransparentPixels;
      AutoCropTransparentOutput;
      AutoReduceOutput;
      AddSemitransparentBorder;
      AutoCropTransparentOutput;
    end;

    pofRemoveIconBorder :
    begin
      case rgbRemoveTrans.ItemIndex of
        1 :
        begin
          if chkAutoCropTransparency.Checked then
            AutoCropTransparentOutput;
          OpaqueSemitransparentPixels;
          AutoReduceOutput;
        end;
        else
        begin
          RemoveSemitransparentPixels;
          if chkAutoCropTransparency.Checked then
            AutoCropTransparentOutput;
          AutoReduceOutput;
        end;
      end;
    end;

    else
      ;
  end;
  OutputViewer.ActualImage := ActualOutputImage;
  DrawImageOutput;
end;


procedure TfmETKIBMain.actRemoveItemExecute(Sender : TObject);
var
  i : integer;
begin
  i := FileList.ItemIndex;

  FileList.DeleteSelected;
  FreeAndNil(FActualInputImage);
  DrawImageInput;
  FreeAndNil(FActualOutputImage);
  DrawImageOutput;

  if i >= FileList.Count then i := FileList.Count - 1;

  if i >= 0 then
  begin
    FileList.ItemIndex := i;
    FileList.Click;
  end;
end;

procedure TfmETKIBMain.actReplaceFileExecute(Sender : TObject);
begin
  if (not Assigned(ActualInputImage)) or (FileList.ItemIndex = -1) then
    Exit;

  ActualInputImage.SaveToFileUTF8(FileList.Items[FileList.ItemIndex]);
end;

procedure TfmETKIBMain.actReplaceInpFileExecute(Sender : TObject);
var
  aFile : string;
begin
  if (not Assigned(ActualOutputImage)) or (FileList.ItemIndex = -1) then
    Exit;

  aFile := FileList.Items[FileList.ItemIndex];

  if not chkOverwriteOutput.Checked then
  begin
    // File already exists, so we add the new file to de list
    aFile := CHXCheckFileRename(aFile);
    FileList.Items.Add(aFile);
  end;

  ActualOutputImage.SaveToFileUTF8(aFile);

  FileList.Click;
end;

procedure TfmETKIBMain.actSaveOutputExecute(Sender : TObject);
var
  aFile : string;
begin
  if (not Assigned(ActualOutputImage)) or (FileList.ItemIndex = -1) then
    Exit;

  aFile := eOutputFolder.Directory;
  ForceDirectoriesUTF8(aFile);
  aFile := IncludeTrailingPathDelimiter(aFile) +
    ExtractFileName(FileList.Items[FileList.ItemIndex]);

  if not chkOverwriteOutput.Checked then
    aFile := CHXCheckFileRename(aFile);

  ActualOutputImage.SaveToFileUTF8(aFile);
end;

procedure TfmETKIBMain.FileListClick(Sender : TObject);
var
  aFile : string;
begin
  FreeAndNil(FActualInputImage);
  FreeAndNil(FActualOutputImage);
  DrawImageOutput;

  SelectionInput := SelectionInput.Empty;

  // No item selected
  if FileList.ItemIndex < 0 then
  begin
    DrawImageInput;
    Exit;
  end;

  aFile := FileList.Items[FileList.ItemIndex];

  if not FileExistsUTF8(aFile) then
  begin
    ShowMessageFmt(rsFileNotFound, [aFile]);
    FileList.Items.Delete(FileList.ItemIndex);
    DrawImageInput;
    Exit;
  end;

  try
    FActualInputImage := TBGRABitmap.Create(aFile);
  except
    FreeAndNil(FActualInputImage);
    ShowMessageFmt(rsErrorLoadingFile, [aFile]);
    FileList.Items.Delete(FileList.ItemIndex);
    DrawImageInput;
    Exit;
  end;
  InputViewer.ActualImage := ActualInputImage;
  DrawImageInput;
end;

procedure TfmETKIBMain.pgcImageInputChange(Sender : TObject);
begin
  case pgcImageInput.PageIndex of
    // 0: Common
    1 : MouseActionInput := maiSelectRect;
    2 : MouseActionInput := maiPaintPixel;
    3 : MouseActionInput := maiFillColor;
    4 : MouseActionInput := maiReplaceColor;
    else
      ;
  end;
end;

procedure TfmETKIBMain.pgcImageOutputChange(Sender : TObject);
begin
  case pgcImageOutput.PageIndex of
    0 : ProcessOutputFilter := pofEmutecaIconBorder;
    1 : ProcessOutputFilter := pofRemoveIconBorder;
    else
      ;
  end;
end;

procedure TfmETKIBMain.rgbBackGroundSelectionChanged(Sender : TObject);
begin
  // Enabling color button
  cbxColorBackground.Enabled := rgbBackGround.ItemIndex = 2;

  DrawImageInput;
  DrawImageOutput;
end;

procedure TfmETKIBMain.SetEIBConfig(const AValue : cEIBConfig);
begin
  if FEIBConfig = AValue then Exit;
  FEIBConfig := AValue;

  Enabled := True;
end;

procedure TfmETKIBMain.SetMouseActionInput(const AValue : TMouseActionInput);
var
  aHint : string;
begin
  if FMouseActionInput = AValue then
    Exit;
  FMouseActionInput := AValue;

  case MouseActionInput of
    maiSelectRect :
    begin
      InputViewer.MouseActionMode := maiMouseSelectRect;
      aHint := rsHintSelect;
    end;
    maiSelectingRect : aHint := rsHintSelecting;
    maiPaintPixel :
    begin
      InputViewer.MouseActionMode := maiMouseClick;
      aHint := rsHintPaintPixel;
    end;
    maiPaintingPixel : aHint := rsHintPaintingPixel;
    maiPickingPaintColor : aHint := rsHintPickingPaintColor;
    maiFillColor :
    begin
      InputViewer.MouseActionMode := maiMouseClick;
      aHint := rsFillColor;
    end;
    maiFillingColor : aHint := rsFillColor;
    maiReplaceColor :
    begin
      InputViewer.MouseActionMode := maiMouseClick;
      aHint := rsHintReplaceColor;
    end;
    maiReplacingColor : aHint := rsHintReplacingColor;
    else
      aHint := '';
  end;

  StatusBar.SimpleText := aHint;
end;

procedure TfmETKIBMain.SetProcessOutputFilter(
  const AValue : TProcessOutputFilter);
begin
  if FProcessOutputFilter = AValue then Exit;
  FProcessOutputFilter := AValue;
end;

procedure TfmETKIBMain.SetSelectionInput(const AValue : TRect);
begin
  if FSelectionInput = AValue then Exit;
  FSelectionInput := AValue;
end;

procedure TfmETKIBMain.SetXOffset(const AValue : LongInt);
begin
  if FXOffset = AValue then Exit;
  FXOffset := AValue;
end;

procedure TfmETKIBMain.SetYOffset(const AValue : LongInt);
begin
  if FYOffset = AValue then Exit;
  FYOffset := AValue;
end;

procedure TfmETKIBMain.DrawImageInput;
begin

  if not assigned(ActualInputImage) then
  begin
    InputViewer.ActualImage := nil;
    Exit;
  end;

  case rgbBackGround.ItemIndex of
    1 : // Magenta
    begin
      InputViewer.BackgroundColor := BGRA(255, 0, 255);
      InputViewer.BackgroundType := bkColor;
    end;
    2 : // Custom Color
    begin
      InputViewer.BackgroundColor := ColorToBGRA(cbxColorBackground.Selected);
      InputViewer.BackgroundType := bkColor;
    end
    else
      InputViewer.BackgroundType := bkChecker;
  end;

  InputViewer.DrawImage;
end;

procedure TfmETKIBMain.DrawImageOutput;
begin
  if not assigned(ActualOutputImage) then
  begin
    OutputViewer.ActualImage := nil;
    Exit;
  end;

  case rgbBackGround.ItemIndex of
    1 : // Magenta
    begin
      OutputViewer.BackgroundColor := BGRA(255, 0, 255);
      OutputViewer.BackgroundType := bkColor;
    end;
    2 : // Custom Color
    begin
      OutputViewer.BackgroundColor := ColorToBGRA(cbxColorBackground.Selected);
      OutputViewer.BackgroundType := bkColor;
    end
    else
      OutputViewer.BackgroundType := bkChecker;
  end;

  OutputViewer.DrawImage;
end;

procedure TfmETKIBMain.DoLoadGUIConfig(aIniFile : TIniFile);
begin
  inherited DoLoadGUIConfig(aIniFile);
end;

procedure TfmETKIBMain.DoSaveGUIConfig(aIniFile : TIniFile);
begin
  inherited DoSaveGUIConfig(aIniFile);
end;

procedure TfmETKIBMain.DoLoadGUIIcons(aIniFile : TIniFile;
  const aBaseFolder : string);
begin
  inherited DoLoadGUIIcons(aIniFile, aBaseFolder);
end;

procedure TfmETKIBMain.ClearFrameData;
begin
  inherited ClearFrameData;
end;

procedure TfmETKIBMain.LoadFrameData;
begin
  inherited LoadFrameData;
end;

constructor TfmETKIBMain.Create(TheOwner : TComponent);

  procedure CreateFrames;
  begin
    FInputViewer := TfmCHXBGRAImgViewerEx.Create(gbxInput);
    InputViewer.AutoZoomOnLoad := True;
    InputViewer.AutoCenterOnLoad := True;
    InputViewer.PopUpMenuEnabled := False;
    InputViewer.Name := 'InputImage';
    InputViewer.Align := alClient;
    InputViewer.Parent := gbxInput;

    FOutputViewer := TfmCHXBGRAImgViewerEx.Create(gbxOutput);
    OutputViewer.AutoZoomOnLoad := True;
    OutputViewer.AutoCenterOnLoad := True;
    OutputViewer.PopUpMenuEnabled := False;
    OutputViewer.Name := 'OutputImage';
    OutputViewer.Align := alClient;
    OutputViewer.Parent := gbxOutput;
  end;

begin
  inherited Create(TheOwner);

  CreateFrames;
end;

destructor TfmETKIBMain.Destroy;
begin
  InputViewer.ActualImage := nil;
  ActualOutputImage.Free;
  OutputViewer.ActualImage := nil;
  ActualInputImage.Free;

  inherited Destroy;
end;

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
