with AES; use AES;
package Command_Functions with SPARK_Mode is

   procedure Encrypt
     (Text_File : in String;
      IV_File : in String;
      mode : in String;
      Rounds : in Positive;
      Keys : in Key_Table);

   procedure Decrypt
     (Text_File : in String;
      IV_File : in String;
      mode : in String;
      Rounds : in Positive;
      Keys : in Key_Table);

end Command_Functions;

