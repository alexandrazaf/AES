with Read_Message_File; use Read_Message_File;
with Write_Message_File; use Write_Message_File;
with Key_Expansion; use Key_Expansion;
with CFB; use CFB;
with CTR; use CTR;
with Ada.Command_Line; use Ada.Command_Line;

package body Command_Functions with SPARK_Mode is

   procedure Encrypt
     (Text_File : in String;
      IV_File : in String;
      mode : in String;
      Rounds : in Positive;
      Keys : in Key_Table)
   is
      IV_Array : Message (0..0);
      IV_Char_Array : Byte_Vector (0..15);
      Plain_Char_Array : Byte_Vector ;
      Block_Matrix_Array : Message;
      Cipher_Char_Array : Byte_Vector;

   begin
      Read_File (Text_File, Plain_Char_Array);
      Read_File (IV_File, IV_Char_Array);

      Padding (Plain_Char_Array, Block_Matrix_Array);
      To_Block_Matrix_Array (IV_Char_Array, IV_Array);

      if mode = "CFB" or mode = "cfb" then
         Block_Matrix_Array := CFB_Encryption (Plaintext             => Block_Matrix_Array,
                                               Initialization_Vector => IV_Array (0),
                                               Rounds                => Rounds,
                                               Keys                  => Keys);
      elsif mode = "CTR" or mode = "ctr" then
         Block_Matrix_Array := CTR_Encryption (Plaintext             => Block_Matrix_Array,
                                               Initialization_Vector => IV_Array (0),
                                               Rounds                => Rounds,
                                               Keys                  => Keys);
      else
         Set_Exit_Status (Failure);
         -- status code = fail à faire remonter
      end if;

      To_Char_Array (Block_Matrix_Array,  Cipher_Char_Array);
      Write_File (Cipher_Char_Array);

   end Encrypt;

   procedure Decrypt
     (Text_File : in String;
      IV_File : in String;
      mode : in String;
      Rounds : in Positive;
      Keys : in Key_Table)
   is
      IV_Array : Message (0..0);
      IV_Char_Array : Byte_Vector (0..15);
      Cipher_Char_Array : Byte_Vector;
      Block_Matrix_Array : Message;
      Plain_Char_Array : Byte_Vector;
   begin

      Read_File (Text_File, Cipher_Char_Array);
      Read_File (IV_File, IV_Char_Array);

      To_Block_Matrix_Array (Cipher_Char_Array, Block_Matrix_Array);
      To_Block_Matrix_Array (IV_Char_Array, IV_Array);

      if mode = "CFB" or mode = "cfb" then
         Block_Matrix_Array := CFB_Decryption (Ciphertext            => Block_Matrix_Array,
                                               Initialization_Vector => IV_Array (0),
                                               Rounds                => Rounds,
                                               Keys                  => Keys);
      elsif mode = "CTR" or mode = "ctr" then
         Block_Matrix_Array := CTR_Decryption (Ciphertext            => Block_Matrix_Array,
                                               Initialization_Vector => IV_Array (0),
                                               Rounds                => Rounds,
                                               Keys                  => Keys);
      else
         Set_Exit_Status (Failure);
         -- status code = fail à faire remonter
      end if;

      To_Char_Array (Block_Matrix_Array, Plain_Char_Array);
      Remove_Padding_Write_File (Plain_Char_Array);

   end Decrypt;


end Command_Functions;
