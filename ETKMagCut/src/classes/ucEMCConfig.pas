unit ucEMCConfig;

{< ETK Magazine Cutter config class.

  This file is part of ETK Magazine.

  Copyright (C) 2022 Chixpy

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
{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, IniFiles,
  // CHX abstracts
  uaCHXConfig;

const
  krsListsSection = 'Lists';
  krsMagazinesKey = 'Magazines';
  krsSectionsKey = 'Sections';
  krsLanguagesKey = 'Languages';
  krsTypesKey = 'Types';
  krsSystemsKey = 'Systems';

  krsFoldersSection = 'Folders';
  krsBaseOutFolderKey = 'BaseOutFolder';
type

  { cEMCConfig }

  cEMCConfig = class(caCHXConfig)
  private
    FBaseOutFolder: string;
    FLanguages: TStringList;
    FMagazines: TStringList;
    FSections: TStringList;
    FSystems: TStringList;
    FTypes: TStringList;
    procedure SetBaseOutFolder(AValue: string);
    
  public
    procedure LoadFromIni(aIniFile: TMemIniFile); override;
    procedure ResetDefaultConfig; override;
    {< Sets config properties to default values. }
    procedure SaveToIni(aIniFile: TMemIniFile); override;

    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    
  published
    property BaseOutFolder: string read FBaseOutFolder write SetBaseOutFolder;

    property Magazines: TStringList read FMagazines;
    property Sections: TStringList read FSections;
    property Languages: TStringList read FLanguages;
    property Types: TStringList read FTypes;
    property Systems: TStringList read FSystems;
  end;

implementation

{ cEMCConfig }

procedure cEMCConfig.SetBaseOutFolder(AValue: string);
begin
  if FBaseOutFolder = AValue then Exit;
  FBaseOutFolder := AValue;
end;

procedure cEMCConfig.LoadFromIni(aIniFile: TMemIniFile);
begin
  BaseOutFolder := aIniFile.ReadString(krsFoldersSection, krsBaseOutFolderKey, BaseOutFolder);

  Magazines.CommaText := aIniFile.ReadString(krsListsSection, krsMagazinesKey, Magazines.CommaText);
  Sections.CommaText := aIniFile.ReadString(krsListsSection, krsSectionsKey, Sections.CommaText);
  Languages.CommaText := aIniFile.ReadString(krsListsSection, krsLanguagesKey, Languages.CommaText);
  Types.CommaText := aIniFile.ReadString(krsListsSection, krsTypesKey, Types.CommaText);
  Systems.CommaText := aIniFile.ReadString(krsListsSection, krsSystemsKey, Systems.CommaText);
end;

procedure cEMCConfig.ResetDefaultConfig;
begin
  BaseOutFolder := '';

  Magazines.Clear;
  Sections.Clear;
  Languages.Clear;
  Types.Clear;
  Systems.Clear;
end;

constructor cEMCConfig.Create(aOwner: TComponent);
begin
  FMagazines := TStringList.Create;
  Magazines.Sorted := True;
  Magazines.Duplicates := dupIgnore;
  FSections := TStringList.Create;
  Sections.Sorted := True;
  Sections.Duplicates := dupIgnore;
  FLanguages := TStringList.Create;
  Languages.Sorted := True;
  Languages.Duplicates := dupIgnore;
  FTypes := TStringList.Create;
  Types.Sorted := True;
  Types.Duplicates := dupIgnore;
  FSystems := TStringList.Create;
  Systems.Sorted := True;
  Systems.Duplicates := dupIgnore;

  inherited Create(aOwner);
end;

destructor cEMCConfig.Destroy;
begin
  FreeAndNil(FMagazines);
  FreeAndNil(FSections);
  FreeAndNil(FLanguages);
  FreeAndNil(FTypes);
  FreeAndNil(FSystems);

  inherited Destroy;
end;

procedure cEMCConfig.SaveToIni(aIniFile: TMemIniFile);
begin
  aIniFile.WriteString(krsFoldersSection, krsBaseOutFolderKey, BaseOutFolder);

  aIniFile.WriteString(krsListsSection, krsMagazinesKey, Magazines.CommaText);
  aIniFile.WriteString(krsListsSection, krsSectionsKey, Sections.CommaText);
  aIniFile.WriteString(krsListsSection, krsLanguagesKey, Languages.CommaText);
  aIniFile.WriteString(krsListsSection, krsTypesKey, Types.CommaText);
  aIniFile.WriteString(krsListsSection, krsSystemsKey, Systems.CommaText);
end;

end.
