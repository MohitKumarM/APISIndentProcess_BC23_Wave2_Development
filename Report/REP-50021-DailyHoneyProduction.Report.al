report 50021 "Daily Honey Production Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\DailyHoneyProductionReport.rdl';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Item No.";
            column(FromDate; FromDate)
            {

            }
            column(ToDate; ToDate)
            {

            }
            column(Location_Code; "Location Code")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Filled; '')
            {

            }
            column(Packed_Unit1; Unit1_Qty)
            {

            }
            column(Packed_Unit2; Unit2_Qty)
            {

            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = field("Item No.");
                DataItemTableView = sorting("No.") where("Planning Type" = filter(0));
                column(Type; Var_Type)
                {

                }
                column(Customer; Var_ItmeName)
                {

                }
                column(FG_Code; "No.")
                {

                }
                column(Item_Desc; Description)
                {

                }
                column(Brand; Brand)
                {

                }
                column(Wt; weight)
                {

                }
                column(Packing; Packing)
                {

                }
                column(Opening_Stock; Opening_Stock)
                {

                }
                trigger OnPreDataItem()
                begin
                end;

                trigger OnAfterGetRecord()
                begin
                    Cust_Var.Reset();
                    Cust_Var.SetRange("No.", "Customer Code");
                    if Cust_Var.FindFirst() then begin
                        Var_Type := Cust_Var."Customer Type";
                        Var_ItmeName := Cust_Var.Name;
                    end;
                    Var_Packing := Packing;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                ILE_Var1.Reset();
                ILE_Var1.SetRange("Item No.", "Item Ledger Entry"."Item No.");
                ILE_Var1.SetFilter("Posting Date", '%1..%2', FromDate - 1, ToDate);
                if ILE_Var1.FindFirst() then begin
                    if ILE_Var1."Location Code" = 'BLUE' then begin
                        Unit1_Qty := ILE_Var1.Quantity
                    end else begin
                        if ILE_Var1."Location Code" = 'RED' then
                            Unit2_Qty := ILE_Var1.Quantity
                    end;
                end;

                ILE_Var.Reset();
                ILE_Var.SetRange("Item No.", "Item Ledger Entry"."Item No.");
                ILE_Var.SetFilter("Posting Date", '%1..%2', FromDate - 1, ToDate);
                ILE_Var.SetFilter(Positive, '%1', true);
                ILE_Var.SetFilter("Order Type", '%1', "Order Type"::Production);
                if ILE_Var.FindFirst() then begin
                    ILE_Var.CalcSums(Quantity);
                    Opening_Stock := ILE_Var.Quantity;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SETFILTER("Posting Date", '%1..%2', FromDate - 1, ToDate);
            end;
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
                    field(From_Date; FromDate)
                    {
                        ApplicationArea = All;

                    }
                    field(To_Date; ToDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    Begin
        IF (FromDate = 0D) OR (ToDate = 0D) THEN
            ERROR('Please select From Date /ToDate');
    End;

    var
        FromDate: Date;
        ToDate: Date;
        Var_Type: Enum "Customer Type";
        Var_ItmeName: Text[50];
        Var_Filled: Decimal;
        Unit1_Qty: Decimal;
        Unit2_Qty: Decimal;
        Var_Packing: Decimal;
        Cust_Var: Record Customer;
        ILE_Var: Record "Item Ledger Entry";
        ILE_Var1: Record "Item Ledger Entry";
        Opening_Stock: Decimal;
}