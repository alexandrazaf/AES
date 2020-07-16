with Interfaces; use Interfaces;
package AES with SPARK_Mode is

   type Index is mod 4 ; -- indice des matrices r�pr�sentant un bloc

   type Block_Matrix is array (Index, Index) of Unsigned_8; -- matrice 4x4 repr�sentant un bloc de 128 bits

   type Box is array (0..255) of Unsigned_8; -- tableau rep�sentant la SBox de SubBytes

   type Key_Table is array (Natural range <>) of Block_Matrix; -- tableau contenant toutes les cl�s sous forme de matrices 4x4

   function AES_Encryption
     (Entry_Block : Block_Matrix;
      Keys : Key_Table;
      Rounds : Positive) return Block_Matrix;

   function SubBytes
     (Entry_Block : Block_Matrix) return Block_Matrix;

   function ShiftRows
     (Entry_Block : Block_Matrix) return Block_Matrix;

   function MixColumns
     (Entry_Block : Block_Matrix) return Block_Matrix;

   function AddRoundKey
     (Entry_Block : Block_Matrix;
      Subkey : Block_Matrix)
      return Block_Matrix;

end AES;
