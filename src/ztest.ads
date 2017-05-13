with Interfaces.C;
with Interfaces.C.Strings;
with System;
with Ada.Streams;
with Ada.Streams.Stream_IO;

package ztest is

   subtype Z_Windows_Size is Interfaces.C.int;

   type Z_Allocation_Function is access function
     (Opaque : System.Address;
      Items  : Interfaces.C.unsigned;
      Size   : Interfaces.C.unsigned)
      return System.Address;

   type Z_Free_Function is access procedure (opaque : System.Address; address : System.Address);

   type Z_Native_Stream is record
      Input_Next : System.Address := System.Null_Address;
      -- next input byte

      Input_Available : Interfaces.C.unsigned := 0;
      -- number of bytes available at next_in

      Input_Total : Interfaces.C.unsigned_long := 0;
      -- total nb of input bytes read so far

      Output_Next : System.Address := System.Null_Address;
      -- next output byte should be put there

      Output_Available : Interfaces.C.unsigned := 0;
      -- remaining free space at next_out

      Output_Total : Interfaces.C.unsigned_long := 0;
      -- total nb of bytes output so far

      Message : Interfaces.C.Strings.chars_ptr;
      -- last error message, NULL if no error

      State : System.Address;
      -- not visible by applications

      Allocation_Function : Z_Allocation_Function := null;
      -- used to allocate the internal state

      Free_Function : Z_Free_Function := null;
      -- used to free the internal state

      opaque : System.Address;
      -- private data object passed to zalloc and zfree

      data_type : Interfaces.C.int;
      -- best guess about the data type ascii or binary

      adler : Interfaces.C.unsigned_long;
      -- adler32 value of the uncompressed data

      reserved : Interfaces.C.unsigned_long;
      -- reserved for future use
   end record;
   -- struct z_stream_s

   type Z_Flush is
     (
      Z_Flush_None,
      Z_Flush_Partial,
      Z_Flush_Synchronized,
      Z_Flush_Full,
      Z_Flush_Finnish,
      Z_Flush_Block,
      Z_Flush_Trees
     );
   for Z_Flush'Size use Interfaces.C.int'Size;
   for Z_Flush use
     (
      Z_Flush_None => 0,
      Z_Flush_Partial => 1,
      Z_Flush_Synchronized => 2,
      Z_Flush_Full => 3,
      Z_Flush_Finnish => 4,
      Z_Flush_Block => 5,
      Z_Flush_Trees => 6
     );
   -- Allowed flush values; see deflate() and inflate() below for details.

   type Z_Status is
     (
      Z_Status_Version_Error,
      Z_Status_Buffer_Error,
      Z_Status_Memory_Error,
      Z_Status_Data_Error,
      Z_Status_Stream_Error,
      Z_Status_ERRNO,
      Z_Status_Ok,
      Z_Status_Stream_End,
      Z_Status_Need_Dict
     );
   for Z_Status'Size use Interfaces.C.int'Size;
   for Z_Status use
     (
      Z_Status_Version_Error => -6,
      Z_Status_Buffer_Error => -5,
      Z_Status_Memory_Error => -4,
      Z_Status_Data_Error => -3,
      Z_Status_Stream_Error => -2,
      Z_Status_ERRNO => -1,
      Z_Status_Ok => 0,
      Z_Status_Stream_End => 1,
      Z_Status_Need_Dict => 2
     );
   -- Return codes for the compression/decompression functions.
   -- Negative values are errors, positive values are used for special but normal events.


   procedure Initialize_Inflate (Stream : in out Z_Native_Stream; Windows_Size : in Z_Windows_Size);


   function Inflate (Stream : in out Z_Native_Stream; Flush : Z_Flush) return Z_Status;
   pragma Import (C, Inflate, "inflate");
   -- Z_STREAM_END if the end of the compressed data has been reached and all uncompressed output has been produced.

   procedure Set_Next_Input (Stream : in out Z_Native_Stream; Item : in Ada.Streams.Stream_Element_Array);
   procedure Set_Next_Output (Stream : in out Z_Native_Stream; Item : out Ada.Streams.Stream_Element_Array);


   generic
      type Element is private;
   function Generic_Inflate (Stream : in out Z_Native_Stream; Item : out Element; Flush : Z_Flush) return Z_Status;

end ztest;
