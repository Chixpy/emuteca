unit ucEmutecaConfig;
{< cEmutecaConfig class unit.

  This file is part of Emuteca

  Copyright (C) 2006-2024 Chixpy
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazFileUtils, LazUTF8, Graphics, IniFiles,
  // CHX units
  uCHXStrUtils, uCHX7zWrapper,
  // CHX abstracts
  uaCHXConfig;

const
  // [Config]
  krsIniSecConfig = 'Config';
  krsIniKeyEmulatorsFile = 'EmulatorsFile';
  krsDefEmulatorsFile = 'Data/Emulators.ini';
  krsIniKeyAutoSysFoldersFile = 'AutoSysFolders';
  krsDefAutoSysFolder = 'Data/SysFolders.csv';
  krsIniKeySystemsFile = 'SystemsFile';
  krsDefSystemsFile = 'Data/Systems.ini';
  krsIniKeySysDataFolder = 'SysDataFolder';
  krsDefSysDataFolder = 'Systems/';
  krsIniKeyTagsFolder = 'TagsFolder';
  krsDefTagsFolder = 'Tags/';

  // [Tools]
  krsIniSecTools = 'Tools';
  krsIniKey7zCMExecutable = '7zCMExecutable';
  krsDefz7CMExecutable = 'Tools/7zip/7z.exe';
  krsIniKey7zGExecutable = '7zGExecutable';
  krsDefz7GExecutable = 'Tools/7zip/7zG.exe';

  // [Extensions]
  krsIniSecExtensions = 'Extensions';
  krsIniKeyCompressedExtensions = 'CompressedExtensions';
  krsDefCompressedExtensions = '7z,rar,zip,cb7,cbr,cbz';
  {< CompressedExtensions.CommaText := w7zGetFileExts;

    Removed ext: 001,cab,chm,dll,iso,img,jar,msi,swf,ntfs,ppt,doc,xls,xpi,vhd,
      deb,rpm,cpio,cramfs,dmg,fat,flv,mbr,nsis,sys,bpl,hfs,hxi,hxq,hxr,hxs,
      chi,chq,chw,hxw,msp,scap,squashfs,swm,wim,exe,lit,xar,xz,z,lzma,lzma86,
      r00,tar,taz,tbz,tbz2,tgz,tpz,txz,gz,gzip,lha,lzh,bz2,bzip2
  }

  // [Temp]
  krsIniSecTemp = 'Temp';
  krsIniKeyTempSubfolder = 'TempSubfolder';
  krsDefTempSubfolder = 'tEMpUTECA/';
  krsIniKeyTempFile = 'TempFile';
  krsDefTempFile = 'Emuteca.tmp';

  // [Misc]
  krsIniSecMisc = 'Misc';
  krsIniKeyMinPlayTime = 'MinPlayTime';
  kDefMinPlayTime = 60;

type

  { cEmutecaConfig }
  cEmutecaConfig = class(caCHXConfig)
  private
    FAutoSysFoldersFile : string;
    FCompressedExtensions : TStringList;
    FEmulatorsFile : string;
    FSysDataFolder : string;
    FMinPlayTime : Integer;
    FSystemsFile : string;
    FTagsFolder : string;
    FTempFile : string;
    FTempSubFolder : string;
    FSoftFile : string;
    Fz7CMExecutable : string;
    Fz7GExecutable : string;
    procedure SetAutoSysFoldersFile(aValue : string);
    procedure SetEmulatorsFile(const aValue : string);
    procedure SetSysDataFolder(aValue : string);
    procedure SetMinPlayTime(aValue : Integer);
    procedure SetSystemsFile(const aValue : string);
    procedure SetTagsFolder(aValue : string);
    procedure SetTempFile(const aValue : string);
    procedure SetTempSubFolder(const aValue : string);
    procedure SetSoftFile(aValue : string);
    procedure Setz7CMExecutable(const aValue : string);
    procedure Setz7GExecutable(const aValue : string);

  public
    // Tools
    property z7CMExecutable : string read Fz7CMExecutable
      write Setz7CMExecutable;
    {< 7z.exe path. }
    property z7GExecutable : string read Fz7GExecutable write Setz7GExecutable;
    {< 7zG.exe path. }
    property CompressedExtensions : TStringList read FCompressedExtensions;
    {< List of compressed file extensions. }

    // Config/Data
    property EmulatorsFile : string read FEmulatorsFile write SetEmulatorsFile;
    {< Emulators file. }
    property SystemsFile : string read FSystemsFile write SetSystemsFile;
    {< Systems file. }
    property SysDataFolder : string read FSysDataFolder write SetSysDataFolder;
    {< Systems' data folder (cvs and egl). }
    property AutoSysFolder : string read FAutoSysFoldersFile
      write SetAutoSysFoldersFile;
    {< File with automatic folder structure.

      TODO: It's a Emuteca GUI config.
    }
    property TagsFolder : string read FTagsFolder write SetTagsFolder;
    {< Folder with tags files.

      TODO: Is it a Emuteca GUI config?.
    }


    // Temp folder/file
    property TempSubfolder : string read FTempSubFolder write SetTempSubFolder;
    {< Subfolder for temporal files.

      It can be a full path folder, or if a relative path is stored
        a subfolder for system's temporal folder. }
    property TempFile : string read FTempFile write SetTempFile;
    {< Temp filename...

      TODO: Not used...}

    // Misc
    property MinPlayTime : Integer
      read FMinPlayTime write SetMinPlayTime;
    {< Minimal time playing needed to store in statistics. }

    procedure LoadFromIni(aIniFile : TMemIniFile); override;
    procedure SaveToIni(aIniFile : TMemIniFile); override;
    procedure ResetDefaultConfig; override;

    constructor Create;
    destructor Destroy; override;
  end;
  {< Class wich has all general options and configurations for Emuteca Core.

    All folder paths (absolute and relative) have the trailing path separator.
  }
implementation

{ cEmutecaConfig }
procedure cEmutecaConfig.SetAutoSysFoldersFile(aValue : string);
begin
  FAutoSysFoldersFile := SetAsFile(aValue);
end;

procedure cEmutecaConfig.SetEmulatorsFile(const aValue : string);
begin
  FEmulatorsFile := SetAsFile(aValue);
end;

procedure cEmutecaConfig.SetSysDataFolder(aValue : string);
begin
  FSysDataFolder := SetAsFolder(aValue);
end;

procedure cEmutecaConfig.SetMinPlayTime(aValue : Integer);
begin
  FMinPlayTime := aValue;

  if MinPlayTime < 1 then
    FMinPlayTime := 60;
end;

procedure cEmutecaConfig.SetSystemsFile(const aValue : string);
begin
  FSystemsFile := SetAsFile(aValue);
end;

procedure cEmutecaConfig.SetTagsFolder(aValue : string);
begin
  FTagsFolder := SetAsFolder(aValue);
end;

procedure cEmutecaConfig.SetTempFile(const aValue : string);
begin
  FTempFile := SetAsFile(aValue);
end;

procedure cEmutecaConfig.SetTempSubFolder(const aValue : string);
begin
  FTempSubFolder := SetAsFolder(aValue);
end;

procedure cEmutecaConfig.SetSoftFile(aValue : string);
begin
  FSoftFile := SetAsFile(aValue);
end;

procedure cEmutecaConfig.Setz7CMExecutable(const aValue : string);
begin
  Fz7CMExecutable := SetAsFile(aValue);

  // TODO: This must be done by cEmuteca and use cEmuteca.BaseDir as base
  if not FilenameIsAbsolute(z7CMExecutable) then
    w7zSetPathTo7zexe(CreateAbsoluteSearchPath(z7CMExecutable,
      GetCurrentDirUTF8));
end;

procedure cEmutecaConfig.Setz7GExecutable(const aValue : string);
begin
  Fz7GExecutable := SetAsFile(aValue);

  // TODO: This must be done by cEmuteca and use cEmuteca.BaseDir as base
  if not FilenameIsAbsolute(z7GExecutable) then
    w7zSetPathTo7zGexe(CreateAbsoluteSearchPath(z7GExecutable,
      GetCurrentDirUTF8));
end;

procedure cEmutecaConfig.LoadFromIni(aIniFile : TMemIniFile);
begin
  // Config/Data
  EmulatorsFile := aIniFile.ReadString(krsIniSecConfig,
    krsIniKeyEmulatorsFile, EmulatorsFile);
  SystemsFile := aIniFile.ReadString(krsIniSecConfig,
    krsIniKeySystemsFile, SystemsFile);
  AutoSysFolder := aIniFile.ReadString(krsIniSecConfig,
    krsIniKeyAutoSysFoldersFile, AutoSysFolder);
  SysDataFolder := aIniFile.ReadString(krsIniSecConfig,
    krsIniKeySysDataFolder, SysDataFolder);
  TagsFolder := aIniFile.ReadString(krsIniSecConfig,
    krsIniKeyTagsFolder, TagsFolder);

  // Tools
  z7CMExecutable := aIniFile.ReadString(krsIniSecTools,
    krsIniKey7zCMExecutable, z7CMExecutable);
  z7GExecutable := aIniFile.ReadString(krsIniSecTools,
    krsIniKey7zGExecutable, z7GExecutable);

  // File extensions
  CompressedExtensions.CommaText :=
    Trim(UTF8LowerCase(aIniFile.ReadString(krsIniSecExtensions,
    krsIniKeyCompressedExtensions, CompressedExtensions.CommaText)));

  // Temp
  TempSubfolder := aIniFile.ReadString(krsIniSecTemp,
    krsIniKeyTempSubfolder, TempSubfolder);
  TempFile := aIniFile.ReadString(krsIniSecTemp,
    krsIniKeyTempFile, TempFile);

  // Misc
  MinPlayTime := aIniFile.ReadInteger(krsIniSecMisc,
    krsIniKeyMinPlayTime, MinPlayTime);

end;

procedure cEmutecaConfig.SaveToIni(aIniFile : TMemIniFile);
begin
  // Config/Data
  aIniFile.WriteString(krsIniSecConfig, krsIniKeyEmulatorsFile,
    EmulatorsFile);
  aIniFile.WriteString(krsIniSecConfig, krsIniKeyAutoSysFoldersFile,
    AutoSysFolder);
  aIniFile.WriteString(krsIniSecConfig, krsIniKeySystemsFile, SystemsFile);
  aIniFile.WriteString(krsIniSecConfig, krsIniKeySysDataFolder,
    SysDataFolder);
  aIniFile.WriteString(krsIniSecConfig, krsIniKeyTagsFolder, TagsFolder);

  // Tools
  aIniFile.WriteString(krsIniSecTools, krsIniKey7zCMExecutable,
    z7CMExecutable);
  aIniFile.WriteString(krsIniSecTools, krsIniKey7zGExecutable,
    z7GExecutable);

  // File extensions
  aIniFile.WriteString(krsIniSecExtensions, krsIniKeyCompressedExtensions,
    Trim(UTF8LowerCase(CompressedExtensions.CommaText)));

  // Temp
  aIniFile.WriteString(krsIniSecTemp, krsIniKeyTempSubfolder, TempSubfolder);
  aIniFile.WriteString(krsIniSecTemp, krsIniKeyTempFile, TempFile);

  // Misc
  aIniFile.WriteInteger(krsIniSecMisc, krsIniKeyMinPlayTime, MinPlayTime);
end;

procedure cEmutecaConfig.ResetDefaultConfig;
begin
  // Config/Data
  EmulatorsFile := krsDefEmulatorsFile;
  AutoSysFolder := krsDefAutoSysFolder;
  SystemsFile := krsDefSystemsFile;
  SysDataFolder := krsDefSysDataFolder;
  TagsFolder := krsDefTagsFolder;

  // Tools
  z7CMExecutable := krsDefz7CMExecutable;
  z7GExecutable := krsDefz7CMExecutable;
  CompressedExtensions.CommaText := krsDefCompressedExtensions;

  // Temp
  TempSubfolder := krsDefTempSubfolder;
  TempFile := krsDefTempFile;

  // Misc
  MinPlayTime := kDefMinPlayTime;

end;

constructor cEmutecaConfig.Create;
begin
  // We must create objects before inherited Create, because it calls
  //    Self.ResetDefaultConfig
  FCompressedExtensions := TStringList.Create;
  CompressedExtensions.Sorted := True;
  CompressedExtensions.CaseSensitive := False;

  inherited Create;
end;

destructor cEmutecaConfig.Destroy;
begin
  CompressedExtensions.Free;
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
