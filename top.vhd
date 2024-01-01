library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is 
	port (
		input_clock : in std_logic; -- Input clock
		HSYNC : out std_logic; -- HSYNC to VGA
		VSYNC : out std_logic; -- VSYNC to VGA
		rgb : out std_logic_vector(5 downto 0); -- RGB output to VGA
		
		nes_clk : out std_logic;
		nes_data : in std_logic;
		nes_latch : out std_logic
	);
end top;

architecture synth of top is

component mypll is
    port(
        ref_clk_i: in std_logic; -- Input clock
        rst_n_i: in std_logic; -- Reset (active low)
        outcore_o: out std_logic; -- Output to pins
        outglobal_o: out std_logic -- Output for clock network
    );
end component;

component vga is
	port(
		clk : in std_logic; -- Clock
		valid : out std_logic; -- Bit stating whether in visible area.
		row : out unsigned(9 downto 0); -- Given row of VGA image.
		col : out unsigned(9 downto 0); -- Given col of VGA image.
		HSYNC : out std_logic; -- HSYNC to VGA.
		VSYNC : out std_logic -- VSYNC to VGA. 
	);
end component;

component pattern_gen is
	port (
		clk : in std_logic;
		valid : in std_logic; -- Valid bit for VGA.
		row : in unsigned(9 downto 0); -- Given row of VGA display.
		col : in unsigned(9 downto 0); -- Given col of VGA display.
		rgb : out std_logic_vector(5 downto 0); -- RGB color to VGA display.
		
		player_x : in unsigned(9 downto 0);
		player_y : in unsigned(9 downto 0);
		
		aliens  : in std_logic_vector (19 downto 0);
		alien_x : in unsigned(9 downto 0);
		alien_y : in unsigned(9 downto 0);
		
		bullet_x : in unsigned(9 downto 0);
		bullet_y : in unsigned(9 downto 0);
		bullet_valid : in std_logic;
		
		game_state : in unsigned (1 downto 0)
	);
end component;

component controller is 
	port(
        in_clk : in std_logic;
	    controller_clk : out std_logic;
        latch : out std_logic;
        data : in std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end component;

component game_logic is 
	port(
	    given_clk             : in std_logic;
        controller_data       : in std_logic_vector (7 downto 0);
		reset 				  : in std_logic;

        -- position data
        aliens                : out std_logic_vector (19 downto 0);
        alienx                : out unsigned (9 downto 0);
        alieny                : out unsigned (9 downto 0);
        
        playerx               : out unsigned (9 downto 0);
        playery               : out unsigned (9 downto 0);

        bulletx               : out unsigned (9 downto 0);
        bullety               : out unsigned (9 downto 0);
        bulletvalid           : out std_logic;
		
		game_over			  : out std_logic;
		win_state			  : out std_logic
    );
end component;
		
component gamestate is
    port(
		gamestate_clk         : in std_logic;
		controller_data       : in std_logic_vector (7 downto 0);
		gameover			  : in std_logic;
		win					  : in std_logic;
		reset				  : out std_logic;
		curr_gamestate		  : out unsigned (1 downto 0)
    );
end component;

signal reset_sig : std_logic;
signal outcore_o : std_logic;
signal outglobal_o : std_logic;
signal clk : std_logic;
signal valid : std_logic;
signal row : unsigned(9 downto 0);
signal col : unsigned(9 downto 0);

signal player_x : unsigned(9 downto 0);
signal player_y : unsigned(9 downto 0);

signal nes_result : std_logic_vector(7 downto 0);

signal logic_aliens       : std_logic_vector (19 downto 0);
signal logic_alienx       : unsigned (9 downto 0);
signal logic_alieny       : unsigned (9 downto 0);

signal logic_bulletx      : unsigned (9 downto 0);
signal logic_bullety      : unsigned (9 downto 0);
signal logic_bulletvalid  : std_logic;

signal logic_game_over    : std_logic;
signal state              : unsigned (1 downto 0);
signal logic_win	      : std_logic;


begin
	pll : mypll
		port map (
			ref_clk_i => input_clock,
			rst_n_i => '1',
			outcore_o => outcore_o,
			outglobal_o => outglobal_o
		);
		
	myvga : vga
		port map (
			outglobal_o,
			valid,
			row,
			col,
			HSYNC,
			VSYNC
		);
	
	my_pattern_gen : pattern_gen
		port map (
			clk => outglobal_o,
			valid => valid,
			row => row,
			col => col,
			rgb => rgb,
			player_x => player_x,
			player_y => player_y,
			aliens => logic_aliens,
			alien_x => logic_alienx,
			alien_y => logic_alieny,
			bullet_x => logic_bulletx,
			bullet_y => logic_bullety,
			bullet_valid => logic_bulletvalid,
			game_state => state
		);
		
	new_controller : controller 
		port map (
			in_clk => outglobal_o,
			controller_clk => nes_clk,
			latch => nes_latch, 
			data => nes_data,
			result => nes_result
		);
		
	space_invader_game_logic : game_logic
		port map (
			given_clk => nes_clk,
			controller_data => nes_result,
			reset => reset_sig,

			-- position data
			aliens => logic_aliens,
			alienx => logic_alienx,
			alieny => logic_alieny,
			
			playerx => player_x,
			playery => player_y,

			bulletx => logic_bulletx,
			bullety => logic_bullety,
			bulletvalid => logic_bulletvalid,
			
			game_over => logic_game_over,
			win_state => logic_win
	);
	statemachine : gamestate port map (
		gamestate_clk => nes_clk, 
		controller_data => nes_result,
		gameover => logic_game_over,
		win => logic_win,
		reset => reset_sig,
		curr_gamestate => state
	);
end;