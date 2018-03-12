codeunit 50701 "Barcode Mgt."
{
    TableNo = Barcode;

    var
        Barcode: Record Barcode;
        Code39Codes: Dictionary of [Char, Text];
        Size: Integer;

    trigger OnRun();
    begin
        Size := 1;

        Barcode := Rec;
        Clear("Binary Text");

        case "Encoding Type" of
            "Encoding Type"::Code39 :
                ProcessCode39;
        "Encoding Type"::Code39Extended :;
        "Encoding Type"::Code39Mod43 :;
        end;
    end;

    local procedure ProcessCode39()
    var
        counter: Integer;
        character: Char;
        binarytext:Text;
        uppercasecharacter: Text;
    begin
        InitCode39;
        Barcode.Value := DelChr(Barcode.Value, '=', '*');
        Barcode.Value := '*' + Barcode.Value + '*';

        for counter := 1 to StrLen(Barcode.Value) do
        begin
            character := Barcode.Value[counter];
            uppercasecharacter := UpperCase(Format(character));
            binarytext += Code39Codes.Get(uppercasecharacter[1]);
            binarytext += '0';
        end;

        binarytext := CopyStr(BinaryText, 1, StrLen(BinaryText));

        Barcode."Binary Text Length" := StrLen(binarytext);

        WriteTextToBinaryTextBlob(binarytext);

        CLEAR(Code39Codes);
    end;

    local procedure InitCode39()
    begin
        clear(Code39Codes);
        Code39Codes.Add(0, '101001101101');
        Code39Codes.Add(1, '110100101011');
        Code39Codes.Add(2, '101100101011');
        Code39Codes.Add(3, '110110010101');
        Code39Codes.Add(4, '101001101011');
        Code39Codes.Add(5, '110100110101');
        Code39Codes.Add(6, '101100110101');
        Code39Codes.Add(7, '101001011011');
        Code39Codes.Add(8, '110100101101');
        Code39Codes.Add(9, '101100101101');
        Code39Codes.Add('A', '110101001011');
        Code39Codes.Add('B', '101101001011');
        Code39Codes.Add('C', '110110100101');
        Code39Codes.Add('D', '101011001011');
        Code39Codes.Add('E', '110101100101');
        Code39Codes.Add('F', '101101100101');
        Code39Codes.Add('G', '101010011011');
        Code39Codes.Add('H', '110101001101');
        Code39Codes.Add('I', '101101001101');
        Code39Codes.Add('J', '101011001101');
        Code39Codes.Add('K', '110101010011');
        Code39Codes.Add('L', '101101010011');
        Code39Codes.Add('M', '110110101001');
        Code39Codes.Add('N', '101011010011');
        Code39Codes.Add('O', '110101101001');
        Code39Codes.Add('P', '101101101001');
        Code39Codes.Add('Q', '101010110011');
        Code39Codes.Add('R', '110101011001');
        Code39Codes.Add('S', '101101011001');
        Code39Codes.Add('T', '101011011001');
        Code39Codes.Add('U', '110010101011');
        Code39Codes.Add('V', '100110101011');
        Code39Codes.Add('W', '110011010101');
        Code39Codes.Add('X', '100101101011');
        Code39Codes.Add('Y', '110010110101');
        Code39Codes.Add('Z', '100110110101');
        Code39Codes.Add('-', '100101011011');
        Code39Codes.Add('.', '110010101101');
        Code39Codes.Add(' ', '100110101101');
        Code39Codes.Add('$', '100100100101');
        Code39Codes.Add('/', '100100101001');
        Code39Codes.Add('+', '100101001001');
        Code39Codes.Add('%', '101001001001');
        Code39Codes.Add('*', '100101101101');
    end;

    local procedure CreateBmpHeader()
    var
        ostream: OutStream;
        charHelper: Char;
    begin
        Barcode."Barcode Image".CreateOutStream(ostream);

        charHelper := 'B';
        ostream.Write(charHelper, 1);
        charHelper := 'M';
        ostream.Write(charHelper, 1);
        ostream.Write(54 * 3, 4);                                                //SIZE BMP
        //stream.Write(54 + ROUND(strlen(BinaryText) * 0.25, 1, '>') * strlen(BinaryText) * 3, 4); //SIZE BMP
        ostream.WRITE(0, 4);                                                     //APPLICATION SPECIFIC
        ostream.WRITE(54, 4);                                                    //OFFSET DATA PIXELS
        ostream.WRITE(40, 4);                                                    //NUMBER OF BYTES IN HEADER FROM THIS POINT
        ostream.WRITE(Barcode."Binary Text Length", 4);                          //WIDTH PIXEL
        ostream.WRITE(ROUND(Barcode."Binary Text Length" * 0.25, 1, '>'), 4);    //HEIGHT PIXEL
        ostream.WRITE(65536 * 24 + 1, 4);                                        //COLOR DEPTH
        ostream.WRITE(0, 4);                                                     //NO. OF COLOR PANES & BITS PER PIXEL
        ostream.WRITE(0, 4);                                                     //SIZE BMP DATA
        ostream.WRITE(2835, 4);                                                  //HORIZONTAL RESOLUTION
        ostream.WRITE(2835, 4);                                                  //VERTICAL RESOLUTION
        ostream.WRITE(0, 4);                                                     //NO. OF COLORS IN PALETTE
        ostream.WRITE(0, 4);                                                     //IMPORTANT COLORS 
    end;

    local procedure CreateBmpDetail()
    var
        ostream: OutStream;
        barloop:Integer;
        lineloop:Integer;
        fillerloop:Integer;
        bmpchar:Char;
        texthelper:Text;
    begin
        //Barcode.calcfields("Binary Text");
        Barcode."Barcode Image".CreateOutStream(ostream);
        texthelper := GetTextFromBinaryTextBlob();
        

        for lineloop := 1 to ROUND(Barcode."Binary Text Length" * 0.25, 1, '>')  do begin
            for barloop := 1 to Barcode."Binary Text Length" do begin             
              if (texthelper[barloop] = '1') then
                  bmpchar := 0
              else
                  bmpchar := 255;
            
              ostream.Write(bmpchar,1);
              ostream.Write(bmpchar,1);
              ostream.Write(bmpchar,1);
            end;    
            for fillerloop := 1 to (barloop MOD 4)do begin
                bmpchar := 0;
                ostream.Write(bmpchar,1);
            end; 
        end;       
    end;

    local procedure WriteTextToBinaryTextBlob(binarytext: Text)
    var
    outstr:OutStream;
    begin
        Barcode."Binary Text".CreateOutStream(outstr);
        outstr.WriteText(Binarytext);
    end;

    procedure GetTextFromBinaryTextBlob():Text
    var
        istream: InStream;
        texthelper:Text;
    begin
        Barcode."Binary Text".CreateInStream(istream);
        istream.ReadText(texthelper);
        exit(texthelper);
    end;



}