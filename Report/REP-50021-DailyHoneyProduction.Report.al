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
            column(Filled; Var_Filled)
            {

            }
            column(Packed; Quantity)
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
                column(Opening_Stock; '')
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
                Var_Filled := Var_Packing * Quantity;
            end;

            trigger OnPreDataItem()
            begin
                SETFILTER("Posting Date", '%1..%2', FromDate, ToDate);
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
        Var_Packing: Decimal;
        Cust_Var: Record Customer;
        ILE_Var: Record "Item Ledger Entry";
}