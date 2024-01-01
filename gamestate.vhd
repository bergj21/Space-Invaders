library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gamestate is
    port(
	gamestate_clk         : in std_logic;
	controller_data       : in std_logic_vector (7 downto 0);
	gameover			  : in std_logic;
	win					  : in std_logic;
	reset 				  : out std_logic;
	curr_gamestate		  : out unsigned (1 downto 0)
    );
end gamestate;


architecture synth of gamestate is

signal cooldown_clk : unsigned (15 downto 0);
signal cooldown_init : unsigned (15 downto 0);

begin  

process (gamestate_clk) begin
	if (rising_edge(gamestate_clk)) then
		-- cooldown clock to make it seem like just pressing button once only does
		-- one thing, doesnt swap back and forth between states super quickly
		if (cooldown_clk > 0) then
			cooldown_clk <= cooldown_clk - 1;
		end if;

		if (reset = '1') then
			reset <= '0';
		end if;

		-- start button is pressed while game is not in play
		if (curr_gamestate = "00" and controller_data(4) = '1' and cooldown_clk = 0) then
			reset <= '1';
			curr_gamestate <= "01";
			cooldown_clk <= cooldown_init;
		end if;
		
		-- We are currently playing the game.
		if (curr_gamestate = "01") then
			if (gameover = '1' and win = '0') then -- If we lose, go to the lose state
				curr_gamestate <= "11";
				cooldown_clk <= cooldown_init;
			elsif (gameover = '0' and win = '1') then -- If we win, go to the win state
				curr_gamestate <= "10";
				cooldown_clk <= cooldown_init;
			elsif (controller_data(4) = '1' and cooldown_clk = 0) then -- If the start button is pressed, go to start screen
				curr_gamestate <= "00";
				cooldown_clk <= cooldown_init;
			else -- No win or lose, stay in the playing state
				curr_gamestate <= "01";
			end if;
		end if;


		-- game is in play and gameover flag is thrown
		-- if (curr_gamestate = "01") then
		-- 	if (gameover = '1' and win = '1') then
		-- 		curr_gamestate <= "10";
		-- 		cooldown_clk <= cooldown_init;
		-- 	elsif (gameover = '1' and win = '0') then
		-- 		curr_gamestate <= "11";
		-- 		cooldown_clk <= cooldown_init;
		-- 	elsif (controller_data(4) = '1' and cooldown_clk = 0) then
		-- 		curr_gamestate <= "00";
		-- 		cooldown_clk <= cooldown_init;
		-- 	end if;
		-- end if;

		-- If we won or lost the game and the start button is pressed, go to start screen.
		if ((curr_gamestate = "10" or curr_gamestate = "11") and controller_data(4) = '1' and cooldown_clk = 0) then
			curr_gamestate <= "00";
			cooldown_clk <= cooldown_init;
		end if;
	end if;
	
	cooldown_init <= 16d"1000";
end process;

end synth;