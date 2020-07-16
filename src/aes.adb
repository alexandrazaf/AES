--with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
--with Ada.Text_IO;   use Ada.Text_IO;
package body AES with SPARK_Mode is

   function AES_Encryption
     (Entry_Block : Block_Matrix;
      Keys : Key_Table;
      Rounds : Positive) return Block_Matrix
   is
      Round : Integer := 1;
      Block_State : Block_Matrix := Entry_Block;
      Subkey : Block_Matrix := Keys (0);
   begin
      -- Block_State repr�sente l'�tat du bloc en cours de chiffrement,
      -- il passe par les diff�rentes sous-fonctions de l'AES avant d'�tre retourn� comme bloc chiffr�.
      Block_State := AddRoundKey(Entry_Block => Block_State,
                                 Subkey => Subkey);

      while Round < Rounds loop
         Subkey := Keys (Round);

         Block_State := SubBytes(Block_State);
         Block_State := ShiftRows(Block_State);
         Block_State := MixColumns(Block_State);
         Block_State := AddRoundKey(Block_State, Subkey);

         Round := Round+1;

      end loop;
      Subkey := Keys (Rounds);
      Block_State := SubBytes(Block_State);
      Block_State := ShiftRows(Block_State);
      Block_State := AddRoundKey(Block_State, Subkey);

      return Block_State;
   end AES_Encryption;

   -- XOR le bloc d'entr�e avec la sous cl� correspondant au round
   function AddRoundKey
     (Entry_Block : Block_Matrix;
      Subkey : Block_Matrix)
      return Block_Matrix
   is
      Block_State : Block_Matrix;
   begin
      for i in Index loop
         for j in Index loop
            Block_State (i, j) := Entry_Block (i, j) xor Subkey (i, j);
         end loop;
      end loop;
      return Block_State;
   end AddRoundKey;

   -- Substitue les �l�ments du bloc d'entr�e par des �l�ments de la SBox
   function SubBytes
     (Entry_Block : Block_Matrix) return Block_Matrix
   is
      Block_State : Block_Matrix;
      SBox : constant Box := (
16#63#, 16#7C#, 16#77#, 16#7B#, 16#F2#, 16#6B#, 16#6F#, 16#C5#, 16#30#, 16#01#, 16#67#, 16#2B#, 16#FE#, 16#D7#, 16#AB#, 16#76#,
16#CA#, 16#82#, 16#C9#, 16#7D#, 16#FA#, 16#59#, 16#47#, 16#F0#, 16#AD#, 16#D4#, 16#A2#, 16#AF#, 16#9C#, 16#A4#, 16#72#, 16#C0#,
16#B7#, 16#FD#, 16#93#, 16#26#, 16#36#, 16#3F#, 16#F7#, 16#CC#, 16#34#, 16#A5#, 16#E5#, 16#F1#, 16#71#, 16#D8#, 16#31#, 16#15#,
16#04#, 16#C7#, 16#23#, 16#C3#, 16#18#, 16#96#, 16#05#, 16#9A#, 16#07#, 16#12#, 16#80#, 16#E2#, 16#EB#, 16#27#, 16#B2#, 16#75#,
16#09#, 16#83#, 16#2C#, 16#1A#, 16#1B#, 16#6E#, 16#5A#, 16#A0#, 16#52#, 16#3B#, 16#D6#, 16#B3#, 16#29#, 16#E3#, 16#2F#, 16#84#,
16#53#, 16#D1#, 16#00#, 16#ED#, 16#20#, 16#FC#, 16#B1#, 16#5B#, 16#6A#, 16#CB#, 16#BE#, 16#39#, 16#4A#, 16#4C#, 16#58#, 16#CF#,
16#D0#, 16#EF#, 16#AA#, 16#FB#, 16#43#, 16#4D#, 16#33#, 16#85#, 16#45#, 16#F9#, 16#02#, 16#7F#, 16#50#, 16#3C#, 16#9F#, 16#A8#,
16#51#, 16#A3#, 16#40#, 16#8F#, 16#92#, 16#9D#, 16#38#, 16#F5#, 16#BC#, 16#B6#, 16#DA#, 16#21#, 16#10#, 16#FF#, 16#F3#, 16#D2#,
16#CD#, 16#0C#, 16#13#, 16#EC#, 16#5F#, 16#97#, 16#44#, 16#17#, 16#C4#, 16#A7#, 16#7E#, 16#3D#, 16#64#, 16#5D#, 16#19#, 16#73#,
16#60#, 16#81#, 16#4F#, 16#DC#, 16#22#, 16#2A#, 16#90#, 16#88#, 16#46#, 16#EE#, 16#B8#, 16#14#, 16#DE#, 16#5E#, 16#0B#, 16#DB#,
16#E0#, 16#32#, 16#3A#, 16#0A#, 16#49#, 16#06#, 16#24#, 16#5C#, 16#C2#, 16#D3#, 16#AC#, 16#62#, 16#91#, 16#95#, 16#E4#, 16#79#,
16#E7#, 16#C8#, 16#37#, 16#6D#, 16#8D#, 16#D5#, 16#4E#, 16#A9#, 16#6C#, 16#56#, 16#F4#, 16#EA#, 16#65#, 16#7A#, 16#AE#, 16#08#,
16#BA#, 16#78#, 16#25#, 16#2E#, 16#1C#, 16#A6#, 16#B4#, 16#C6#, 16#E8#, 16#DD#, 16#74#, 16#1F#, 16#4B#, 16#BD#, 16#8B#, 16#8A#,
16#70#, 16#3E#, 16#B5#, 16#66#, 16#48#, 16#03#, 16#F6#, 16#0E#, 16#61#, 16#35#, 16#57#, 16#B9#, 16#86#, 16#C1#, 16#1D#, 16#9E#,
16#E1#, 16#F8#, 16#98#, 16#11#, 16#69#, 16#D9#, 16#8E#, 16#94#, 16#9B#, 16#1E#, 16#87#, 16#E9#, 16#CE#, 16#55#, 16#28#, 16#DF#,
16#8C#, 16#A1#, 16#89#, 16#0D#, 16#BF#, 16#E6#, 16#42#, 16#68#, 16#41#, 16#99#, 16#2D#, 16#0F#, 16#B0#, 16#54#, 16#BB#, 16#16#);
   begin
      for i in Index loop
         for j in Index loop
            Block_State (i, j) := SBox (Integer (Entry_Block (i, j)));
         end loop;
      end loop;
      return Block_State;
   end SubBytes;

   -- D�cale les �l�ments des lignes du bloc en fonction du num�ro de cette ligne
   function ShiftRows
     (Entry_Block : Block_Matrix) return Block_Matrix
   is
      Block_State : Block_Matrix;
   begin
      for i in Index loop
         for j in Index loop
            Block_State (i, j) := (Entry_Block (i, (j+i)));
         end loop;
      end loop;
      return Block_State;
   end ShiftRows;

   -- Effectue une transformation lin�raire sur les colonnes du bloc
   function MixColumns
     (Entry_Block : Block_Matrix) return Block_Matrix
   is
      Block_State : Block_Matrix;
      Mult_XOR : Block_Matrix;
      Mult2 : Block_Matrix;
      Mult3 : Block_Matrix;
      Mult1 : Block_Matrix;
      Mult1_2 : Block_Matrix;
   begin
      for i in Index loop
         for j in Index loop
            -- Multiplication par deux dans le corps de Gallois de Rijndael
            if Entry_Block (i,j) >= 2#1000_0000# then
               Mult_XOR (i,j) := 2#0001_1011#;
            else
               Mult_XOR (i,j) := 2#0000_0000#;
            end if;
            Mult2 (i,j) := Shift_Left(Value  => Entry_Block (i, j),
                                      Amount => 1) xor Mult_XOR (i, j);
         end loop;
      end loop;

      for i in Index loop
         for j in Index loop
            -- pr�calculs
            Mult3 (i,j) := Mult2 ((i+1), j) xor Entry_Block ((i+1), j); -- 3*X = 3*X xor X
            Mult1 (i,j) := Entry_Block ((i+2), j);
            Mult1_2 (i,j) := Entry_Block ((i+3), j);

            Block_State (i, j) := Mult2 (i,j) xor Mult3 (i,j) xor Mult1 (i,j) xor Mult1_2 (i,j);
         end loop;
      end loop;

      return Block_State;
   end MixColumns;

end AES;
