library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is

    type vector_of_byte is array(integer range <>) of signed(7 downto 0); -- vetor de bytes para o valor de sigma
    type matrix_of_byte is array(integer range <>, integer range <>) of signed(7 downto 0); -- matriz de bytes para os pesos e entrada
    type vector_of_word is array(integer range <>) of std_logic_vector(31 downto 0); -- vetor de 32 bits para o valor do gerador de x
    type vector_of_std_logic is array(integer range <>) of std_logic; -- vetor de std_logic para controle dos lfsrs de 32 bits
    type vector_of_half_work is array(integer range <>) of signed(15 downto 0);

end package types;