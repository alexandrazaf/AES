with Interfaces; use Interfaces;
package body CFB with SPARK_Mode is

   function CFB_Encryption
     (Plaintext : Message;
      Initialization_Vector : Block_Matrix;
      Rounds : Positive;
      Keys : Key_Table) return Message
   is

      Cipher : Message (Plaintext'Range) := Plaintext;

   begin
      Cipher (0) := XOR_Block (AES_Encryption(Entry_Block => Initialization_Vector,
                                              Keys        => Keys,
                                              Rounds      => Rounds),
                               Plaintext (0));

      for i in 1..Plaintext'Last loop
         Cipher (i) := XOR_Block (AES_Encryption(Cipher (i-1), Keys, Rounds),
                                  Plaintext (i));
      end loop;

      return Cipher;

   end CFB_Encryption;


   function CFB_Decryption
     (Ciphertext : Message;
      Initialization_Vector : Block_Matrix;
      Rounds : Positive;
      Keys : Key_Table) return Message
   is

      Plain : Message (Ciphertext'Range) := Ciphertext;
   begin
      Plain (0) := XOR_Block (AES_Encryption(Entry_Block => Initialization_Vector,
                                             Keys        => Keys,
                                             Rounds      => Rounds),
                              Ciphertext (0));
      for i in 1..Ciphertext'Last loop
         Plain (i) := XOR_Block (AES_Encryption (Ciphertext (i-1), Keys, Rounds),
                                 Ciphertext (i));
      end loop;

      return Plain;

   end CFB_Decryption;

   -- XOR de deux blocs, octet par octet
   function XOR_Block
     (Block1 : Block_Matrix;
      Block2 : Block_Matrix) return Block_Matrix
   is
      Result : Block_Matrix;
   begin
      for i in Index loop
         for j in Index loop
            Result (i, j) := Block1 (i, j) xor Block2 (i, j);
         end loop;
      end loop;
      return Result;

   end XOR_Block;

end CFB;
