with AES; use AES;
--with Interfaces; use Interfaces;
with Ada.Text_IO;   use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
procedure Main is
   Keys : constant Key_Table := (
		((16#2b#,16#7e#,16#15#,16#16#),(16#28#,16#ae#,16#d2#,16#a6#),(16#ab#,16#f7#,16#15#,16#88#),(16#09#,16#cf#,16#4f#,16#3c#)),
		((16#a0#,16#fa#,16#fe#,16#17#),(16#88#,16#54#,16#2c#,16#b1#),(16#23#,16#a3#,16#39#,16#39#),(16#2a#,16#6c#,16#76#,16#05#)),
		((16#f2#,16#c2#,16#95#,16#f2#),(16#7a#,16#96#,16#b9#,16#43#),(16#59#,16#35#,16#80#,16#7a#),(16#73#,16#59#,16#f6#,16#7f#)),
		((16#3d#,16#80#,16#47#,16#7d#),(16#47#,16#16#,16#fe#,16#3e#),(16#1e#,16#23#,16#7e#,16#44#),(16#6d#,16#7a#,16#88#,16#3b#)),
		((16#ef#,16#44#,16#a5#,16#41#),(16#a8#,16#52#,16#5b#,16#7f#),(16#b6#,16#71#,16#25#,16#3b#),(16#db#,16#0b#,16#ad#,16#00#)),
		((16#d4#,16#d1#,16#c6#,16#f8#),(16#7c#,16#83#,16#9d#,16#87#),(16#ca#,16#f2#,16#b8#,16#bc#),(16#11#,16#f9#,16#15#,16#bc#)),
		((16#6d#,16#88#,16#a3#,16#7a#),(16#11#,16#0b#,16#3e#,16#fd#),(16#db#,16#f9#,16#86#,16#41#),(16#ca#,16#00#,16#93#,16#fd#)),
		((16#4e#,16#54#,16#f7#,16#0e#),(16#5f#,16#5f#,16#c9#,16#f3#),(16#84#,16#a6#,16#4f#,16#b2#),(16#4e#,16#a6#,16#dc#,16#4f#)),
		((16#ea#,16#d2#,16#73#,16#21#),(16#b5#,16#8d#,16#ba#,16#d2#),(16#31#,16#2b#,16#f5#,16#60#),(16#7f#,16#8d#,16#29#,16#2f#)),
		((16#ac#,16#77#,16#66#,16#f3#),(16#19#,16#fa#,16#dc#,16#21#),(16#28#,16#d1#,16#29#,16#41#),(16#57#,16#5c#,16#00#,16#6e#)),
		((16#d0#,16#14#,16#f9#,16#a8#),(16#c9#,16#ee#,16#25#,16#89#),(16#e1#,16#3f#,16#0c#,16#c8#),(16#b6#,16#63#,16#0c#,16#a6#)));
   Rounds : constant Integer := 10;
   Plain_Block : constant Block_Matrix := ((16#52#,16#65#,16#73#,16#74#),
                                           (16#6f#,16#20#,16#65#,16#6e#),
                                           (16#20#,16#76#,16#69#,16#6c#),
                                           (16#6c#,16#65#,16#20#,16#3f#));

   Cipher_Block : Block_Matrix;
   Mix_Block : Block_Matrix;

begin
   Cipher_Block := AES_Encryption(Entry_Block => Plain_Block,
                                  Keys        => Keys,
                                  Rounds      => Rounds);
   Mix_Block := MixColumns(Entry_Block => ((16#B6#, 16#A0#, 16#3D#, 16#4D#),
                              (16#19#, 16#0C#, 16#AC#, 16#AF#),
                              (16#10#, 16#A8#, 16#33#,  16#A9#),
                              (16#7B#, 16#AA#, 16#E8#, 16#69#)));
   Put_Line("Encryption done");
   for i in Index loop
      for j in Index loop
         Put (Integer (Mix_Block (i,j)), Width => 7, Base => 16);
      end loop;
      Put_Line("");
   end loop;
   Put_Line("");
   for i in Index loop
      for j in Index loop
         Put (Integer (Cipher_Block (i,j)), Width => 7, Base => 16);
      end loop;
      Put_Line("");
   end loop;
   Put_Line("");
end Main;
