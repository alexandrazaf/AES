with Text_IO; use Text_IO;
package body Read_Message_File with SPARK_Mode is

   --Block_Matrix_Array : Message;

   procedure Read_File
     (File_Name : in String;
      Char_Array : out Byte_Vector)
   is
      -- Char_Array : Byte_Vector;
      i : Natural := 0;
      char : Character;
      Input : File_Type;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => File_Name);
      while not End_Of_File loop
         Get (Input, char);
         Char_Array (i) := Character'Pos(char);
         i := i+1;
      end loop;
      Close (Input);
      --return Char_Array;
   end Read_File;

   -- convertit le message d'entrée (ciphertext) en tableau de blocs de 128 bits
   procedure To_Block_Matrix_Array
     (Char_Array : Byte_Vector;
      Block_Matrix_Array : out Message)
   is
      numBlock : Integer;
   begin

      for k in Char_Array'Range loop
         numBlock := k/16;
         for i in Index loop
            for j in Index loop
               Block_Matrix_Array (numBlock) (i, j) := Char_Array (numBlock*16 + Integer(i+j));
            end loop;
         end loop;
      end loop;
   end To_Block_Matrix_Array;

   -- convertit le message d'entrée (plaintext) en tableau de blocs de 128 bits et ajoute le padding à la fin
   procedure Padding
     (Char_Array : in Byte_Vector;
      Block_Matrix_Array : out Message)
   is
      LastItem : constant Integer := Char_Array'Last mod 16;
      Pad : constant Integer := 16 - LastItem;
      LastLine : constant Integer := LastItem / 4;
      LastCol : constant Integer := LastItem mod 4;
   begin
      for i in Index loop
         for j in Index loop
            if Integer (i) >= LastLine and Integer (j) > LastCol then
               Block_Matrix_Array (Block_Matrix_Array'Last) (i,j) := 0;
            end if;
         end loop;
      end loop;
      Block_Matrix_Array (Block_Matrix_Array'Last) (3, 3) := Unsigned_8 (Pad);
   end Padding;

end Read_Message_File;
