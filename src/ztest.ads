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

   Z_OK : constant := 0;
   Z_STREAM_ERROR : constant := -2;
   Z_MEM_ERROR : constant := -4;
   Z_VERSION_ERROR : constant := -6;
   Z_STREAM_END : constant := 1;
   Z_NO_FLUSH : constant := 0;

   procedure Initialize (Stream : in out Z_Stream; Windows_Size  : in Z_Windows_Size);


   function Inflate (Stream : in out Z_Stream; Flush : Interfaces.C.int) return Interfaces.C.int;
   pragma Import (C, Inflate, "inflate");
   -- Z_STREAM_END if the end of the compressed data has been reached and all uncompressed output has been produced.

end ztest;
