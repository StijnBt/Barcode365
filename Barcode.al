table 50700 Barcode
{
    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption='Entry No.';
        }
        field(2;"Value";Text[250])
        {
            Caption='Encoded Value';
        }
        field(3;"Barcode Image";Blob)
        {
            Caption='Barcode';
            Subtype=Bitmap;
        }
        field(4;"Encoding Type";Option)
        {
            Caption='Encoding Type';
            OptionCaption='Code 39,Code 39 Extended,Code 39 Mod 43';
            OptionMembers=Code39,Code39Extended,Code39Mod43;
        }
        field(5;Width;Integer)
        {
            Caption='Width';
        }
        field(6;Height;Integer)
        {
            Caption='Height';
        }
        field(7;"Image Format";Option)
        {
            Caption='Image Format';
            OptionCaption='JPG, BMP, PNG, GIF, TIFF';
            OptionMembers=JPG,BMP,PNG,GIF,TIFF;
        }

        field(50;"Binary Text";Blob)
        {
            Caption='Binary Text';
        }

        field(51;"Binary Text Length";Integer)
        {
            Caption='Binary Text Length';
        }

        field(100;"Encoding Time";Integer)
        {
            Caption='Encoding Time';
        }
    }

    keys
    {
        key(PK;"Entry No.")
        {
            Clustered = true;
        }
    }
    
    var
        //myInt : Integer;

    trigger OnInsert();
    begin
        //prevent actual inserts in physical table
        IF NOT Rec.IsTemporary THEN
          ERROR(''); 
    end;

    trigger OnModify();
    begin
        //prevent actual modifications in physical table
        IF NOT Rec.IsTemporary THEN
          ERROR(''); 
    end;

    trigger OnDelete();
    begin
    end;

    trigger OnRename();
    begin
    end;

    procedure Encode()
    var
        Start:DateTime;
    begin
        Clear(BarCodeMgt);
        Start := CurrentDateTime;

        if Value.Trim = '' then
            Error('Encoded value is mandatory');

        case "Encoding Type" of
            "Encoding Type"::Code39:
                BarCodeMgt.Run(Rec);            
            "Encoding Type"::Code39Extended:;
            "Encoding Type"::Code39Mod43:;
            else
            ERRor('Unknown encoding type');    
        end;


        "Encoding Time" := CurrentDateTime -Start;
        CalcFields("Barcode Image");
        Modify;
    end;

    procedure GetTextFromBinaryTextBlob():Text
    begin
        exit(BarCodeMgt.GetTextFromBinaryTextBlob());
    end;

    var
            BarCodeMgt:Codeunit "Barcode Mgt.";


}