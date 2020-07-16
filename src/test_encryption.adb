with Read_Message_File; use Read_Message_File;
with Write_Message_File; use Write_Message_File;
with AES; use AES;
with CFB; use CFB;


procedure test_encryption is
   Text_File : constant String := "plaintext.txt";
   Initialization_File : constant String := "IV.txt";
   IV_Array : Message;
   IV_Char_Array : Byte_Vector;
   Plain_Char_Array : Byte_Vector;
   Block_Matrix_Array : Message;
   Keys : Key_Table;
   Key_Length : Positive;
   Rounds : Positive;
   Cipher_Char_Array : Byte_Vector;
begin
   Read_File (Text_File, Plain_Char_Array);
   Read_File (Initialization_File, IV_Char_Array);

   Padding (Plain_Char_Array, Block_Matrix_Array);
   To_Block_Matrix_Array (IV_Char_Array, IV_Array);

   Block_Matrix_Array := CFB_Encryption (Plaintext             => Block_Matrix_Array,
                                         Initialization_Vector => IV_Array (0),
                                         Rounds                => Rounds,
                                         Keys                  => Keys);

   To_Char_Array (Block_Matrix_Array,  Cipher_Char_Array);
   Write_File (Cipher_Char_Array);

end test_encryption;
