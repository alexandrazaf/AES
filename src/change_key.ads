with Key_Expansion; use Key_Expansion;
with AES; use AES;
package Change_Key with SPARK_Mode is

   procedure ChangeKey
     (File_Name : in String;
      Key : out Word_Vector;
      Keys : out Key_Table;
      Key_Length : out Positive);

end Change_Key;
