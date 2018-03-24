pageextension 50700 Barcode extends "Order Processor Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast("Tasks"){
            
                action("Generate Barcode")
                {
                   RunObject = page "Barcode Demo";
                   ApplicationArea = All;
                   Image = BarCode;
                }

        }
    }
}