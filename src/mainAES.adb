with Ada.Command_Line; use Ada.Command_Line;
with Command_Functions; use Command_Functions;
with Change_Key; use Change_Key;
with Key_Expansion; use Key_Expansion;
with AES; use AES;

procedure MainAES is
   Key_Length : Positive := 4;
   Key : Word_Vector (0..Key_Length-1) := (0, 0, 0, 0);
   Keys : Key_Table := Key_Expansion_Schedule (Key        => Key,
                                               Key_Length => Key_Length,
                                               RKey       => 11);

   Text_File : String := "fichier.txt";
   IV_File : String := "IV.txt";

   mode : String (1..3);

   Rounds : Positive;

begin

   if Argument (1) = "encrypt" then
      Text_File := Argument (2);
      IV_File := Argument (3);
      mode := Argument (4);
      Encrypt (Text_File, IV_File, mode, Rounds, Keys);

   elsif Argument (1) = "decrypt" then
      Text_File := Argument (2);
      IV_File := Argument (3);
      mode := Argument (4);
      Decrypt (Text_File, IV_File, mode, Rounds, Keys);

   elsif Argument (1) = "changekey" then
      Text_File := Argument (2);
      ChangeKey (Text_File, Key, Keys, Key_Length);
      Rounds := Keys'Length - 1;

   else
      Set_Exit_Status (Failure);
   end if;

end MainAES;
