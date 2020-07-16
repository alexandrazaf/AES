with Text_IO; use Text_IO;
with Interfaces; use Interfaces;
with Ada.Command_Line; use Ada.Command_Line;
package body Change_Key with SPARK_Mode is

   procedure ChangeKey
     (File_Name : in String;
      Key : out Word_Vector;
      Keys : out Key_Table;
      Key_Length : out Positive)
   is
      package Modular is new Modular_IO (Unsigned_32); -- instanciation du package generique
      Input : File_Type;
      Item : Unsigned_32;
      i : Natural := 0;
      RKey : Positive; -- le nombre de clés dont on a besoin := nb de rounds plus une
   begin
      Modular.Default_Base := 16;
      Modular.Default_Width := 32;
      Open (File => Input,
            Mode => In_File,
            Name => File_Name);
      while not End_Of_File loop
         Modular.Get (Input, Item);
         Key (i) := Item;
         i := i + 1;
      end loop;
      Close (Input);

      Key_Length := i + 1;
      case Key_Length is
         when 4 =>
            RKey := 11;
         when 6 =>
            RKey := 13;
         when 8 =>
            RKey := 15;
         when others =>
            Set_Exit_Status (Failure);
            -- erreur d'input utilisateur : faire remonter le status code erreur
      end case;

      Keys := Key_Expansion_Schedule (Key        => Key,
                                      Key_Length => Key_Length,
                                      RKey       => RKey);

   end ChangeKey;

end Change_Key;
