with AES; use AES;
with Interfaces; use Interfaces;
with Key_Expansion; use Key_Expansion;
with CFB; use CFB;

package Read_Message_File with SPARK_Mode is

   --type Message is array (Natural range <>) of Block_Matrix;

   procedure Read_File
     (File_Name : in String;
     Char_Array : out Byte_Vector);

   procedure To_Block_Matrix_Array
     (Char_Array : in Byte_Vector;
      Block_Matrix_Array : out Message);

   procedure Padding
     (Char_Array : in Byte_Vector;
      Block_Matrix_Array : out Message);

end Read_Message_File;
