unit ucEmutecaScriptEngine;

{< cEmutecaScriptEngine class unit.

  This file is part of Emuteca Core.

  Copyright (C) 2018-2024 Chixpy
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uPSComponent, uPSRuntime, uPSCompiler, uPSUtils,
  // CHX classes
  ucCHXScriptEngine,
  // Emuteca
  ucEmuteca,
  // PS Imports
  uPSI_uEmutecaConst, uPSI_uEmutecaRscStr, uPSI_uEmutecaCommon,
  uPSI_uaEmutecaCustomSGItem, uPSI_uaEmutecaCustomEmu,
  uPSI_uaEmutecaCustomSystem, uPSI_uaEmutecaCustomGroup,
  uPSI_uaEmutecaCustomSoft, uPSI_uaEmutecaCustomManager,
  uPSI_ucEmutecaPlayingStats, uPSI_ucEmutecaEmulator,
  uPSI_ucEmutecaSystem, uPSI_ucEmutecaGroup, uPSI_ucEmutecaSoftware,
  uPSI_ucEmutecaEmuList, uPSI_ucEmutecaSystemList,
  uPSI_ucEmutecaGroupList, uPSI_ucEmutecaSoftList,
  uPSI_ucEmutecaEmulatorManager, uPSI_ucEmutecaSystemManager,
  uPSI_ucEmutecaGroupManager, uPSI_ucEmutecaSoftManager,
  uPSI_ucEmutecaConfig, uPSI_ucEmuteca, uPSI_uEmutecaGUIDialogs;

type

  { cEmutecaScriptEngine }

  cEmutecaScriptEngine = class(cCHXScriptEngine)
  protected
    procedure PasScriptOnCompImport(Sender : TObject;
      X : TPSPascalCompiler); override;
    procedure PasScriptOnCompile(Sender : TPSScript); override;
    procedure PasScriptOnExecImport(Sender : TObject; se : TPSExec;
      X : TPSRuntimeClassImporter); override;
    procedure PasScriptOnExecute(Sender : TPSScript); override;
    function PasScriptOnFindUnknownFile(Sender : TObject;
      const OriginFileName : tbtstring;
      var FileName, Output : tbtstring) : Boolean;
      override;
    function PasScriptOnNeedFile(Sender : TObject;
      const OriginFileName : tbtstring;
      var FileName, Output : tbtstring) : Boolean;
      override;

  public
    {property} Emuteca : cEmuteca;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ cEmutecaScriptEngine }

procedure cEmutecaScriptEngine.PasScriptOnCompImport(Sender : TObject;
  X : TPSPascalCompiler);
begin
  inherited PasScriptOnCompImport(Sender, X);

  SIRegister_uEmutecaConst(X);
  SIRegister_uEmutecaRscStr(X);
  SIRegister_uEmutecaCommon(X);

  SIRegister_ucEmutecaPlayingStats(X);

  SIRegister_uaEmutecaCustomEmu(X);
  SIRegister_uaEmutecaCustomSGItem(X);
  SIRegister_uaEmutecaCustomGroup(X);
  SIRegister_uaEmutecaCustomSoft(X);
  SIRegister_uaEmutecaCustomSystem(X);
  SIRegister_uaEmutecaCustomManager(X);

  SIRegister_ucEmutecaEmulator(X);
  SIRegister_ucEmutecaEmulatorList(X);
  SIRegister_ucEmutecaEmulatorManager(X);

  SIRegister_ucEmutecaSoftware(X);
  SIRegister_ucEmutecaSoftList(X);
  SIRegister_ucEmutecaSoftManager(X);

  SIRegister_ucEmutecaGroup(X);
  SIRegister_ucEmutecaGroupList(X);
  SIRegister_ucEmutecaGroupManager(X);

  SIRegister_ucEmutecaSystem(X);
  SIRegister_ucEmutecaSystemList(X);
  SIRegister_ucEmutecaSystemManager(X);

  SIRegister_ucEmutecaConfig(X);
  SIRegister_ucEmuteca(X);

  SIRegister_uEmutecaGUIDialogs(X);
end;

procedure cEmutecaScriptEngine.PasScriptOnExecImport(Sender : TObject;
  se : TPSExec; X : TPSRuntimeClassImporter);
begin
  inherited PasScriptOnExecImport(Sender, se, X);

  RIRegister_uEmutecaConst_Routines(se);
  RIRegister_uEmutecaRscStr_Routines(se);
  RIRegister_uEmutecaCommon_Routines(se);

  RIRegister_ucEmutecaPlayingStats(X);

  RIRegister_uaEmutecaCustomEmu(X);
  RIRegister_uaEmutecaCustomSGItem(X);
  RIRegister_uaEmutecaCustomGroup(X);
  RIRegister_uaEmutecaCustomSoft(X);
  RIRegister_uaEmutecaCustomSystem(X);
  RIRegister_uaEmutecaCustomManager(X);

  RIRegister_ucEmutecaEmulator(X);
  RIRegister_ucEmutecaEmulatorList(X);
  RIRegister_ucEmutecaEmulatorManager(X);

  RIRegister_ucEmutecaSoftware(X);
  RIRegister_ucEmutecaSoftList(X);
  RIRegister_ucEmutecaSoftManager(X);

  RIRegister_ucEmutecaGroup(X);
  RIRegister_ucEmutecaGroupList(X);
  RIRegister_ucEmutecaGroupManager(X);

  RIRegister_ucEmutecaSystem(X);
  RIRegister_ucEmutecaSystemList(X);
  RIRegister_ucEmutecaSystemManager(X);

  RIRegister_ucEmutecaConfig(X);
  RIRegister_ucEmuteca(X);

  RIRegister_uEmutecaGUIDialogs_Routines(se);
end;

procedure cEmutecaScriptEngine.PasScriptOnCompile(Sender : TPSScript);
begin
  inherited PasScriptOnCompile(Sender);

  // Variables
  Sender.AddRegisteredPTRVariable('Emuteca', 'cEmuteca');
end;

procedure cEmutecaScriptEngine.PasScriptOnExecute(Sender : TPSScript);
begin
  inherited PasScriptOnExecute(Sender);

  Sender.SetPointerToData('Emuteca', @Emuteca,
    Sender.FindNamedType('cEmuteca'));
end;

function cEmutecaScriptEngine.PasScriptOnFindUnknownFile(Sender : TObject;
  const OriginFileName : tbtstring;
  var FileName, Output : tbtstring) : Boolean;
begin
  Result := inherited PasScriptOnFindUnknownFile(Sender,
    OriginFileName, FileName, Output);
end;

function cEmutecaScriptEngine.PasScriptOnNeedFile(Sender : TObject;
  const OriginFileName : tbtstring;
  var FileName, Output : tbtstring) : Boolean;
begin
  Result := inherited PasScriptOnNeedFile(Sender, OriginFileName,
    FileName, Output);
end;

constructor cEmutecaScriptEngine.Create;
begin
  inherited Create;
end;

destructor cEmutecaScriptEngine.Destroy;
begin
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
