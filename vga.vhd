library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is
	port(
		clk : in std_logic;
		valid : out std_logic;
		row : out unsigned(9 downto 0);
		col : out unsigned(9 downto 0);
		HSYNC : out std_logic;
		VSYNC : out std_logic
	);
end vga;

architecture synth of vga is
	signal next_col : unsigned(9 downto 0);
	signal next_row : unsigned(9 downto 0);
	signal col_temp : unsigned(9 downto 0);
	signal row_temp : unsigned(9 downto 0);
begin
	process(clk) begin
		if rising_edge(clk) then
			if col_temp = 800 then
				col_temp <= 10b"0"; -- Reset columns to zero if out-of-bounds.
				
				if row_temp = 525 then
					row_temp <= 10b"0"; -- Reset rows to zero if out-of-bounds.
				else
					row_temp <= next_row; -- If in-bounds, increment rows.
				end if;
			else
				col_temp <= next_col; -- If in-bounds, increment columns.
			end if;
		end if;
	end process;
	
	-- Increment next column and next row -- 
	next_col <= col_temp + 1;
	next_row <= row_temp + 1;
	
	-- Set HSYNC, VSYNC, and valid based upon row and column position. -- 
	HSYNC <= '1' when col_temp < 656 or col_temp >= 752 else '0';
	VSYNC <= '1' when row_temp < 490 or row_temp >= 492 else '0';
	valid <= '1' when col_temp <= 640 and row_temp <= 480 else '0';
	
	-- Update the output to the current column and row. --
	col <= col_temp;
	row <= row_temp;
end;
