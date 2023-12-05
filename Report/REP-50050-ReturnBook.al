report 50050 "Return Book"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            column(Date; "Posting Date") { }
            column(Month; '') { }
            column(Location; "Location Code") { }
            column(ITEM_Code; "Item No.") { }
            column(Batch_No; "Lot No.") { }
            column(Buyer; '') { }
            column(Product_Group_Code; '') { }
            column(NOD; '') { }
            column(Type; '') { }
            column(Packing; '') { }
            column(Drum_Type; '') { }
            column(Quantity; Quantity) { }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Name; '')
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = Excel;
            LayoutFile = 'mySpreadsheet.xlsx';
        }
    }

    var
        myInt: Integer;
}