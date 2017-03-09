with Ada.Text_IO;
with Ada.Assertions;

package body ztest is

   use type Interfaces.C.char_array;
   use type Interfaces.C.int;


   nul : Interfaces.C.char renames Interfaces.C.nul;
   Version : aliased Interfaces.C.char_array := "1.2.11" & nul;
   Z_Stream_Size_Byte : constant Interfaces.C.int := Z_Stream'Size / System.Storage_Unit;


   function inflateInit2_underscore
     (strm        : in out Z_Stream;
      windowBits  : in Interfaces.C.int;
      version     : in Interfaces.C.char_array;
      stream_size : in Interfaces.C.int)
      return Interfaces.C.int;
   pragma Import (C, inflateInit2_underscore, "inflateInit2_");




   procedure Initialize (Stream : in out Z_Stream; Windows_Size  : in Z_Windows_Size) is
      use Ada.Assertions;
      R : Interfaces.C.int;
   begin
      R := inflateInit2_underscore (Stream, Windows_Size, Version, Z_Stream_Size_Byte);
      Assert (R /= Z_VERSION_ERROR, "Z_VERSION_ERROR. zlib library version is incompatible with the version assumed by the caller.");
      Assert (R /= Z_MEM_ERROR, "Z_MEM_ERROR. There was not enough memory.");
      Assert (R /= Z_STREAM_ERROR, "Z_STREAM_ERROR. A parameters are invalid, such as a null pointer to the structure.");
      Assert (R = 0, "Return value is not Z_OK.");
      Ada.Text_IO.Put_Line (R'Img);
   end;



end ztest;
