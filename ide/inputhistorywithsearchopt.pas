{
 ***************************************************************************
 *                                                                         *
 *   This source is free software; you can redistribute it and/or modify   *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This code is distributed in the hope that it will be useful, but      *
 *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *
 *   General Public License for more details.                              *
 *                                                                         *
 *   A copy of the GNU General Public License is available on the World    *
 *   Wide Web at <http://www.gnu.org/copyleft/gpl.html>. You can also      *
 *   obtain it by writing to the Free Software Foundation,                 *
 *   Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.   *
 *                                                                         *
 ***************************************************************************

  Abstract:
    SynEdit (actually TSynSearchOptions) dependent parts separated from
    InputHistory unit. The idea is to reduce dependencies.
}
unit InputhistoryWithSearchOpt;

{$mode objfpc}{$H+}

interface

uses
  // LazUtils
  Laz2_XMLCfg, LazFileUtils,
  // SynEdit
  SynEditTypes,
  // IDE
  LazConf, InputHistory, DiffPatch;

type

  { TInputHistoriesWithSearchOpt }

  TInputHistoriesWithSearchOpt = class(TInputHistories)
  private const
    PathToOptions0: array[Boolean] of string = ('Options', 'Options');    // old config file
    PathToOptions1: array[Boolean] of string = ('Options', 'SelOptions'); // new config file
    XMLConfigVersion = 1;
  public const
    SaveOptionsGeneral = [ssoMatchCase, ssoWholeWord, ssoRegExpr, ssoRegExprMultiLine,
      ssoPrompt, ssoBackwards];
    SaveOptionsSelSpecific = [ssoEntireScope, ssoSelectedOnly];
    SaveOptions = SaveOptionsGeneral + SaveOptionsSelSpecific;
  private
    FDiffFlags: TTextDiffFlags;
    FDiffText2: string;
    FDiffText2OnlySelection: boolean;
    FFindOptions: array[Boolean] of TSynSearchOptions; // array[SelAvail] - selection available
    function GetFindOptions(const ASelAvail: Boolean): TSynSearchOptions;
    procedure SetFindOptions(const ASelAvail: Boolean;
      const AFindOptions: TSynSearchOptions);
  protected
    procedure LoadSearchOptions(XMLConfig: TXMLConfig; const Path: string); override;
    procedure SaveSearchOptions(XMLConfig: TXMLConfig; const Path: string); override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    procedure SetLazarusDefaultFilename; override;

    property FindOptions[const ASelAvail: Boolean]: TSynSearchOptions read GetFindOptions write SetFindOptions;
    procedure LoadFromXMLConfig(XMLConfig: TXMLConfig; const Path: string); override;
    procedure SaveToXMLConfig(XMLConfig: TXMLConfig; const Path: string); override;

    // diff dialog
    property DiffFlags: TTextDiffFlags read FDiffFlags write FDiffFlags;
    property DiffText2: string read FDiffText2 write FDiffText2;
    property DiffText2OnlySelection: boolean read FDiffText2OnlySelection
                                             write FDiffText2OnlySelection;
  end;

const
  LazFindSearchOptionsDefault: array[Boolean] of TSynSearchOptions = ([], [ssoEntireScope, ssoSelectedOnly]);
  LazFindSearchOptionNames: array[TSynSearchOption] of string = (
    'MatchCase',
    'WholeWord',
    'Backwards',
    'EntireScope',
    'SelectedOnly',
    'Replace',
    'ReplaceAll',
    'Prompt',
    'SearchInReplacement',
    'RegExpr',
    'RegExprMultiLine',
    'ssoFindContinue'
    );

var
  InputHistoriesSO: TInputHistoriesWithSearchOpt = nil;

implementation

const
  DefaultHistoryFile = 'inputhistory.xml';
  DefaultDiffFlags = [tdfIgnoreCase,tdfIgnoreEmptyLineChanges,
                      tdfIgnoreLineEnds,tdfIgnoreTrailingSpaces];

{ TInputHistoriesWithSearchOpt }

constructor TInputHistoriesWithSearchOpt.Create;
begin
  inherited Create;
  FFindOptions:=LazFindSearchOptionsDefault;
end;

destructor TInputHistoriesWithSearchOpt.Destroy;
begin
  inherited Destroy;
end;

procedure TInputHistoriesWithSearchOpt.Clear;
begin
  inherited Clear;
  FDiffFlags:=DefaultDiffFlags;
  FDiffText2:='';
  FDiffText2OnlySelection:=false;
end;

procedure TInputHistoriesWithSearchOpt.SetLazarusDefaultFilename;
var
  ConfFileName: string;
begin
  ConfFileName:=AppendPathDelim(GetPrimaryConfigPath)+DefaultHistoryFile;
  CopySecondaryConfigFile(DefaultHistoryFile);
  FFilename:=ConfFilename;
  inherited SetLazarusDefaultFilename;
end;

procedure TInputHistoriesWithSearchOpt.LoadFromXMLConfig(XMLConfig: TXMLConfig;
  const Path: string);
var
  DiffFlag: TTextDiffFlag;
begin
  inherited LoadFromXMLConfig(XMLConfig, Path);

  // diff dialog
  FDiffFlags:=[];
  for DiffFlag:=Low(TTextDiffFlag) to High(TTextDiffFlag) do begin
    if XMLConfig.GetValue(
      Path+'DiffDialog/Options/'+TextDiffFlagNames[DiffFlag],
      DiffFlag in DefaultDiffFlags)
    then
      Include(FDiffFlags,DiffFlag);
  end;
  FDiffText2:=XMLConfig.GetValue(Path+'DiffDialog/Text2/Name','');
  FDiffText2OnlySelection:=
    XMLConfig.GetValue(Path+'DiffDialog/Text2/OnlySelection',false);
end;

procedure TInputHistoriesWithSearchOpt.SaveToXMLConfig(XMLConfig: TXMLConfig;
  const Path: string);
var
  DiffFlag: TTextDiffFlag;
begin
  inherited SaveToXMLConfig(XMLConfig, Path);

  // diff dialog
  for DiffFlag:=Low(TTextDiffFlag) to High(TTextDiffFlag) do begin
    XMLConfig.SetDeleteValue(
      Path+'DiffDialog/Options/'+TextDiffFlagNames[DiffFlag],
      DiffFlag in DiffFlags,DiffFlag in DefaultDiffFlags);
  end;
  XMLConfig.SetDeleteValue(Path+'DiffDialog/Text2/Name',FDiffText2,'');
  XMLConfig.SetDeleteValue(Path+'DiffDialog/Text2/OnlySelection',
                           FDiffText2OnlySelection,false);
end;

function TInputHistoriesWithSearchOpt.GetFindOptions(
  const ASelAvail: Boolean): TSynSearchOptions;
begin
  Result := FFindOptions[ASelAvail]*SaveOptions;
end;

procedure TInputHistoriesWithSearchOpt.LoadSearchOptions(XMLConfig: TXMLConfig; const Path: string);
var
  FindOption: TSynSearchOption;
  PathToOptions: array[Boolean] of string;
  I: Boolean;
begin
  if XMLConfig.GetValue(Path+'Find/Version/Value',0)<=0 then
    PathToOptions := PathToOptions0
  else
    PathToOptions := PathToOptions1;

  for I := Low(FFindOptions) to High(FFindOptions) do
  begin
    FFindOptions[I]:=[];
    for FindOption:=Low(FFindOptions[I]) to High(FFindOptions[I]) do
    begin
      if XMLConfig.GetValue(Path+'Find/'+PathToOptions[I]+'/'+LazFindSearchOptionNames[FindOption],
                            FindOption in LazFindSearchOptionsDefault[I])
      then
        Include(FFindOptions[I],FindOption);
    end;
  end;
end;

procedure TInputHistoriesWithSearchOpt.SaveSearchOptions(XMLConfig: TXMLConfig; const Path: string);
var
  FindOption: TSynSearchOption;
  I: Boolean;
begin
  for I := Low(FFindOptions) to High(FFindOptions) do
  begin
    XMLConfig.SetValue(Path+'Find/Version/Value', XMLConfigVersion);

    for FindOption:=Low(FFindOptions[I]) to High(FFindOptions[I]) do
    begin
      XMLConfig.SetDeleteValue(
        Path+'Find/'+PathToOptions1[I]+'/'+LazFindSearchOptionNames[FindOption],
        FindOption in FindOptions[I],
        FindOption in LazFindSearchOptionsDefault[I]);
    end;
  end;
end;

procedure TInputHistoriesWithSearchOpt.SetFindOptions(const ASelAvail: Boolean;
  const AFindOptions: TSynSearchOptions);
begin
  FFindOptions[ASelAvail] := AFindOptions*SaveOptions;
  FFindOptions[not ASelAvail] := AFindOptions*SaveOptionsGeneral // change only general options
    + FFindOptions[not ASelAvail]*SaveOptionsSelSpecific;
end;

end.

