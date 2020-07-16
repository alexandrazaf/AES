with AES; use AES;
with Interfaces; use Interfaces;
with Key_Expansion; use Key_Expansion;
with CFB; use CFB;

package Write_Message_File with SPARK_Mode is

   --type Message is array (Natural range <>) of Block_Matrix;

   procedure Remove_Padding_Write_File
     (Char_Array : in Byte_Vector);

   procedure Write_File
     (Char_Array : in Byte_Vector);

   procedure To_Char_Array
     (Block_Matrix_Array : in Message;
      Char_Array : out Byte_Vector);


end Write_Message_File;
