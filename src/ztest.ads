with Interfaces.C;
with Interfaces.C.Strings;
with System;

package ztest is

   subtype Z_Windows_Size is Interfaces.C.int;

   type alloc_func is access function
     (Opaque : System.Address;
      Items  : Interfaces.C.unsigned;
      Size   : Interfaces.C.unsigned)
      return System.Address;

   type free_func is access procedure (opaque : System.Address; address : System.Address);

   type Z_Stream is record
      Next_In   : System.Address             := System.Null_Address; -- next input byte
      Avail_In  : Interfaces.C.unsigned      := 0;                   -- number of bytes available at next_in
      Total_In  : Interfaces.C.unsigned_long := 0;                   -- total nb of input bytes read so far
      Next_Out  : System.Address             := System.Null_Address; -- next output byte should be put there
      Avail_Out : Interfaces.C.unsigned      := 0;                   -- remaining free space at next_out
      Total_Out : Interfaces.C.unsigned_long := 0;                   -- total nb of bytes output so far
      msg       : Interfaces.C.Strings.chars_ptr;                    -- last error message, NULL if no error
      state     : System.Address;                                    -- not visible by applications
      zalloc    : alloc_func                 := null;                -- used to allocate the internal state
      zfree     : free_func                  := null;                -- used to free the internal state
      opaque    : System.Address;                                    -- private data object passed to zalloc and zfree
      data_type : Interfaces.C.int;                                  -- best guess about the data type ascii or binary
      adler     : Interfaces.C.unsigned_long;                        -- adler32 value of the uncompressed data
      reserved  : Interfaces.C.unsigned_long;                        -- reserved for future use
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

   type Z_Code is
     (
      Z_Code_Version_Error,
      Z_Code_Buffer_Error,
      Z_Code_Memory_Error,
      Z_Code_Data_Error,
      Z_Code_Stream_Error,
      Z_Code_ERRNO,
      Z_Code_Ok,
      Z_Code_Stream_End,
      Z_Code_Need_Dict
     );
   for Z_Code'Size use Interfaces.C.int'Size;
   for Z_Code use
     (
      Z_Code_Version_Error => -6,
      Z_Code_Buffer_Error => -5,
      Z_Code_Memory_Error => -4,
      Z_Code_Data_Error => -3,
      Z_Code_Stream_Error => -2,
      Z_Code_ERRNO => -1,
      Z_Code_Ok => 0,
      Z_Code_Stream_End => 1,
      Z_Code_Need_Dict => 2
     );
   -- Return codes for the compression/decompression functions.
   -- Negative values are errors, positive values are used for special but normal events.


   procedure Initialize_Inflate (Stream : in out Z_Stream; Windows_Size  : in Z_Windows_Size);


   function Inflate (Stream : in out Z_Stream; Flush : Z_Flush) return Z_Code;
   pragma Import (C, Inflate, "inflate");
   -- Z_STREAM_END if the end of the compressed data has been reached and all uncompressed output has been produced.

end ztest;
