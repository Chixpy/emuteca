unit ucEmutecaPlayingStats;

{ cEmutecaPlayingStats class unit.

  This file is part of Emuteca Core.

  Copyright (C) 2006-2024 Chixpy
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateUtils, IniFiles, Graphics,
  // CHX units
  uCHXStrUtils,
  // Emuteca Core units.
  uEmutecaConst, uEmutecaRscStr;

type

  { cEmutecaPlayingStats class. }

  cEmutecaPlayingStats = class(TPersistent)
  public
    {property} LastTime : TDateTime;
    {< Last time played.

       In cGroup maybe used to store the last time that a game
         has played from the group.
    }
    {property} TimesPlayed : Int64;
    {< Total times played. }
    {property} PlayingTime : Int64;
    {< Total seconds played. }

    // TODO: This must be stored in another place...
    {property} Icon : TPicture;
    {< Cached icon for GUI. }
    {property} SysSoftIcon : TPicture;
    {< Cached system icon for GUI. }

    procedure AddPlayingTime(const Start : TDateTime;
      const NumberOfSeconds : Int64);
    {< Adds the seconds between two TDateTime to PlayingTime.

       Additionally adds 1 to TimesPlayed counter and updates LastTime
    }

    procedure WriteToIni(aIniFile : TCustomIniFile; const Section : string;
      const ExportMode : Boolean);
    procedure LoadFromIni(aIniFile : TCustomIniFile; const Section : string);
    procedure WriteToStrLst(aTxtFile : TStrings; const ExportMode : Boolean);
    procedure LoadFromStrLst(aTxtFile : TStrings; const NLine : Integer);

    function LastTimeStr : string;
    {< Returns LastTime as string. }
    function TimesPlayedStr : string; inline;
    {< Returns TimesPlayed as string. }
    function PlayingTimeStr : string; inline;
    {< Returns PlayingTime as string. }
  end;

  {< This class is for storing stats (System, Emulator, Parent and Soft). }

implementation

{ cEmutecaPlayingStats }

procedure cEmutecaPlayingStats.AddPlayingTime(const Start : TDateTime;
  const NumberOfSeconds : Int64);
begin
  PlayingTime := PlayingTime + NumberOfSeconds;
  LastTime := Start;
  TimesPlayed := TimesPlayed + 1;
end;

procedure cEmutecaPlayingStats.WriteToIni(aIniFile : TCustomIniFile;
  const Section : string; const ExportMode : Boolean);
begin
  // TODO: Exception...
  if not assigned(aIniFile) then
    Exit;

  if ExportMode then
  begin
    aIniFile.DeleteKey(Section, krsIniKeyLastTime);
    aIniFile.DeleteKey(Section, krsIniKeyTimesPlayed);
    aIniFile.DeleteKey(Section, krsIniKeyPlayingTime);
  end
  else
  begin
    aIniFile.WriteDateTime(Section, krsIniKeyLastTime, LastTime);
    aIniFile.WriteInt64(Section, krsIniKeyTimesPlayed, TimesPlayed);
    aIniFile.WriteInt64(Section, krsIniKeyPlayingTime, PlayingTime);
  end;
end;

procedure cEmutecaPlayingStats.LoadFromIni(aIniFile : TCustomIniFile;
  const Section : string);
begin
  // TODO: Exception...
  if not assigned(aIniFile) then
    Exit;

  LastTime := aIniFile.ReadDateTime(Section, krsIniKeyLastTime, LastTime);
  PlayingTime := aIniFile.ReadInt64(Section, krsIniKeyPlayingTime,
    PlayingTime);
  TimesPlayed := aIniFile.ReadInt64(Section, krsIniKeyTimesPlayed,
    TimesPlayed);
end;

procedure cEmutecaPlayingStats.WriteToStrLst(aTxtFile : TStrings;
  const ExportMode : Boolean);
begin
  // TODO: Exception...
  if not assigned(aTxtFile) then
    Exit;

  if ExportMode then
  begin
    aTxtFile.Add('');
    aTxtFile.Add('');
    aTxtFile.Add('');
  end
  else
  begin
    aTxtFile.Add(DateTimeToStr(LastTime));
    aTxtFile.Add(TimesPlayed.ToString);
    aTxtFile.Add(PlayingTime.ToString);
  end;
end;

procedure cEmutecaPlayingStats.LoadFromStrLst(aTxtFile : TStrings;
  const NLine : Integer);
var
  aStr : string;
begin
  // TODO: Exception...
  if not Assigned(aTxtFile) then
    Exit;

  if NLine + 3 > aTxtFile.Count then
    Exit;

  aStr := aTxtFile[Nline];
  if (aStr <> '') and (aStr <> krsImportKeepValueKey) then
    LastTime := StrToDateTimeDef(aStr, LastTime);
  aStr := aTxtFile[Nline + 1];
  if (aStr <> '') and (aStr <> krsImportKeepValueKey) then
    TimesPlayed := StrToInt64Def(aStr, TimesPlayed);
  aStr := aTxtFile[Nline + 2];
  if (aStr <> '') and (aStr <> krsImportKeepValueKey) then
    PlayingTime := StrToInt64Def(aStr, PlayingTime);
end;

function cEmutecaPlayingStats.LastTimeStr : string;
begin
  if LastTime = 0 then
    Result := rsNever
  else
    Result := DateTimeToStr(LastTime);
end;

function cEmutecaPlayingStats.TimesPlayedStr : string;
begin
  Result := IntToStr(TimesPlayed);
end;

function cEmutecaPlayingStats.PlayingTimeStr : string;
begin
  Result := SecondsToFmtStr(PlayingTime);
end;

initialization
  RegisterClass(cEmutecaPlayingStats);

finalization
  UnRegisterClass(cEmutecaPlayingStats);
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
