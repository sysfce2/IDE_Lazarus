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
 *   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.        *
 *                                                                         *
 ***************************************************************************
}
unit editor_mouseaction_options;

{$mode objfpc}{$H+}

interface

uses
  LResources, EditorOptions, LazarusIDEStrConsts, IDEOptionsIntf, sysutils, Forms,
  StdCtrls, ExtCtrls, Classes, Controls, LCLProc, Grids, ComCtrls, Dialogs, ButtonPanel,
  SynEditMouseCmds, MouseActionDialog, math, KeyMapping, IDEImagesIntf;

type

  { TEditorMouseOptionsFrame }

  TEditorMouseOptionsFrame = class(TAbstractIDEOptionsEditor)
    OtherActionLabel: TLabel;
    OpenDialog1: TOpenDialog;
    OtherActionPanel: TPanel;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    OtherActionGrid: TStringGrid;
    OtherActToggleBox: TToggleBox;
    ToolBar1: TToolBar;
    BtnImport: TToolButton;
    BtnExport: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    UpdateButton: TToolButton;
    AddNewButton: TToolButton;
    DelButton: TToolButton;
    ActionGrid: TStringGrid;
    ContextTree: TTreeView;
    procedure ActionGridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
    procedure ActionGridCompareCells(Sender: TObject; ACol, ARow, BCol, BRow: Integer;
      var Result: integer);
    procedure ActionGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure ActionGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ActionGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure ActionGridSelection(Sender: TObject; aCol, aRow: Integer);
    procedure ContextTreeChange(Sender: TObject; Node: TTreeNode);
    procedure OtherActionGridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
    procedure OtherActionGridHeaderSized(Sender: TObject; IsColumn: Boolean; Index: Integer);
    procedure OtherActionGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure OtherActionGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OtherActionGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure OtherActionGridResize(Sender: TObject);
    procedure AddNewButtonClick(Sender: TObject);
    procedure OtherActionGridSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure OtherActToggleBoxChange(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure ActionGridHeaderSized(Sender: TObject; IsColumn: Boolean; Index: Integer);
    procedure ActionGridResize(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnImportClick(Sender: TObject);
  private
    FKeyMap: TKeyCommandRelationList;

    FMainNode, FSelNode: TTreeNode;
    FGutterNode: TTreeNode;
    FGutterFoldNode, FGutterFoldExpNode, FGutterFoldColNode: TTreeNode;
    FGutterLinesNode: TTreeNode;
    FCurNode: TTreeNode;

    FMainActions, FSelActions: TSynEditMouseActions;
    FGutterActions: TSynEditMouseActions;
    FGutterActionsFold, FGutterActionsFoldExp, FGutterActionsFoldCol: TSynEditMouseActions;
    FGutterActionsLines: TSynEditMouseActions;
    FCurActions: TSynEditMouseActions;

    FSort, FOtherSort: Array [1..4] of Integer;
    ChangeDlg: TMouseaActionDialog;

    FColWidths: Array of Integer;
    FLastWidth: Integer;
    FIsHeaderSizing: Boolean;

    FOtherActColWidths: Array of Integer;
    FOtherActLastWidth: Integer;
    FIsOtherActHeaderSizing: Boolean;
    FAllowOtherActSel: Boolean;
    procedure SortGrid;
    procedure SelectRow(AAct: TSynEditMouseAction);
    procedure FillRow(aGrid: TStringGrid; aRow, aFirstCol: Integer; aAct: TSynEditMouseAction);
    procedure UpdateOthers;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetTitle: String; override;
    procedure Setup(ADialog: TAbstractOptionsEditorDialog); override;
    procedure ReadSettings(AOptions: TAbstractIDEOptions); override;
    procedure WriteSettings(AOptions: TAbstractIDEOptions); override;
    class function SupportedOptionsClass: TAbstractIDEOptionsClass; override;
  end;

var
  MMoveName: Array [Boolean] of String;

implementation

const
  MinGridColSize = 25;
{ TEditorMouseOptionsFrame }

(* Sort Action Grid *)
procedure TEditorMouseOptionsFrame.ActionGridHeaderClick(Sender: TObject; IsColumn: Boolean;
  Index: Integer);
begin
  If Index <> FSort[1] then begin
    if FSort[3] <> index then
      FSort[4] := FSort[3];
    if FSort[2] <> index then
      FSort[3] := FSort[2];
    FSort[2] := FSort[1];
    FSort[1] := Index;
  end;
  SortGrid;
end;

procedure TEditorMouseOptionsFrame.ActionGridCompareCells(Sender: TObject; ACol, ARow, BCol,
  BRow: Integer; var Result: integer);
  function CompareCol(i : Integer) : Integer;
  var
    j, a, b: Integer;
  begin
    j := i;
    if Sender = OtherActionGrid then
      dec(j, 2);
    case j of
     -2: // Order
        Result := Integer(PtrInt(TStringGrid(Sender).Objects[1, ARow]))
                - Integer(PtrInt(TStringGrid(Sender).Objects[1, BRow]));
      2: // ClickCount
        Result := ord(TSynEditMouseAction(TStringGrid(Sender).Objects[0, ARow]).ClickCount)
                - ord(TSynEditMouseAction(TStringGrid(Sender).Objects[0, BRow]).ClickCount);
      3: // ClickDir (down first)
        Result := ord(TSynEditMouseAction(TStringGrid(Sender).Objects[0, BRow]).ClickDir)
                - ord(TSynEditMouseAction(TStringGrid(Sender).Objects[0, ARow]).ClickDir);
      else
        Result := AnsiCompareText(TStringGrid(Sender).Cells[i, ARow], TStringGrid(Sender).Cells[i, BRow]);
    end;
  end;
var
  i: Integer;
begin
  Result := 0;
  if Sender = nil then exit;
  if Sender = OtherActionGrid then begin
    for i := 1 to 4 do if result = 0 then
      Result := CompareCol(FOtherSort[i]);
    if Result = 0 then
      Result := CompareCol(9); // Priority
  end else begin
    for i := 1 to 4 do if result = 0 then
      Result := CompareCol(FSort[i]);
    if Result = 0 then
      Result := CompareCol(7); // Priority
  end;
  if Result = 0 then
    Result := TSynEditMouseAction(TStringGrid(Sender).Objects[0, ARow]).ID
            - TSynEditMouseAction(TStringGrid(Sender).Objects[0, BRow]).ID;
end;

procedure TEditorMouseOptionsFrame.SortGrid;
begin
  ActionGrid.SortColRow(True, 0);
end;

(* Resize Action Grid *)
procedure TEditorMouseOptionsFrame.ActionGridHeaderSized(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
var
  i: Integer;
begin
  SetLength(FColWidths, ActionGrid.ColCount);
  for i := 0 to ActionGrid.ColCount - 1 do
    FColWidths[i] := Min(Max(MinGridColSize, ActionGrid.ColWidths[i]),
                             ActionGrid.ClientWidth);
  FLastWidth := -2;
  ActionGridResize(nil);
end;

procedure TEditorMouseOptionsFrame.ActionGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FIsHeaderSizing := y <= ActionGrid.RowHeights[0];
end;

procedure TEditorMouseOptionsFrame.ActionGridMouseMove(Sender: TObject;
  Shift: TShiftState; X,
  Y: Integer);
begin
  if not FIsHeaderSizing then exit;
  ActionGridHeaderSized(nil, true, 0);
end;

procedure TEditorMouseOptionsFrame.ActionGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FIsHeaderSizing := False;
end;

procedure TEditorMouseOptionsFrame.ActionGridSelection(Sender: TObject; aCol, aRow: Integer);
begin
  UpdateOthers;
end;

procedure TEditorMouseOptionsFrame.ActionGridResize(Sender: TObject);
var
  i, Oldwidth, NewWidth: Integer;
begin
  if ActionGrid.Width = FLastWidth then Exit;
  FLastWidth := ActionGrid.Width;
  if Length(FColWidths) < ActionGrid.ColCount then exit;
  Oldwidth := 0;
  for i := 0 to ActionGrid.ColCount-1 do Oldwidth := Oldwidth + FColWidths[i];
  NewWidth := ActionGrid.ClientWidth - 1;
  for i := 0 to ActionGrid.ColCount-1 do
    NewWidth := NewWidth - (MinGridColSize -
              Min(MinGridColSize, FColWidths[i] * NewWidth div Oldwidth));
  for i := 0 to ActionGrid.ColCount-1 do
    ActionGrid.ColWidths[i] := Max(MinGridColSize, FColWidths[i] * NewWidth div Oldwidth);
end;

(* Resize OtherAction Grid *)
procedure TEditorMouseOptionsFrame.OtherActionGridHeaderSized(Sender: TObject; IsColumn: Boolean;
  Index: Integer);
var
  i: Integer;
begin
  SetLength(FOtherActColWidths, OtherActionGrid.ColCount);
  for i := 0 to OtherActionGrid.ColCount - 1 do
    FOtherActColWidths[i] := Min(Max(MinGridColSize, OtherActionGrid.ColWidths[i]),
                             OtherActionGrid.ClientWidth);
  FOtherActLastWidth := -2;
  OtherActionGridResize(nil);
end;

procedure TEditorMouseOptionsFrame.OtherActionGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FIsOtherActHeaderSizing := y <= OtherActionGrid.RowHeights[0];
end;

procedure TEditorMouseOptionsFrame.OtherActionGridMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if not FIsOtherActHeaderSizing then exit;
  OtherActionGridHeaderSized(nil, true, 0);
end;

procedure TEditorMouseOptionsFrame.OtherActionGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FIsOtherActHeaderSizing := False;
end;

procedure TEditorMouseOptionsFrame.OtherActionGridResize(Sender: TObject);
var
  i, Oldwidth, NewWidth: Integer;
begin
  if OtherActionGrid.Width = FOtherActLastWidth then Exit;
  FOtherActLastWidth := OtherActionGrid.Width;
  if Length(FOtherActColWidths) < OtherActionGrid.ColCount then exit;
  Oldwidth := 0;
  for i := 0 to OtherActionGrid.ColCount-1 do Oldwidth := Oldwidth + FOtherActColWidths[i];
  NewWidth := OtherActionGrid.ClientWidth - 1;
  for i := 0 to OtherActionGrid.ColCount-1 do
    NewWidth := NewWidth - (MinGridColSize -
              Min(MinGridColSize, FOtherActColWidths[i] * NewWidth div Oldwidth));
  for i := 0 to OtherActionGrid.ColCount-1 do
    OtherActionGrid.ColWidths[i] := Max(MinGridColSize, FOtherActColWidths[i] * NewWidth div Oldwidth);
end;

(* Selection *)
procedure TEditorMouseOptionsFrame.FillRow(aGrid: TStringGrid; aRow, aFirstCol: Integer;
  aAct: TSynEditMouseAction);

  function ShiftName(ss: TShiftStateEnum): String;
  begin
    if not(ss in aAct.ShiftMask) then exit(dlgMouseOptModKeyIgnore);
    if ss in aAct.Shift then exit(dlgMouseOptModKeyTrue);
    exit(dlgMouseOptModKeyFalse);
  end;

var
  j: Integer;
  optlist: TStringList;
begin
  aGrid.Objects[0, aRow] := aAct;
  aGrid.Cells[aFirstCol + 0, aRow] := aAct.DisplayName;
  aGrid.Cells[aFirstCol + 1, aRow] := ButtonName[aAct.Button];
  aGrid.Cells[aFirstCol + 2, aRow] := ClickName[aAct.ClickCount];
  aGrid.Cells[aFirstCol + 3, aRow] := ButtonDirName[aAct.ClickDir];;
  aGrid.Cells[aFirstCol + 4, aRow] := ShiftName(ssShift);
  aGrid.Cells[aFirstCol + 5, aRow] := ShiftName(ssAlt);
  aGrid.Cells[aFirstCol + 6, aRow] := ShiftName(ssCtrl);
  aGrid.Cells[aFirstCol + 7, aRow] := IntToStr(aAct.Priority);
  aGrid.Cells[aFirstCol + 8, aRow] := MMoveName[aAct.MoveCaret];
  aGrid.Cells[aFirstCol + 9, aRow] := '';
  if aAct.Command =  emcSynEditCommand then begin
    j := KeyMapIndexOfCommand(FKeyMap, AAct.Option);
    if (j >= 0) and (j < FKeyMap.RelationCount) then
      aGrid.Cells[aFirstCol + 9, aRow] := FKeyMap.Relations[j].GetLocalizedName;
  end
  else begin
    optlist := TStringlist.Create;
    optlist.CommaText := MouseCommandConfigName(aAct.Command);
    if aAct.Option < optlist.Count-1 then
      aGrid.Cells[aFirstCol + 9, aRow] := optlist[aAct.Option+1] +' ('+optlist[0]+')';
    optlist.Free;
  end;
end;

procedure TEditorMouseOptionsFrame.ContextTreeChange(Sender: TObject; Node: TTreeNode);
var
  i: Integer;
begin
  if Node = nil then exit;
  FCurNode := Node;
  FCurActions := TSynEditMouseActions(Node.Data);
  ActionGrid.RowCount := FCurActions.Count + 1;
  for i := 1 to FCurActions.Count do
    FillRow(ActionGrid, i, 0, FCurActions[i-1]);
  ActionGrid.Row := 1;
  SortGrid;
  UpdateOthers;
end;

procedure TEditorMouseOptionsFrame.OtherActionGridHeaderClick(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
begin
  If Index <> FOtherSort[1] then begin
    if FOtherSort[3] <> index then
      FOtherSort[4] := FOtherSort[3];
    if FOtherSort[2] <> index then
      FOtherSort[3] := FOtherSort[2];
    FOtherSort[2] := FOtherSort[1];
    FOtherSort[1] := Index;
  end;
  OtherActionGrid.SortColRow(True, 0);
end;

procedure TEditorMouseOptionsFrame.SelectRow(AAct: TSynEditMouseAction);
var
  i: Integer;
begin
  For i := 1 to ActionGrid.RowCount -1 do
    if ActionGrid.Objects[0, i] = AAct then begin
      ActionGrid.Row := i;
      break;
    end;
end;

procedure TEditorMouseOptionsFrame.UpdateOthers;
const
  DirList: Array [0..1] of TSynMAClickDir = (cdDown, cdUp);
  FallBackList: Array [0..1] of Boolean = (False, True);
var
  MAct: TSynEditMouseAction;
  ActList: TSynEditMouseActions;
  Node: TTreeNode;
  i, Row: Integer;
  Order, FoundOrder: Integer;
  FindDir, FindFallBack, FindPrior: Integer;
begin
  OtherActionGrid.RowCount := 1;
  if FCurActions = nil then exit;
  if (ActionGrid.Row-1 >= FCurActions.Count) or (ActionGrid.Row < 1) then exit;
  MAct := TSynEditMouseAction(ActionGrid.Objects[0, ActionGrid.Row]);
  if MAct = nil then exit;

  Row := 1;
  Order := 1;
  FoundOrder := 0;
  // Search up/Down
  for FindDir := low(DirList) to high(DirList) do begin
    // search context
    ActList := FCurActions;
    Node := ContextTree.Items.FindNodeWithData(FCurActions);
    while (ActList <> nil) and (Node <> nil) do begin
      // Search Mod-Key/Default
      for FindPrior := 0 to 3 do begin
        for FindFallBack := low(FallBackList) to high(FallBackList) do begin
          for i := 0 to ActList.Count - 1 do
            if (ActList[i].Button = MAct.Button) and
               (ActList[i].ClickDir = DirList[FindDir]) and
               (ActList[i].IsFallback = FallBackList[FindFallBack]) and
               (ActList[i].Priority = FindPrior) and
               ( (not OtherActToggleBox.Checked) or
                 (ActList[i].Shift * ActList[i].ShiftMask * MAct.ShiftMask =
                  MAct.Shift * ActList[i].ShiftMask * MAct.ShiftMask)  )
            then begin
              OtherActionGrid.RowCount := Row + 1;
              FillRow(OtherActionGrid, Row, 2, ActList[i]);
              OtherActionGrid.Cells[1,Row] := Node.Text;
              OtherActionGrid.Cells[0,Row] := IntToStr(Order);
              OtherActionGrid.Objects[1,Row] := TObject(Pointer(PtrInt(Order)));
              FoundOrder := Order;
              FAllowOtherActSel := True;
              if ActList[i].Equals(MAct) and (ActList = FCurActions) then
                OtherActionGrid.Row := Row;
              FAllowOtherActSel := False;
              inc(Row);
            end;
          if Order = FoundOrder then
            inc(Order);
        end; // FindFallBack
        if Order = FoundOrder then
          inc(Order);
      end; // FindPrior
      if Order = FoundOrder then
        inc(Order);
      Node := Node.Parent;
      if (Node <> nil) then
        ActList := TSynEditMouseActions(Node.Data);
    end; // Context
    if Order = FoundOrder then
      inc(Order);
  end; // FindDir
  OtherActionGrid.SortColRow(True, 0);
end;

(* ----- *)
procedure TEditorMouseOptionsFrame.AddNewButtonClick(Sender: TObject);
var
  MAct: TSynEditMouseAction;
begin
  if FCurActions = nil then exit;

  ChangeDlg.KeyMap := FKeyMap;
  ChangeDlg.ResetInputs;
  if ChangeDlg.ShowModal = mrOK then begin
    try
      FCurActions.IncAssertLock;
      MAct := FCurActions.Add;
      ChangeDlg.WriteToAction(MAct);
    finally
      FCurActions.DecAssertLock;
    end;
    try
      FCurActions.AssertNoConflict(MAct);
    except
      FCurActions.Delete(FCurActions.Count - 1);
      MessageDlg(dlgMouseOptErrorDup, dlgMouseOptErrorDupText, mtError, [mbOk], 0);
    end;
    ContextTreeChange(nil, FCurNode);
    SelectRow(MAct);
  end;
end;

procedure TEditorMouseOptionsFrame.OtherActionGridSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  CanSelect := FAllowOtherActSel;
end;

procedure TEditorMouseOptionsFrame.OtherActToggleBoxChange(Sender: TObject);
begin
  UpdateOthers;
end;

procedure TEditorMouseOptionsFrame.UpdateButtonClick(Sender: TObject);
var
  MAct, MOld: TSynEditMouseAction;
begin
  if FCurActions = nil then exit;
  if (ActionGrid.Row-1 >= FCurActions.Count) or (ActionGrid.Row < 1) then exit;

  MAct := TSynEditMouseAction(ActionGrid.Objects[0, ActionGrid.Row]);
  ChangeDlg.KeyMap := FKeyMap;
  ChangeDlg.ReadFromAction(MAct);
  if ChangeDlg.ShowModal = mrOK then begin
    try
      FCurActions.IncAssertLock;
      MOld := TSynEditMouseAction.Create(nil);
      MOld.Assign(MAct);
      ChangeDlg.WriteToAction(MAct);
    finally
      FCurActions.DecAssertLock;
    end;
    try
      FCurActions.AssertNoConflict(MAct);
    except
      MessageDlg(dlgMouseOptErrorDup, dlgMouseOptErrorDupText, mtError, [mbOk], 0);
      MAct.Assign(MOld);
    end;
    MOld.Free;
    ContextTreeChange(nil, FCurNode);
    SelectRow(MAct);
  end;
end;

procedure TEditorMouseOptionsFrame.DelButtonClick(Sender: TObject);
begin
  if FCurActions = nil then exit;
  if (ActionGrid.Row-1 >= FCurActions.Count) or (ActionGrid.Row < 1) then exit;
  FCurActions.Delete(FCurActions.IndexOf(TSynEditMouseAction
                                      (ActionGrid.Objects[0, ActionGrid.row])));
  ActionGrid.Row := 1;
  ContextTreeChange(nil, FCurNode);
end;

procedure TEditorMouseOptionsFrame.BtnExportClick(Sender: TObject);
var
  xml: TRttiXMLConfig;

  Procedure SaveMouseAct(Path: String; MActions: TSynEditMouseActions);
  var
    i: Integer;
  begin
    for i := 0 to MActions.Count - 1 do
      xml.WriteObject(Path + 'M' + IntToStr(i) + '/', MActions[i]);
    xml.SetValue(Path + 'Count', MActions.Count);
  end;

begin
  if SaveDialog1.Execute then begin
    xml := TRttiXMLConfig.CreateClean(SaveDialog1.FileName);
    SaveMouseAct('Mouse/Main/', FMainActions);
    SaveMouseAct('Mouse/MainSel/', FSelActions);
    SaveMouseAct('Mouse/Gutter/', FGutterActions);
    SaveMouseAct('Mouse/GutterFold/', FGutterActionsFold);
    SaveMouseAct('Mouse/GutterFoldExp/', FGutterActionsFoldExp);
    SaveMouseAct('Mouse/GutterFoldCol/', FGutterActionsFoldCol);
    SaveMouseAct('Mouse/GutterLineNum/', FGutterActionsLines);
    xml.Flush;
    xml.Free;
  end;
end;

procedure TEditorMouseOptionsFrame.BtnImportClick(Sender: TObject);
var
  xml: TRttiXMLConfig;

  Procedure LoadMouseAct(Path: String; MActions: TSynEditMouseActions);
  var
    i, c: Integer;
    MAct: TSynEditMouseAction;
  begin
    MActions.Clear;
    c := xml.GetValue(Path + 'Count', 0);
    for i := 0 to c - 1 do begin
      try
        MActions.IncAssertLock;
        try
          MAct := MActions.Add;
          xml.ReadObject(Path + 'M' + IntToStr(i) + '/', MAct);
        finally
          MActions.DecAssertLock;
        end;
        MActions.AssertNoConflict(MAct);
      except
        MActions.Delete(MActions.Count-1);
        MessageDlg(dlgMouseOptErrorDup, dlgMouseOptErrorDupText + LineEnding
                   + Path + 'M' + IntToStr(i) + LineEnding + MAct.DisplayName,
                   mtError, [mbOk], 0);
      end;
    end;
  end;

begin
  if OpenDialog1.Execute then begin
    xml := TRttiXMLConfig.Create(OpenDialog1.FileName);
    LoadMouseAct('Mouse/Main/', FMainActions);
    LoadMouseAct('Mouse/MainSel/', FSelActions);
    LoadMouseAct('Mouse/Gutter/', FGutterActions);
    LoadMouseAct('Mouse/GutterFold/', FGutterActionsFold);
    LoadMouseAct('Mouse/GutterFoldExp/', FGutterActionsFoldExp);
    LoadMouseAct('Mouse/GutterFoldCol/', FGutterActionsFoldCol);
    LoadMouseAct('Mouse/GutterLineNum/', FGutterActionsLines);
    xml.Free;

    ContextTree.Selected := FMainNode;
    ContextTreeChange(nil, FMainNode);
  end;
end;

constructor TEditorMouseOptionsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMainActions := TSynEditMouseActions.Create(nil);
  FSelActions := TSynEditMouseActions.Create(nil);
  FGutterActions := TSynEditMouseActions.Create(nil);
  FGutterActionsFold := TSynEditMouseActions.Create(nil);
  FGutterActionsFoldExp := TSynEditMouseActions.Create(nil);
  FGutterActionsFoldCol := TSynEditMouseActions.Create(nil);
  FGutterActionsLines := TSynEditMouseActions.Create(nil);
  ChangeDlg := TMouseaActionDialog.Create(self);
end;

destructor TEditorMouseOptionsFrame.Destroy;
begin
  FMainActions.Free;
  FSelActions.Free;
  FGutterActions.Free;
  FGutterActionsFold.Free;
  FGutterActionsFoldExp.Free;
  FGutterActionsFoldCol.Free;
  FGutterActionsLines.Free;
  ChangeDlg.Free;
  inherited Destroy;
end;

function TEditorMouseOptionsFrame.GetTitle: String;
begin
  Result := dlgMouseOptions;
end;

procedure TEditorMouseOptionsFrame.Setup(ADialog: TAbstractOptionsEditorDialog);
begin
  ContextTree.Items.Clear;
  FMainNode := ContextTree.Items.Add(nil, dlgMouseOptNodeMain);
  FMainNode.Data := FMainActions;
  // Selection
  FSelNode := ContextTree.Items.AddChild(FMainNode, dlgMouseOptNodeSelect);
  FSelNode.Data := FSelActions;
  // Gutter
  FGutterNode := ContextTree.Items.AddChild(nil, dlgMouseOptNodeGutter);
  FGutterNode.Data := FGutterActions;
  // Gutter Fold
  FGutterFoldNode := ContextTree.Items.AddChild(FGutterNode, dlgMouseOptNodeGutterFold);
  FGutterFoldNode.Data := FGutterActionsFold;
  FGutterFoldColNode := ContextTree.Items.AddChild(FGutterFoldNode, dlgMouseOptNodeGutterFoldCol);
  FGutterFoldColNode.Data := FGutterActionsFoldCol;
  FGutterFoldExpNode := ContextTree.Items.AddChild(FGutterFoldNode, dlgMouseOptNodeGutterFoldExp);
  FGutterFoldExpNode.Data := FGutterActionsFoldExp;
  // LineNum
  FGutterLinesNode := ContextTree.Items.AddChild(FGutterNode, dlgMouseOptNodeGutterLines);
  FGutterLinesNode.Data := FGutterActionsLines;

  ActionGrid.Constraints.MinWidth := ActionGrid.ColCount * MinGridColSize;
  ActionGrid.Cells[0,0] := dlgMouseOptHeadDesc;
  ActionGrid.Cells[1,0] := dlgMouseOptHeadBtn;
  ActionGrid.Cells[2,0] := dlgMouseOptHeadCount;
  ActionGrid.Cells[3,0] := dlgMouseOptHeadDir;
  ActionGrid.Cells[4,0] := dlgMouseOptHeadShift;
  ActionGrid.Cells[5,0] := dlgMouseOptHeadAlt;
  ActionGrid.Cells[6,0] := dlgMouseOptHeadCtrl;
  ActionGrid.Cells[7,0] := dlgMouseOptHeadPriority;
  ActionGrid.Cells[8,0] := dlgMouseOptHeadCaret;
  ActionGrid.Cells[9,0] := dlgMouseOptHeadOpt;
  ActionGrid.ColWidths[0] := ActionGrid.ColWidths[0] * 3;
  ActionGrid.ColWidths[9] := ActionGrid.ColWidths[8] * 3;
  ActionGridHeaderSized(nil, true, 0);

  OtherActionGrid.Constraints.MinWidth := OtherActionGrid.ColCount * MinGridColSize;
  OtherActionGrid.Cells[0,0] := dlgMouseOptHeadOrder;
  OtherActionGrid.Cells[1,0] := dlgMouseOptHeadContext;
  OtherActionGrid.Cells[2,0] := dlgMouseOptHeadDesc;
  OtherActionGrid.Cells[3,0] := dlgMouseOptHeadBtn;
  OtherActionGrid.Cells[4,0] := dlgMouseOptHeadCount;
  OtherActionGrid.Cells[5,0] := dlgMouseOptHeadDir;
  OtherActionGrid.Cells[6,0] := dlgMouseOptHeadShift;
  OtherActionGrid.Cells[7,0] := dlgMouseOptHeadAlt;
  OtherActionGrid.Cells[8,0] := dlgMouseOptHeadCtrl;
  OtherActionGrid.Cells[9,0] := dlgMouseOptHeadPriority;
  OtherActionGrid.Cells[10,0] := dlgMouseOptHeadCaret;
  OtherActionGrid.Cells[11,0] := dlgMouseOptHeadOpt;
  OtherActionGrid.ColWidths[1] := OtherActionGrid.ColWidths[0] * 2;
  OtherActionGrid.ColWidths[2] := OtherActionGrid.ColWidths[1] * 3;
  OtherActionGrid.ColWidths[11] := OtherActionGrid.ColWidths[9] * 3;
  OtherActionGridHeaderSized(nil, true, 0);

  MMoveName[false] := dlgMouseOptMoveMouseFalse;
  MMoveName[true] := dlgMouseOptMoveMouseTrue;

  FSort[1] := 1; // Button
  FSort[2] := 2; // CCount
  FSort[3] := 3; // Cdir
  FSort[4] := 8; // Priority

  FOtherSort[1] := 0; // SearchOrder
  FOtherSort[2] := 1; // Context
  FOtherSort[3] := 4; // CCount
  FOtherSort[4] := 5; // CDir

  BtnImport.Caption := dlgMouseOptBtnImport;
  BtnExport.Caption := dlgMouseOptBtnExport;
  UpdateButton.Caption := dlgMouseOptBtnUdp;
  AddNewButton.Caption := dlgMouseOptBtnAdd;
  DelButton.Caption := dlgMouseOptBtnDel;
  OtherActionLabel.Caption := dlgMouseOptOtherAct;
  OtherActionLabel.Hint := dlgMouseOptOtherActHint;
  OtherActToggleBox.Caption := dlgMouseOptOtherActToggle;

  ToolBar1.Images := IDEImages.Images_16;
  BtnImport.ImageIndex := IDEImages.LoadImage(16, 'laz_open');
  BtnExport.ImageIndex := IDEImages.LoadImage(16, 'laz_save');
  UpdateButton.ImageIndex := IDEImages.LoadImage(16, 'laz_edit');
  AddNewButton.ImageIndex := IDEImages.LoadImage(16, 'laz_add');
  DelButton.ImageIndex := IDEImages.LoadImage(16, 'laz_delete');

  OpenDialog1.Title := dlgMouseOptBtnImport;
  SaveDialog1.Title := dlgMouseOptBtnExport;
end;

procedure TEditorMouseOptionsFrame.ReadSettings(
  AOptions: TAbstractIDEOptions);
begin
  with AOptions as TEditorOptions do
  begin
    FMainActions.Assign(MouseMap);
    FSelActions.Assign(MouseSelMap);
    FGutterActions.Assign(MouseGutterActions);
    FGutterActionsFold.Assign(MouseGutterActionsFold);
    FGutterActionsFoldExp.Assign(MouseGutterActionsFoldExp);
    FGutterActionsFoldCol.Assign(MouseGutterActionsFoldCol);
    FGutterActionsLines.Assign(MouseGutterActionsLines);

    FKeyMap := KeyMap;
  end;
  ContextTree.Selected := FMainNode;
end;

procedure TEditorMouseOptionsFrame.WriteSettings(
  AOptions: TAbstractIDEOptions);
begin
  with AOptions as TEditorOptions do
  begin
    MouseMap.Assign(FMainActions);
    MouseSelMap.Assign(FSelActions);
    MouseGutterActions.Assign(FGutterActions);
    MouseGutterActionsFold.Assign(FGutterActionsFold);
    MouseGutterActionsFoldExp.Assign(FGutterActionsFoldExp);
    MouseGutterActionsFoldCol.Assign(FGutterActionsFoldCol);
    MouseGutterActionsLines.Assign(FGutterActionsLines);
  end;
end;

class function TEditorMouseOptionsFrame.SupportedOptionsClass: TAbstractIDEOptionsClass;
begin
  Result := TEditorOptions;
end;

initialization
  {$I editor_mouseaction_options.lrs}
  RegisterIDEOptionsEditor(GroupEditor, TEditorMouseOptionsFrame, EdtOptionsMouse);
end.

