with Interfaces.C;
with Interfaces.C.Strings;
with System;
with Ada.Streams;
with Ada.Streams.Stream_IO;

package ztest.Streams is

   type Z_Inflate_Stream is new Ada.Streams.Root_Stream_Type with private;

private

   type Z_Inflate_Stream is new Ada.Streams.Root_Stream_Type with record
      Native_Stream : Z_Native_Stream;
   end record;

   overriding procedure Read (Object : in out Z_Inflate_Stream; Item : out Ada.Streams.Stream_Element_Array; Last : out Ada.Streams.Stream_Element_Offset);
   overriding procedure Write (Object : in out Z_Inflate_Stream; Item : Ada.Streams.Stream_Element_Array);

end;
