with AES; use AES;
package CFB with SPARK_Mode is

   type Message is array (Natural range <>) of Block_Matrix;

   function CFB_Encryption
     (Plaintext : Message;
      Initialization_Vector : Block_Matrix;
      Rounds : Positive;
      Keys : Key_Table) return Message;

   function CFB_Decryption
     (Ciphertext : Message;
      Initialization_Vector : Block_Matrix;
      Rounds : Positive;
      Keys : Key_Table) return Message;

   function XOR_Block
     (Block1 : Block_Matrix;
      Block2 : Block_Matrix) return Block_Matrix;

end CFB;
