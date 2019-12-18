library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types.all;

entity particionate is generic (
    N : natural := 2
); port (
    clk : in std_logic;
    reset : in std_logic;
    start_calculate : in std_logic;
    w : in vector_of_byte(N-1 downto 0);
    x : in vector_of_byte(N-1 downto 0);
    h : out signed(15 downto 0);
    busy : out std_logic
);
end particionate;

architecture behavior of particionate is

    signal tpm_h : signed(15 downto 0);

    signal clear_h : std_logic;
    signal enable_calc_o : std_logic;
    signal enable_output : std_logic;

    type state_t is (idle, calculate, send_output);
    
    signal next_state, this_state : state_t;
    
begin
    
    tpm_output_calc_o : process(clk, reset)
        variable h_var : integer;
        variable i : integer;
    begin
        if(reset = '1') then
            h_var := 0;
        elsif(rising_edge(clk)) then
            if (clear_h = '1') then
                h_var := 0;
            elsif(enable_calc_o = '1') then
                for i in 0 to N-1 loop
                    h_var := h_var + to_integer(w(i) * x(i));
                end loop;
            elsif (enable_output = '1') then
                h <= to_signed(h_var, 16);
            end if;
        end if;
    end process;
    
    combo_fsm : process(this_state)
    begin
        case (this_state) is
            when idle =>
                clear_h <= '0';
                enable_calc_o <= '0';
                enable_output <= '0';
                busy <= '0';
                
                if (start_calculate = '1') then
                    clear_h <= '1';
                    busy <= '1';
                    next_state <= calculate;
                else
                    next_state <= idle;
                end if;
                
            when calculate =>
                clear_h <= '0';
                enable_calc_o <= '1';
                enable_output <= '0';
                busy <= '1';
                
                next_state <= send_output;
                
            when send_output =>
                clear_h <= '0';
                enable_calc_o <= '0';
                enable_output <= '1';
                busy <= '1';
                
                next_state <= idle;
        end case;
    end process;
    
    sync_fsm : process(clk, reset)
    begin
        if (reset = '1') then
            this_state <= idle;
        elsif (rising_edge(clk)) then
            this_state <= next_state;
        end if;
    end process;

end behavior;