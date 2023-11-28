report 50039 "Indent Report From 2022"
{
    Caption = 'INDENT 2022-23 & 2023-24';
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = '.\ReportLayouts\indentReportFrom2022.rdl';

    dataset
    {

        dataitem("Pre Indent Header"; "Pre Indent Header")
        {
            column(SI_No; '')
            {

            }
            column(No_; "No.")
            {
            }
            column(Indent_Date; "Document Date")//Indent Date
            {

            }
            column(Deparment; "Shortcut Dimension 1 Code")//Deparment
            {

            }
            column(Approved; '')
            {

            }
            column(Purchase_From; '')
            {

            }
            column(Make_IFAny; '')
            {

            }
            column(Meterial; '')
            {

            }
            column(TAT; '')
            {

            }
            column(Code; '')
            {

            }
            column(Remarks; "Indent Remarks")
            {

            }
            column(Material_Status; "Indent Status")
            {

            }
            dataitem("Pre Indent Line"; "Pre Indent Line")
            {
                DataItemLink = "Indent No." = FIELD("No.");

                column(Indent; "Indent No.")// Indent
                {
                }
                column(itemNo_; "No.")
                {

                }

                column(Item_Name; Description)//Item Name
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(UOM; UOM)
                {

                }

            }
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
                    field(Start_DAte; Start_Date)
                    {

                    }
                    field(End_Date; End_Date)
                    {

                    }
                }
            }
        }
    }
    var
        Start_Date: Date;
        End_Date: Date;


}