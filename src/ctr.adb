with Key_Expansion; use Key_Expansion;
with CFB; use CFB;
package body CTR with SPARK_Mode is

   function CTR_Encryption
     (Plaintext : Message;
      Initialization_Vector : Block_Matrix;
      Rounds : Positive;
      Keys : Key_Table) return Message
   is
      Cipher : Message (Plaintext'Range) := Plaintext;
      Counter : Unsigned_64 := 0;
      Counter_Block : Block_Matrix;
      XoredIV : Block_Matrix;
   begin
      for i in 1..Plaintext'Last loop
         Counter_Block := To_Block_Matrix (Counter);
         XoredIV := XOR_Block (Initialization_Vector, Counter_Block);
         Cipher (i) := XOR_Block (AES_Encryption (Entry_Block => XoredIV,
                                                  Keys        => Keys,
                                                  Rounds      => Rounds),
                                  Plaintext (i));
         Counter := Counter + 1;
      end loop;
      return Cipher;
   end CTR_Encryption;

   function CTR_Decryption
     (Ciphertext : Message;
      Initialization_Vector : Block_Matrix;
      Rounds : Positive;
      Keys : Key_Table) return Message
   is
      Plain : Message (Ciphertext'Range);
      Counter : Unsigned_64 := 0;
      Counter_Block : Block_Matrix;
      XoredIV : Block_Matrix;
   begin
      for i in 1..Ciphertext'Last loop
         Counter_Block := To_Block_Matrix (Counter);
         XoredIV := XOR_Block (Initialization_Vector, Counter_Block);
         Plain (i) := XOR_Block (AES_Encryption (Entry_Block => XoredIV,
                                                 Keys        => Keys,
                                                 Rounds      => Rounds),
                                 Ciphertext (i));
         Counter := Counter + 1;
      end loop;
      return Plain;
   end CTR_Decryption;

   function To_Block_Matrix
     (Data : Unsigned_64) return Block_Matrix
   is
      Block : Block_Matrix;

      Word_Array : array (Index) of Unsigned_32 := (16#0#, 16#0#, 16#0#, 16#0#);

      Temp : Byte_Vector (0..3);
   begin

      Word_Array (2) := Unsigned_32 (Shift_Right(Data, 32) and 16#FFFF_FFFF#);
      Word_Array (3) := Unsigned_32 (Data and 16#FFFF_FFFF#);

      for i in Index loop
         Temp := To_Byte_Vector (Word_Array (i));
         for j in Index loop
            Block (i, j) := Temp ( Integer (j));
         end loop;
      end loop;
      return Block;
   end To_Block_Matrix;

end CTR;
