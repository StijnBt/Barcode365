page 50700 "Barcode Demo"
{
    PageType = Card;
    SourceTable = Barcode;
    InsertAllowed=false;
    DeleteAllowed=false;
    ShowFilter=false;
    LinksAllowed=false;
    SourceTableTemporary = true;
    UsageCategory= Tasks;
    ApplicationArea = all;
    Caption='Barcode Demo';
    PopulateAllFields =false;
    SaveValues=false;

    layout
    {
        area(content)
        {
            group(Parameters)
            {
                Caption='Parameters';
                field("Value to encode";Value)
                { 
                    Description='Value to translate in barcode';
                }
                field(Encoding;"Encoding Type")
                {

                }
            }
            group(Barcode)
            {
                Caption='Barcode';
                field(Image;"Barcode Image")
                {
                    ShowCaption = false;
                }
                field("Binary Text";GetTextFromBinaryTextBlob)
                {
                    MultiLine=true;
                }
                field("Encoding Time";"Encoding Time")
                {}
                field("Has Value";"Barcode Image".HasValue)
                {}
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Encode)
            {
                Promoted = true;
                Image = BarCode;
                PromotedCategory=Process;
                Caption='Encode';

                trigger OnAction();
                begin
                    Encode;
                    CurrPage.Update(false)
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        if Insert then;
    end;



}