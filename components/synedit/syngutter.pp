unit SynGutter;

{$I synedit.inc}

interface

uses
  SysUtils, Classes, Controls, Graphics, LCLType, LCLIntf, Menus, SynEditMarks, SynEditTypes,
  SynEditMiscClasses, SynEditMiscProcs, LazSynTextArea, SynGutterBase,
  SynGutterLineNumber, SynGutterCodeFolding, SynGutterMarks, SynGutterChanges, SynEditMouseCmds,
  SynGutterLineOverview, LazEditTextGridPainter, LazEditTextAttributes;

type

  TSynGutterSeparator = class;
  TLazSynGutterArea = class;

  { TSynGutter }

  TSynGutter = class(TSynGutterBase)
  private
    FCursor: TCursor;
    FOnGutterClick: TGutterClickEvent;
    FMouseDownPart: Integer;
    function PixelToPartIndex(X: Integer): Integer;
  protected
    procedure DoDefaultGutterClick(Sender: TObject; X, Y, Line: integer;
      mark: TSynEditMark); override;
    function CreatePartList: TSynGutterPartListBase; override;
    procedure CreateDefaultGutterParts; virtual;
    function CreateMouseActions: TSynEditMouseInternalActions; override;
    property GutterArea;
  public
    constructor Create(AOwner : TSynEditBase; ASide: TSynGutterSide;
                      ATextDrawer: TLazEditTextGridPainter);
    destructor Destroy; override;
    procedure Paint(Canvas: TCanvas; Surface:TLazSynGutterArea; AClip: TRect; FirstLine, LastLine: integer);
    function  HasCustomPopupMenu(out PopMenu: TPopupMenu): Boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    function  MaybeHandleMouseAction(var AnInfo: TSynEditMouseActionInfo;
                         HandleActionProc: TSynEditMouseActionHandler): Boolean; override;
    function DoHandleMouseAction(AnAction: TSynEditMouseAction;
                                 var AnInfo: TSynEditMouseActionInfo): Boolean;
    procedure ResetMouseActions; override; // set mouse-actions according to current Options / may clear them
    procedure DoOnGutterClick(X, Y: integer);
    property  OnGutterClick: TGutterClickEvent
      read FOnGutterClick write FOnGutterClick;
  public
    // Access to well known parts
    Function LineNumberPart(Index: Integer = 0): TSynGutterLineNumber;
    Function CodeFoldPart(Index: Integer = 0): TSynGutterCodeFolding;
    Function ChangesPart(Index: Integer = 0): TSynGutterChanges;
    Function MarksPart(Index: Integer = 0): TSynGutterMarks;
    Function SeparatorPart(Index: Integer = 0): TSynGutterSeparator;
    Function LineOverviewPart(Index: Integer = 0): TSynGutterLineOverview;
  published
    property AutoSize;
    property Color;
    property CurrentLineColor;
    property Cursor: TCursor read FCursor write FCursor default crDefault;
    property LeftOffset;
    property RightOffset;
    property Visible;
    property Width;
    property Parts;
    property MouseActions;
    property OnResize;
    property OnChange;
  end;

  { TSynGutterSeparator }

  TSynGutterSeparator = class(TSynGutterPartBase)
  private
    FLineOffset: Integer;
    FLineOnRight: Boolean;
    FLineWidth: Integer;
    procedure SetLineOffset(const AValue: Integer);
    procedure SetLineOnRight(const AValue: Boolean);
    procedure SetLineWidth(const AValue: Integer);
  protected
    function  PreferedWidth: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint(Canvas: TCanvas; AClip: TRect; FirstLine, LastLine: integer); override;
  published
    property LineWidth: Integer read FLineWidth write SetLineWidth default 1;
    property LineOffset: Integer read FLineOffset write SetLineOffset default 0;
    property LineOnRight: Boolean read FLineOnRight write SetLineOnRight default True;
    property MarkupInfo;
    property MarkupInfoCurrentLine;
  end;

  { TSynEditMouseActionsGutter }

  TSynEditMouseActionsGutter = class(TSynEditMouseInternalActions)
  protected
    procedure InitForOptions(AnOptions: TSynEditorMouseOptions); override;
  end;

  { TLazSynGutterArea }

  TLazSynGutterArea = class(TLazSynSurfaceWithText)
  private
    FGutter: TSynGutter;
    function GetTextBounds: TRect;
    procedure SetGutter(AValue: TSynGutter);
  protected
    procedure DoPaint(ACanvas: TCanvas; AClip: TRect); override;
  public
    procedure InvalidateLines(FirstTextLine, LastTextLine: TLineIdx; AScreenLineOffset: Integer = 0); override;
    procedure Assign(Src: TLazSynSurface); override;
    property Gutter: TSynGutter read FGutter write SetGutter;
    property TextBounds: TRect read GetTextBounds;
  end;

implementation

{ TLazSynGutterArea }

function TLazSynGutterArea.GetTextBounds: TRect;
begin
  Result := TextArea.TextBounds;
end;

procedure TLazSynGutterArea.SetGutter(AValue: TSynGutter);
begin
  if FGutter = AValue then Exit;
  if FGutter <> nil then
    FGutter.GutterArea := nil;
  FGutter := AValue;
  if FGutter <> nil then
    FGutter.GutterArea := Self;
end;

procedure TLazSynGutterArea.DoPaint(ACanvas: TCanvas; AClip: TRect);
var
  ScreenRow1, ScreenRow2: integer;
begin
  // TODO TextArea top/bottom padding;
  ScreenRow1 := Max((AClip.Top - Bounds.Top) div TextArea.LineHeight, 0);
  ScreenRow2 := Min((AClip.Bottom-1 - Bounds.Top) div TextArea.LineHeight, TextArea.LinesInWindow + 1);

  FGutter.Paint(ACanvas, Self, AClip, ScreenRow1, ScreenRow2);
end;

procedure TLazSynGutterArea.InvalidateLines(FirstTextLine,
  LastTextLine: TLineIdx; AScreenLineOffset: Integer);
var
  rcInval: TRect;
begin
  rcInval := Bounds;
  if (FirstTextLine >= 0) then
    rcInval.Top := Max(TextArea.TextBounds.Top,
                       TextArea.TextBounds.Top
                       + (DisplayView.TextToViewIndex(FirstTextLine).Top + AScreenLineOffset
                          - TextArea.TopViewedLine + 1) * TextArea.LineHeight);
  if (LastTextLine >= 0) then
    rcInval.Bottom := Min(TextArea.TextBounds.Bottom,
                          TextArea.TextBounds.Top
                          + (DisplayView.TextToViewIndex(LastTextLine).Bottom + AScreenLineOffset
                             - TextArea.TopViewedLine + 2)  * TextArea.LineHeight);

  {$IFDEF VerboseSynEditInvalidate}
  DebugLn(['TCustomSynEdit.InvalidateGutterLines ',DbgSName(self), ' FirstLine=',FirstTextLine, ' LastLine=',LastTextLine, ' rect=',dbgs(rcInval)]);
  {$ENDIF}
  if (rcInval.Top < rcInval.Bottom) and (rcInval.Left < rcInval.Right) then
    InvalidateRect(Handle, @rcInval, FALSE);
end;

procedure TLazSynGutterArea.Assign(Src: TLazSynSurface);
begin
  inherited Assign(Src);
  FGutter := TLazSynGutterArea(Src).FGutter;
end;

{ TSynGutter }

constructor TSynGutter.Create(AOwner: TSynEditBase; ASide: TSynGutterSide;
  ATextDrawer: TLazEditTextGridPainter);
begin
  inherited;
  if not(csLoading in AOwner.ComponentState) then
    CreateDefaultGutterParts;
end;

destructor TSynGutter.Destroy;
begin
  OnChange := nil;
  OnResize := nil;
  inherited Destroy;
end;

procedure TSynGutter.CreateDefaultGutterParts;
begin
  if Side <> gsLeft then
    exit;

  // Todo: currently there is only one Gutter so names can be fixed
  with TSynGutterMarks.Create(Parts) do
    Name := 'SynGutterMarks1';
  with TSynGutterLineNumber.Create(Parts) do
    Name := 'SynGutterLineNumber1';
  with TSynGutterChanges.Create(Parts) do
    Name := 'SynGutterChanges1';
  with TSynGutterSeparator.Create(Parts) do
    Name := 'SynGutterSeparator1';
  with TSynGutterCodeFolding.Create(Parts) do
    Name := 'SynGutterCodeFolding1';
end;

function TSynGutter.CreateMouseActions: TSynEditMouseInternalActions;
begin
  Result := TSynEditMouseActionsGutter.Create(self);
end;

function TSynGutter.PixelToPartIndex(X: Integer): Integer;
begin
  Result := 0;
  x := x - Left - LeftOffset;
  while Result < PartCount-1 do begin
    if Parts[Result].Visible then begin
      if x >= Parts[Result].FullWidth then
        x := x - Parts[Result].FullWidth
      else
        break;
    end;
    inc(Result)
  end;
end;

procedure TSynGutter.DoDefaultGutterClick(Sender: TObject; X, Y, Line: integer;
  mark: TSynEditMark);
begin
end;

function TSynGutter.CreatePartList: TSynGutterPartListBase;
begin
  case Side of
    gsLeft:
      begin
        Result := TSynGutterPartList.Create(SynEdit, self); //left side gutter
        Result.Name := 'SynLeftGutterPartList1';
      end;
    gsRight:
      begin
        Result := TSynRightGutterPartList.Create(SynEdit, self);
        Result.Name := 'SynRightGutterPartList1';
      end;
  end;
end;

procedure TSynGutter.DoOnGutterClick(X, Y: integer);
begin
  Parts[PixelToPartIndex(X)].DoOnGutterClick(X, Y);
end;

procedure TSynGutter.Paint(Canvas: TCanvas; Surface:TLazSynGutterArea; AClip: TRect; FirstLine, LastLine: integer);
var
  aCaretRow: LongInt;
  i, t: integer;
  rcLine, rcClip: TRect;
  dc: HDC;
begin
  aCaretRow := ToIdx(SynEdit.TextXYToScreenXY(SynEdit.CaretXY).Y);
  if (aCaretRow < FirstLine) or (aCaretRow > LastLine) then
    aCaretRow := -1;
  FCaretRow := aCaretRow;

  Canvas.Brush.Color := Color;
  dc := Canvas.Handle;
  LCLIntf.SetBkColor(dc, TColorRef(Canvas.Brush.Color));

  rcClip := AClip;
  t := Surface.TextBounds.Top;
  // Clear all
  TextDrawer.BeginCustomCanvas(Canvas);
  TextDrawer.BackColor := Color;
  TextDrawer.ForeColor := SynEdit.Font.Color;
  TextDrawer.SetFrame(clNone, slsSolid);
  if aCaretRow >= 0 then
    rcClip.Bottom := t + aCaretRow * SynEdit.LineHeight;
   with rcClip do
     TextDrawer.ExtTextOut(Left, Top, ETO_OPAQUE, rcClip, nil, 0);
  if aCaretRow >= 0 then begin
    rcClip.top := rcClip.Bottom + SynEdit.LineHeight;
    rcClip.Bottom := AClip.Bottom;
     with rcClip do
       TextDrawer.ExtTextOut(Left, Top, ETO_OPAQUE, rcClip, nil, 0);

    rcClip.Bottom := rcClip.Top;
    rcClip.top := rcClip.Top - SynEdit.LineHeight;
    TextDrawer.BackColor := MarkupInfoCurLineMerged.Background;
     with rcClip do
       TextDrawer.ExtTextOut(Left, Top, ETO_OPAQUE, rcClip, nil, 0);
  end;
  TextDrawer.EndCustomCanvas;

  AClip.Left := Surface.Left + LeftOffset;
  AClip.Top  := t + FirstLine * SynEdit.LineHeight;

  rcLine := AClip;
  rcLine.Right := rcLine.Left;
  for i := 0 to PartCount -1 do
  begin
    if rcLine.Right >= AClip.Right then break;
    if Parts[i].Visible then
    begin
      rcLine.Left := rcLine.Right;
      rcLine.Right := min(rcLine.Left + Parts[i].FullWidth, AClip.Right);
      Parts[i].PaintAll(Canvas, rcLine, FirstLine, LastLine);
    end;
  end;
end;

function TSynGutter.HasCustomPopupMenu(out PopMenu: TPopupMenu): Boolean;
begin
  Result := Parts[FMouseDownPart].HasCustomPopupMenu(PopMenu);
end;

procedure TSynGutter.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMouseDownPart := PixelToPartIndex(X);
  Parts[FMouseDownPart].MouseDown(Button, Shift, X, Y);
  if (Button=Controls.mbLeft) then
    DoOnGutterClick(X, Y);
end;

procedure TSynGutter.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  Parts[FMouseDownPart].MouseMove(Shift, X, Y);
end;

procedure TSynGutter.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Parts[FMouseDownPart].MouseUp(Button, Shift, X, Y);
end;

function TSynGutter.MaybeHandleMouseAction(var AnInfo: TSynEditMouseActionInfo;
  HandleActionProc: TSynEditMouseActionHandler): Boolean;
var
  MouseDownPart: LongInt;
begin
  MouseDownPart := PixelToPartIndex(AnInfo.MouseX);
  if MouseDownPart < PartCount then
    Result := Parts[MouseDownPart].MaybeHandleMouseAction(AnInfo, HandleActionProc)
  else
    Result := False;
  if not Result then
    Result := inherited MaybeHandleMouseAction(AnInfo, HandleActionProc);
end;

function TSynGutter.DoHandleMouseAction(AnAction: TSynEditMouseAction;
  var AnInfo: TSynEditMouseActionInfo): Boolean;
var
  i: Integer;
  ACommand: Word;
begin
  Result := False;
  for i := 0 to Parts.Count - 1 do begin
    Result := Parts[i].DoHandleMouseAction(AnAction, AnInfo);
    if Result then exit;;
  end;

  if AnAction = nil then exit;
  ACommand := AnAction.Command;
  if (ACommand = emcNone) then exit;

  case ACommand of
    emcOnMainGutterClick:
      begin
        if Assigned(FOnGutterClick) then begin
          FOnGutterClick(Self, AnInfo.MouseX, AnInfo.MouseY, AnInfo.NewCaret.LinePos, nil);
          Result := True;
        end;
      end;
  end;
end;

procedure TSynGutter.ResetMouseActions;
var
  i: integer;
begin
  for i := 0 to Parts.Count - 1 do
    Parts[i].ResetMouseActions;

  inherited;
end;

function TSynGutter.LineNumberPart(Index: Integer = 0): TSynGutterLineNumber;
begin
  Result := TSynGutterLineNumber(Parts.ByClass[TSynGutterLineNumber, Index]);
end;

function TSynGutter.CodeFoldPart(Index: Integer = 0): TSynGutterCodeFolding;
begin
  Result := TSynGutterCodeFolding(Parts.ByClass[TSynGutterCodeFolding, Index]);
end;

function TSynGutter.ChangesPart(Index: Integer = 0): TSynGutterChanges;
begin
  Result := TSynGutterChanges(Parts.ByClass[TSynGutterChanges, Index]);
end;

function TSynGutter.MarksPart(Index: Integer = 0): TSynGutterMarks;
begin
  Result := TSynGutterMarks(Parts.ByClass[TSynGutterMarks, Index]);
end;

function TSynGutter.SeparatorPart(Index: Integer = 0): TSynGutterSeparator;
begin
  Result := TSynGutterSeparator(Parts.ByClass[TSynGutterSeparator, Index]);
end;

function TSynGutter.LineOverviewPart(Index: Integer): TSynGutterLineOverview;
begin
  Result := TSynGutterLineOverview(Parts.ByClass[TSynGutterLineOverview, Index]);
end;

{ TSynGutterSeparator }

procedure TSynGutterSeparator.SetLineWidth(const AValue: Integer);
begin
  if FLineWidth = AValue then exit;
  FLineWidth := AValue;
  DoChange(Self);
end;

procedure TSynGutterSeparator.SetLineOffset(const AValue: Integer);
begin
  if FLineOffset = AValue then exit;
  FLineOffset := AValue;
  DoChange(Self);
end;

procedure TSynGutterSeparator.SetLineOnRight(const AValue: Boolean);
begin
  if FLineOnRight = AValue then exit;
  FLineOnRight := AValue;
  DoChange(Self);
end;

function TSynGutterSeparator.PreferedWidth: Integer;
begin
  Result := 2;
end;

constructor TSynGutterSeparator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  MarkupInfo.Background := clWhite;
  MarkupInfo.Foreground := clDkGray;
  FLineWidth := 1;
  FLineOffset := 0;
  FLineOnRight := True;
end;

procedure TSynGutterSeparator.Paint(Canvas: TCanvas; AClip: TRect; FirstLine, LastLine: integer);
begin
  PaintBackground(Canvas, AClip);

  if FLineOnRight then begin
    AClip.Right := Min(AClip.Right, Left + LeftOffset + Width - FLineOffset);
    AClip.Left  := Max(AClip.Left,  Left + LeftOffset + Width - FLineOffset  - FLineWidth);
  end else begin
    AClip.Left  := Max(AClip.Left,  Left + LeftOffset + FLineOffset);
    AClip.Right := Min(AClip.Right, Left + LeftOffset + FLineOffset  + FLineWidth);
  end;
  if AClip.Right > AClip.Left then begin
    Canvas.Brush.Color := MarkupInfo.Foreground;
    Canvas.FillRect(AClip);
  end;
end;

{ TSynEditMouseActionsGutter }

procedure TSynEditMouseActionsGutter.InitForOptions(AnOptions: TSynEditorMouseOptions);
var
  rmc: Boolean;
begin
  Clear;
  rmc := (emRightMouseMovesCursor in AnOptions);

  AddCommand(emcOnMainGutterClick, False, mbXLeft,  ccAny, cdDown, [], []);
  AddCommand(emcContextMenu,       rmc,   mbXRight, ccSingle, cdUp, [], []);
end;

end.

