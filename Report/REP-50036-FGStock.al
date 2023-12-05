report 50036 "FG Stock"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\FGStockN.rdl';


    dataset
    {
        dataitem(Item; Item)
        {

            dataitem(LocationRec; Location)
            {

                trigger OnAfterGetRecord()
                var
                    ILE_Loc: Record "Item Ledger Entry";
                    Entry_No_Loc: Integer;
                begin
                    ILE_Loc.Reset();
                    ILE_Loc.SetCurrentKey("Location Code", "Item No.", "Lot No.");
                    ILE_Loc.SetRange("Location Code", LocationRec.Code);
                    ILE_Loc.SetRange("Item No.", Item."No.");
                    ILE_Loc.SetFilter("Remaining Quantity", '>%1', 0);
                    if ILE_Loc.FindSet() then begin
                        repeat
                            ILE_Temp.Reset();
                            ILE_Temp.SetRange("Item No.", ILE_Loc."Item No.");
                            ILE_Temp.SetRange("Location Code", ILE_Loc."Location Code");
                            ILE_Temp.SetRange("Lot No.", ILE_Loc."Lot No.");
                            if not ILE_Temp.FindFirst() then begin
                                if ILE_Temp.IsTemporary then begin
                                    ILE_Temp.Init();
                                    // Entry_No_Loc += 1;
                                    ILE_Temp."Entry No." := ILE_Loc."Entry No."; //Entry_No_Loc;
                                    ILE_Temp."Item No." := ILE_Loc."Item No.";
                                    ILE_Temp."Location Code" := ILE_Loc."Location Code";
                                    ILE_Temp."Lot No." := ILE_Loc."Lot No.";
                                    ILE_Temp."Remaining Quantity" := ILE_Loc."Remaining Quantity";
                                    ILE_Temp.Insert();
                                end;
                            end else begin
                                if ILE_Temp.IsTemporary then begin
                                    ILE_Temp."Remaining Quantity" += ILE_Loc."Remaining Quantity";
                                    ILE_Temp.Modify();
                                end;
                            end;
                        until ILE_Loc.Next() = 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin

                end;
            }
        }
        dataitem(Integer; Integer)
        {
            column(Unit_Depot_Code; ILE_Temp."Location Code") { }
            column(Depot_Name; Location_Rec.Name) { }
            column(Brand; Item_Rec.Brand) { }
            column(Sub_Brand; '') { }
            column(Item_Code_FG_Code; ILE_Temp."Item No.") { }
            column(Item_Name; Item_Rec.Description) { }
            column(Pack_Size_SKU; '') { }
            column(Packaging_Type; '') { }
            column(Item_Category; Item_Rec."Item Category Code") { }
            column(UOM; ILE_Temp."Unit of Measure Code") { }
            column(Sales_Channel; Customer_Rec."Customer Price Group") { }
            column(FG_Stock_Qnty_nos; ILE_Temp.Quantity) { }
            column(Stock_Status; StockStatus_Var) { }
            column(Intransit_Qnty; ILE_Temp."Remaining Quantity") { }
            column(PKD; ILE_Temp."MFG. Date") { }
            column(USE_By; ILE_Temp."Expiration Date") { }
            column(MRP; ILE_Temp."MRP Price") { }
            column(Batch_No; ILE_Temp."Lot No.") { }

            trigger OnAfterGetRecord()
            begin
                Location_Rec.Get(ILE_Temp."Location Code");
                IF (Location_Rec."Reject Location" = true) then
                    StockStatus_Var := StockStatus_Var::"Non Saleable"
                else
                    StockStatus_Var := StockStatus_Var::Saleable;

                Item_Rec.Get(ILE_Temp."Item No.");

                if Customer_Rec.get(Item."Customer Code") then;


                ILE_Temp.Next();
            end;

            trigger OnPreDataItem()
            begin
                ILE_Temp_Count := ILE_Temp.Count;
                IF (ILE_Temp_Count > 0) then begin
                    SetRange(Number, 1, ILE_Temp_Count);
                    ILE_Temp.FindFirst();
                end else
                    CurrReport.Break();

            end;
        }
    }
    trigger OnPreReport()
    begin
        IF ILE_Temp.IsTemporary then
            ILE_Temp.DeleteAll();
    end;


    var
        ILE_Temp: Record "Item Ledger Entry" temporary;
        ILE_Temp_Count: Integer;
        StockStatus_Var: Option Saleable,"Non Saleable";
        Location_Rec: Record Location;
        Item_Rec: Record Item;
        Customer_Rec: Record Customer;
}