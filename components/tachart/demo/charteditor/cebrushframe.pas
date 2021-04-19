unit ceBrushFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Forms, Controls, StdCtrls, Dialogs, TAChartCombos;

type

  { TBrushFrame }

  TBrushFrame = class(TFrame)
    cbBrushStyle: TChartComboBox;
    cbBrushColor: TColorButton;
    lblBrushStyle: TLabel;
    procedure cbBrushColorColorChanged(Sender: TObject);
    procedure cbBrushStyleChange(Sender: TObject);
  private
    FBrush: TBrush;
    FOnChange: TNotifyEvent;
    procedure DoChanged;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Prepare(ABrush: TBrush);
    property OnChange: TNotifyEvent read FOnChange write FOnChange;

  end;

implementation

{$R *.lfm}

constructor TBrushFrame.Create(AOwner: TComponent);
begin
  inherited;
  cbBrushStyle.DropDownCount := DEFAULT_DROPDOWN_COUNT;
  cbBrushColor.Width := cbBrushColor.Height;
end;

procedure TBrushFrame.cbBrushStyleChange(Sender: TObject);
begin
  FBrush.Style := cbBrushStyle.BrushStyle;
  DoChanged;
end;

procedure TBrushFrame.cbBrushColorColorChanged(Sender: TObject);
begin
  FBrush.Color := cbBrushColor.ButtonColor;
  DoChanged;
end;

procedure TBrushFrame.DoChanged;
begin
  if Assigned(FOnChange) then FOnChange(FBrush);
end;

procedure TBrushFrame.Prepare(ABrush: TBrush);
begin
  FBrush := ABrush;
  cbBrushColor.ButtonColor := ColorToRGB(ABrush.Color);
  cbBrushStyle.BrushStyle := ABrush.Style;
end;

end.

