page 50098 dateList
{
    ApplicationArea = All;
    Caption = 'dateList';
    PageType = List;
    SourceTable = "Date";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Period No."; Rec."Period No.")
                {
                    ToolTip = 'Specifies the value of the Period No. field.';
                }
            }
        }
    }
}
