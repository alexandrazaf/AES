with AES; use AES;
with Interfaces; use Interfaces;
with CFB; use CFB;

package CTR with SPARK_Mode is

   function CTR_Encryption
     (Plaintext : Message;
      Initialization_Vector : Block_Matrix;
      Rounds : Positive;
      Keys : Key_Table) return Message;

   function CTR_Decryption
     (Ciphertext : Message;
      Initialization_Vector : Block_Matrix;
      Rounds : Positive;
      Keys : Key_Table) return Message;

   function To_Block_Matrix
     (Data : Unsigned_64) return Block_Matrix;
end CTR;
