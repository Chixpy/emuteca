program ETKMagCut;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, ufrMain, ufrCHXForm, ufCHXFrame, ufCHXFileList, ufCHXBGRAImgViewerEx,
  ufCHXBGRAImgViewer, uVersionSupport, uCHXStrUtils, uCHXRscStr, uCHXConst,
  uCHXImageUtils, uaCHXConfig, ufEMCMain, uEMCRscStr, ufEMCImagePropEditor,
  ucEMCConfig, uEMCConst
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TfrmETKMagazineCutter, frmETKMagazineCutter);
  Application.Run;
end.

