library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller is
    port(
        in_clk : in std_logic;
	    controller_clk : out std_logic;
        latch : out std_logic;
        data : in std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end controller;


architecture synth of controller is

signal NESclk : std_logic;
signal NEScount : unsigned (8 downto 0);
signal counter : unsigned(20 downto 0);
signal temp : std_logic_vector (7 downto 0);
signal temp_two : std_logic_vector (7 downto 0);

begin


    process (in_clk) begin
        if rising_edge(in_clk) then
            counter <= counter + 1;
			if (counter > 21d"1201923") then
				counter <= 21d"0";
			end if;
        end if;
    end process;

    process (controller_clk) begin
        if rising_edge(controller_clk) then
            -- shift register to store data vals
            temp(7) <= temp(6);
            temp(6) <= temp(5);
            temp(5) <= temp(4);
            temp(4) <= temp(3);
            temp(3) <= temp(2);
            temp(2) <= temp(1);
            temp(1) <= temp(0);
            temp(0) <= not data;
        end if;
	end process;
	
	process(counter(20)) begin
	
	if(rising_edge(counter(20))) then
		if (temp_two = temp) then
			result <= temp;
		else
			temp_two <= temp;
		end if;
	end if;
	
    end process;
	
    NEScount <= counter(17 downto 9);
	NESclk <= counter(8);
	latch <= '1' when (NEScount = "111111111") else '0';
	controller_clk <= NESclk when (NEScount < 0x"08") else '0';

end synth;