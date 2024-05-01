unit ucEIBConfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, IniFiles,
  // CHX units
  uCHXStrUtils,
  // CHX abstract classes
  uaCHXConfig;

const
  krsFoldersSection = 'Folders';
  krsLastInFolderKey = 'LastInFolder';
  krsLastOutFolderKey = 'LastOutFolder';
  krsGUIIconsIniKey = 'GUIIconsIni';

type

  { cEIBConfig }

  cEIBConfig = class(caCHXConfig)
  private
    FGUIIconsIni : string;
    FLastInFolder: string;
    FLastOutFolder: string;
    procedure SetGUIIconsIni(const aValue : string);
    procedure SetLastInFolder(AValue: string);
    procedure SetLastOutFolder(AValue: string);

  public
    property LastOutFolder: string read FLastOutFolder write SetLastOutFolder;
    property LastInFolder: string read FLastInFolder write SetLastInFolder;
    property GUIIconsIni: string read FGUIIconsIni write SetGUIIconsIni;

    procedure LoadFromIni(aIniFile: TMemIniFile); override;
    procedure ResetDefaultConfig; override;
    {< Sets config properties to default values. }
    procedure SaveToIni(aIniFile: TMemIniFile); override;

    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation


{ cEIBConfig }

procedure cEIBConfig.SetLastInFolder(AValue: string);
begin
  FLastInFolder := SetAsFolder(AValue);
end;

procedure cEIBConfig.SetGUIIconsIni(const aValue : string);
begin
  if FGUIIconsIni = aValue then Exit;
  FGUIIconsIni := aValue;
end;

procedure cEIBConfig.SetLastOutFolder(AValue: string);
begin
  FLastOutFolder := SetAsFolder(AValue);
end;

procedure cEIBConfig.LoadFromIni(aIniFile: TMemIniFile);
begin
  LastInFolder := aIniFile.ReadString(krsFoldersSection,
    krsLastInFolderKey, LastInFolder);
  LastOutFolder := aIniFile.ReadString(krsFoldersSection,
    krsLastOutFolderKey, LastOutFolder);
  GUIIconsIni := aIniFile.ReadString(krsFoldersSection,
    krsGUIIconsIniKey, GUIIconsIni);
end;

procedure cEIBConfig.ResetDefaultConfig;
begin
  LastOutFolder := '';
  LastInFolder := '';
  GUIIconsIni := 'Images/GUI/Icons.ini';
end;

procedure cEIBConfig.SaveToIni(aIniFile: TMemIniFile);
begin
  aIniFile.WriteString(krsFoldersSection, krsLastInFolderKey, LastInFolder);
  aIniFile.WriteString(krsFoldersSection, krsLastOutFolderKey, LastOutFolder);
  aIniFile.WriteString(krsFoldersSection, krsGUIIconsIniKey, GUIIconsIni);
end;

constructor cEIBConfig.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
end;

destructor cEIBConfig.Destroy;
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
