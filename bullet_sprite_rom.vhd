library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bullet_sprite_rom is
  port(
    clk : in std_logic;
    xaddr : in unsigned(1 downto 0);
    yaddr : in unsigned(3 downto 0);
	rgb : out std_logic_vector(5 downto 0)
  );
end bullet_sprite_rom;

architecture synth of bullet_sprite_rom is
    signal addr : std_logic_vector(5 downto 0);         
    begin
        process(clk) is begin
            if rising_edge(clk) then
                case addr is
                    when "000000" => rgb <= "111111";
					when "000001" => rgb <= "111111";
					when "000010" => rgb <= "111111";
					when "000100" => rgb <= "111111";
					when "000101" => rgb <= "111111";
					when "000110" => rgb <= "111111";
					when "001000" => rgb <= "111111";
					when "001001" => rgb <= "111111";
					when "001010" => rgb <= "111111";
					when "001100" => rgb <= "111111";
					when "001101" => rgb <= "111111";
					when "001110" => rgb <= "111111";
					when "010000" => rgb <= "111111";
					when "010001" => rgb <= "111111";
					when "010010" => rgb <= "111111";
					when "010100" => rgb <= "111111";
					when "010101" => rgb <= "111111";
					when "010110" => rgb <= "111111";
					when "011000" => rgb <= "111111";
					when "011001" => rgb <= "111111";
					when "011010" => rgb <= "111111";
					when "011100" => rgb <= "111111";
					when "011101" => rgb <= "111111";
					when "011110" => rgb <= "111111";
					when "100000" => rgb <= "111111";
					when "100001" => rgb <= "111111";
					when "100010" => rgb <= "111111";
					when "100100" => rgb <= "111111";
					when "100101" => rgb <= "111111";
					when "100110" => rgb <= "111111";
					when "101000" => rgb <= "111111";
					when "101001" => rgb <= "111111";
					when "101010" => rgb <= "111111";
					when "101100" => rgb <= "111111";
					when "101101" => rgb <= "111111";
					when "101110" => rgb <= "111111";
					when others => rgb <= "000000";
                end case;
            end if;
        end process;   
        addr <=  std_logic_vector(yaddr) & std_logic_vector(xaddr);   
    end;