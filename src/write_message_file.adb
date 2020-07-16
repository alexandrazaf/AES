with Text_IO; use Text_IO;
package body Write_Message_File with SPARK_Mode is


   -- écriture du fichier dans le cas du déchiffrement
   procedure Remove_Padding_Write_File
     (Char_Array : in Byte_Vector)
   is
      Pad : constant Integer := Integer (Char_Array (Char_Array'Last));
      Output : File_Type;
      Last : constant Integer := Char_Array'Last - Pad;
   begin
      Create (File => Output,
              Mode => Out_File,
              Name => "decipher_message.txt");
      for i in 0..Last loop
         Put (Output, Character'Val (Char_Array (i))); -- conversion du code du caractère en texte et écriture dans le fichier
      end loop;
      Close (Output);
   end Remove_Padding_Write_File;


   -- écriture du fichier de sortie dans le cas du chiffrement
   procedure Write_File
     (Char_Array : in Byte_Vector)
   is
      Output : File_Type;
      Last : constant Integer := Char_Array'Last;
   begin
      Create (File => Output,
              Mode => Out_File,
              Name => "cipher_message.txt");
      for i in 0..Last loop
         Put (Output, Character'Val (Char_Array (i)));
      end loop;
      Close (Output);
   end Write_File;

   -- conversion de blocs en tableau de caractères
   procedure To_Char_Array
     (Block_Matrix_Array : in Message;
      Char_Array : out Byte_Vector)
   is
      Count : Natural := 0;
   begin

      for k in Block_Matrix_Array'Range loop
         for i in Index loop
            for j in Index loop
               Char_Array (Count) := Block_Matrix_Array (k) (i,j);
               Count := Count + 1;
            end loop;
         end loop;
      end loop;
   end To_Char_Array;



end Write_Message_File;
