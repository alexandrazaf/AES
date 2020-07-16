
package body Key_Expansion with SPARK_Mode is

   function Key_Expansion_Schedule
     (Key : Word_Vector;
      Key_Length : Positive; -- Key_Length = 4, 6 ou 8 mots de 32 bits
      RKey : Positive) return Key_Table -- RKey = le nombre de clés dont on a besoin
   is
      Rcon_counter : Integer := 1;
      Rcon : constant Byte_Vector := ( 16#8d#, 16#01#, 16#02#, 16#04#, 16#08#, 16#10#, 16#20#, 16#40#, 16#80#, 16#1b#, 16#36#, 16#6c#, 16#d8#, 16#ab#, 16#4d#, 16#9a#,
                                       16#2f#, 16#5e#, 16#bc#, 16#63#, 16#c6#, 16#97#, 16#35#, 16#6a#, 16#d4#, 16#b3#, 16#7d#, 16#fa#, 16#ef#, 16#c5#, 16#91#, 16#39#,
                                       16#72#, 16#e4#, 16#d3#, 16#bd#, 16#61#, 16#c2#, 16#9f#, 16#25#, 16#4a#, 16#94#, 16#33#, 16#66#, 16#cc#, 16#83#, 16#1d#, 16#3a#,
                                       16#74#, 16#e8#, 16#cb#, 16#8d#, 16#01#, 16#02#, 16#04#, 16#08#, 16#10#, 16#20#, 16#40#, 16#80#, 16#1b#, 16#36#, 16#6c#, 16#d8#,
                                       16#ab#, 16#4d#, 16#9a#, 16#2f#, 16#5e#, 16#bc#, 16#63#, 16#c6#, 16#97#, 16#35#, 16#6a#, 16#d4#, 16#b3#, 16#7d#, 16#fa#, 16#ef#,
                                       16#c5#, 16#91#, 16#39#, 16#72#, 16#e4#, 16#d3#, 16#bd#, 16#61#, 16#c2#, 16#9f#, 16#25#, 16#4a#, 16#94#, 16#33#, 16#66#, 16#cc#,
                                       16#83#, 16#1d#, 16#3a#, 16#74#, 16#e8#, 16#cb#, 16#8d#, 16#01#, 16#02#, 16#04#, 16#08#, 16#10#, 16#20#, 16#40#, 16#80#, 16#1b#,
                                       16#36#, 16#6c#, 16#d8#, 16#ab#, 16#4d#, 16#9a#, 16#2f#, 16#5e#, 16#bc#, 16#63#, 16#c6#, 16#97#, 16#35#, 16#6a#, 16#d4#, 16#b3#,
                                       16#7d#, 16#fa#, 16#ef#, 16#c5#, 16#91#, 16#39#, 16#72#, 16#e4#, 16#d3#, 16#bd#, 16#61#, 16#c2#, 16#9f#, 16#25#, 16#4a#, 16#94#,
                                       16#33#, 16#66#, 16#cc#, 16#83#, 16#1d#, 16#3a#, 16#74#, 16#e8#, 16#cb#, 16#8d#, 16#01#, 16#02#, 16#04#, 16#08#, 16#10#, 16#20#,
                                       16#40#, 16#80#, 16#1b#, 16#36#, 16#6c#, 16#d8#, 16#ab#, 16#4d#, 16#9a#, 16#2f#, 16#5e#, 16#bc#, 16#63#, 16#c6#, 16#97#, 16#35#,
                                       16#6a#, 16#d4#, 16#b3#, 16#7d#, 16#fa#, 16#ef#, 16#c5#, 16#91#, 16#39#, 16#72#, 16#e4#, 16#d3#, 16#bd#, 16#61#, 16#c2#, 16#9f#,
                                       16#25#, 16#4a#, 16#94#, 16#33#, 16#66#, 16#cc#, 16#83#, 16#1d#, 16#3a#, 16#74#, 16#e8#, 16#cb#, 16#8d#, 16#01#, 16#02#, 16#04#,
                                       16#08#, 16#10#, 16#20#, 16#40#, 16#80#, 16#1b#, 16#36#, 16#6c#, 16#d8#, 16#ab#, 16#4d#, 16#9a#, 16#2f#, 16#5e#, 16#bc#, 16#63#,
                                       16#c6#, 16#97#, 16#35#, 16#6a#, 16#d4#, 16#b3#, 16#7d#, 16#fa#, 16#ef#, 16#c5#, 16#91#, 16#39#, 16#72#, 16#e4#, 16#d3#, 16#bd#,
                                       16#61#, 16#c2#, 16#9f#, 16#25#, 16#4a#, 16#94#, 16#33#, 16#66#, 16#cc#, 16#83#, 16#1d#, 16#3a#, 16#74#, 16#e8#, 16#cb# );
      Keys : Key_Table (0..RKey-1);
      Key_schedule : Word_Vector (0..4*RKey-1);
      Vector : Byte_Vector (0..3);

   begin

      -- algorithme d'expansion de la clé (cf wikipedia)
      for i in 0..4*RKey-1 loop
         if i < Key_Length then
            Key_schedule (i) := Key (i);
         elsif i mod Key_Length = 0 then
            Key_schedule (i) := Key_schedule (i - Key_Length)
              xor SubWord (RotWord (Key_schedule (i-1)))
              xor Shift_Left ( Unsigned_32 (Rcon (Rcon_counter)), 24);
            Rcon_counter := Rcon_counter + 1;
         elsif Key_Length > 6 and i mod Key_Length = 4 then
            Key_schedule (i) := Key_schedule (i - Key_Length) xor SubWord (Key_schedule (i-1));
         else
            Key_schedule (i) := Key_schedule (i - Key_Length) xor Key_schedule (i-1);

         end if;
      end loop;

      -- conversion du format tableau de mots de 32 bits vers tableau de matrices 4x4 de 8 bits
      for k in 0..RKey-1 loop
         for line in Index loop
            Vector := To_Byte_Vector (Key_schedule (4*k + Integer(line)));
            for col in Index loop
               Keys (k) (line, col) := Vector (Natural (col));
            end loop;
         end loop;
      end loop;

      return Keys;

   end Key_Expansion_Schedule;

   -- Rotation d'un octet vers la droite
   function RotWord
     (Word : Unsigned_32) return Unsigned_32
   is
   begin
      return Rotate_Left (Word, 8);
   end RotWord;

   -- Convertit un mot de 32 bits en un tableau de 4 octets
   function To_Byte_Vector
     (Word : Unsigned_32) return Byte_Vector
   is
      Vector : Byte_Vector (0..3) := (0, 0, 0, 0);
      LowHalf : Unsigned_16;
      HighHalf : Unsigned_16;

   begin
      LowHalf := Unsigned_16 (Word and 16#FFFF#);
      HighHalf := Unsigned_16 (Shift_Right(Word, 16) and 16#FFFF#);

      Vector (0) := Unsigned_8 (Shift_Right(HighHalf, 8) and 16#FF#);
      Vector (1) := Unsigned_8 (HighHalf and 16#FF#);
      Vector (2) := Unsigned_8 (Shift_Right(LowHalf, 8) and 16#FF#);
      Vector (3) := Unsigned_8 (LowHalf and 16#FF#);

      return Vector;
   end To_Byte_Vector;

   -- Convertit un tableau de 4 octets en un mot de 32 bits
   function To_Word
     (Vector : Byte_Vector) return Unsigned_32
   is
      Word : Unsigned_32;
   begin
      Word := Unsigned_32 (Vector(3)) or
        Shift_Left(Unsigned_32 (Vector(2)), 8) or
        Shift_Left(Unsigned_32 (Vector(1)), 16) or
        Shift_Left(Unsigned_32 (Vector(0)), 24);
      return Word;
   end To_Word;

   -- Opération SubBytes sur un mot de 32 bits
   function SubWord
     (Word : Unsigned_32) return Unsigned_32
   is
      Result : Unsigned_32;
      Vector : Byte_Vector (0..3);
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
      Vector := To_Byte_Vector(Word);
      for i in Vector'Range loop
         Vector (i) := SBox (Integer (Vector (i)));
      end loop;
      Result := To_Word (Vector);
      return Result;
      end SubWord;


end Key_Expansion;
