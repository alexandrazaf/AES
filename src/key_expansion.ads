with AES; use AES;
with Interfaces; use Interfaces;
package Key_Expansion with SPARK_Mode is

   type Byte_Vector is array (Natural range <>) of Unsigned_8;

   type Word_Vector is array (Natural range <>) of Unsigned_32;

   function Key_Expansion_Schedule
     (Key : Word_Vector;
      Key_Length : Positive;
      RKey : Positive) return Key_Table;

   function SubWord
     (Word : Unsigned_32) return Unsigned_32;

   function RotWord
     (Word : Unsigned_32) return Unsigned_32;

   function To_Byte_Vector
     (Word : Unsigned_32) return Byte_Vector;

   function To_Word
     (Vector : Byte_Vector) return Unsigned_32;



end Key_Expansion;
