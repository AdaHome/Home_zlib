package body ztest.Streams is


   overriding procedure Read
     (Object : in out Z_Inflate_Stream;
      Item : out Ada.Streams.Stream_Element_Array;
      Last : out Ada.Streams.Stream_Element_Offset)
   is
   begin
      null;
   end;

   overriding procedure Write
     (Object : in out Z_Inflate_Stream;
      Item : Ada.Streams.Stream_Element_Array)
   is
   begin
      --Set_Next_Input (Object.Native_Stream, Item);
      null;
   end;

end;
