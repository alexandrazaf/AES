with Key_Expansion; use Key_Expansion;
with AES; use AES;
with Ada.Text_IO;   use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
procedure test_key_expansion is
   Key : constant Word_Vector := (16#2b7e1516#, 16#28aed2a6#, 16#abf71588#, 16#09cf4f3c#);
   N : constant Positive := 4;
   Rounds : constant Positive := 10;

   Keys : Key_Table (0..Rounds);

begin
   Keys := Key_Expansion_Schedule(Key        => Key,
                                  Key_Length => N,
                                  RKey     => Rounds+1);

   Put_Line("Key expansion done");
   for k in 0..Rounds loop
      Put_Line("key number");
      Put (k);
      Put_Line("");
      for i in Index loop
         for j in Index loop
            Put (Integer (Keys (k) (i,j)), Width => 7, Base => 16);
         end loop;
      Put_Line("");
      end loop;
   end loop;

end test_key_expansion;
