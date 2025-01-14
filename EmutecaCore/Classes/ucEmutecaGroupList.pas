{ This file is part of Emuteca

  This file is part of Emuteca Core.

  Copyright (C) 2006-2017 Chixpy
}
unit ucEmutecaGroupList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl, LazUTF8,
  ucEmutecaGroup;

type
  cEmutecaGenGroupList = specialize TFPGObjectList<cEmutecaGroup>;
  { cEmutecaGroupList }

  cEmutecaGroupList = class(cEmutecaGenGroupList)
  public
    procedure AssignToStrLst(aStrList: TStrings);
    function ItemById(aID: string): cEmutecaGroup;
    {< Returns the parent with aId key.

       @Result cEmutecaGroup found or nil.
    }
  end;

  TEmutecaGrpLstCB = procedure(aGroupList: cEmutecaGroupList) of object;

function EmutecaCompareGroupsByID(
  const aGroup1, aGroup2: cEmutecaGroup): integer;


implementation

function EmutecaCompareGroupsByID(
  const aGroup1, aGroup2: cEmutecaGroup): integer;
begin
  if assigned(aGroup1) then
  begin
    if assigned(aGroup2) then
      Result := aGroup1.CompareID(aGroup2.ID)
    else
      Result := 1;
  end
  else
  begin
    if assigned(aGroup2) then
      Result := -1
    else
      Result := 0;
  end;
end;

{ cEmutecaGroupList }

procedure cEmutecaGroupList.AssignToStrLst(aStrList: TStrings);
var
  i: integer;
  aGroup: cEmutecaGroup;
begin
  if not assigned(aStrList) then
    aStrList := TStringList.Create;

  aStrList.BeginUpdate;
  aStrList.Capacity := aStrList.Count + Count; // Speed up?
  i := 0;
  while i < Count do
  begin
    aGroup := Items[i];
    aStrList.AddObject(aGroup.Title, aGroup);
    Inc(i);
  end;
  aStrList.EndUpdate;
end;

function cEmutecaGroupList.ItemById(aID: string): cEmutecaGroup;
var
  i: integer;
  aGroup: cEmutecaGroup;
begin
  Result := nil;

  // Inverse search can be faster
  i := Count;
  while (not assigned(Result)) and (i > 0) do
  begin
    Dec(i);
    aGroup := Items[i];
    if aGroup.MatchID(aID) then
      Result := aGroup;
  end;
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
