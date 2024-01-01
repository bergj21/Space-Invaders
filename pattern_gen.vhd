library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is
	port (
		clk : in std_logic;
		valid : in std_logic;
		
		-- row and col that the vga is looking for
		row : in unsigned(9 downto 0);
		col : in unsigned(9 downto 0);
		
		-- output val
		rgb : out std_logic_vector(5 downto 0);
		
		-- Player position, given as input
		player_x : in unsigned(9 downto 0);
		player_y : in unsigned(9 downto 0);
		
		-- Position of all of the aliens, given as input.
		aliens  : in std_logic_vector (19 downto 0);
		alien_x : in unsigned(9 downto 0);
		alien_y : in unsigned(9 downto 0);
		
		-- Bullet position
		bullet_x : in unsigned(9 downto 0);
		bullet_y : in unsigned(9 downto 0);
		bullet_valid : in std_logic;
		
		game_state : in unsigned (1 downto 0)
	);
end pattern_gen;

architecture synth of pattern_gen is

-- Output Color
signal output : std_logic_vector(5 downto 0);

-- start screen constants
signal startscreen_x_diff : unsigned (9 downto 0);
signal startscreen_y_diff : unsigned (9 downto 0);
signal startscreen_pixel  : std_logic_vector(5 downto 0);
signal drawing_startscreen : std_logic;
signal startscreen_output : std_logic_vector(5 downto 0);

-- gameover screen constants
signal gameover_x_diff : unsigned (9 downto 0);
signal gameover_y_diff : unsigned (9 downto 0);
signal gameover_pixel  : std_logic_vector(5 downto 0);
signal drawing_gameover : std_logic;
signal gameover_output : std_logic_vector(5 downto 0);

-- win screen constants
signal winscreen_x_diff : unsigned (9 downto 0);
signal winscreen_y_diff : unsigned (9 downto 0);
signal winscreen_pixel  : std_logic_vector(5 downto 0);
signal drawing_winscreen : std_logic;
signal winscreen_output : std_logic_vector(5 downto 0);

-- Player Constants
signal player_width : unsigned(3 downto 0);
signal player_height : unsigned(3 downto 0);
signal alien_x_offset : unsigned(9 downto 0);
signal alien_y_offset : unsigned(9 downto 0);

-- Player0
signal drawing_player : std_logic;
signal player_pixel : std_logic_vector(5 downto 0);
signal player_diff_x : unsigned(9 downto 0);
signal player_diff_y : unsigned(9 downto 0);

-- Bullet Constants
signal bullet_width : unsigned(1 downto 0);
signal bullet_height : unsigned(3 downto 0);

-- Bullet
signal drawing_bullet : std_logic;
signal bullet_pixel : std_logic_vector(5 downto 0);
signal bullet_diff_x : unsigned(9 downto 0);
signal bullet_diff_y : unsigned(9 downto 0);

-- Alien Constants
signal alien_width : unsigned(3 downto 0);
signal alien_height : unsigned(3 downto 0);
signal alien_diff_x : unsigned(9 downto 0);
signal alien_diff_y : unsigned(9 downto 0);

-- Alien 1
signal drawing_alien1 : std_logic;
signal alien1_pixel : std_logic_vector(5 downto 0);

-- Alien 2
signal alien2_diff_x : unsigned(9 downto 0);
signal drawing_alien2 : std_logic;
signal alien2_pixel : std_logic_vector(5 downto 0);

-- Alien 3
signal alien3_diff_x : unsigned(9 downto 0);
signal drawing_alien3 : std_logic;
signal alien3_pixel : std_logic_vector(5 downto 0);

-- Alien 4
signal alien4_diff_x : unsigned(9 downto 0);
signal drawing_alien4 : std_logic;
signal alien4_pixel : std_logic_vector(5 downto 0);

-- Alien 5
signal alien5_diff_x : unsigned(9 downto 0);
signal drawing_alien5 : std_logic;
signal alien5_pixel : std_logic_vector(5 downto 0);

-- Alien 6
signal alien6_diff_x : unsigned(9 downto 0);
signal drawing_alien6 : std_logic;
signal alien6_pixel : std_logic_vector(5 downto 0);

-- Alien 7
signal alien7_diff_x : unsigned(9 downto 0);
signal drawing_alien7 : std_logic;
signal alien7_pixel : std_logic_vector(5 downto 0);

-- Alien 8
signal alien8_diff_x : unsigned(9 downto 0);
signal drawing_alien8 : std_logic;
signal alien8_pixel : std_logic_vector(5 downto 0);

-- Alien 9
signal alien9_diff_x : unsigned(9 downto 0);
signal drawing_alien9 : std_logic;
signal alien9_pixel : std_logic_vector(5 downto 0);

-- Alien 10
signal alien10_diff_x : unsigned(9 downto 0);
signal drawing_alien10 : std_logic;
signal alien10_pixel : std_logic_vector(5 downto 0);

-- Alien 11
signal alien11_diff_y : unsigned(9 downto 0);
signal drawing_alien11 : std_logic;
signal alien11_pixel : std_logic_vector(5 downto 0);

-- Alien 12
signal drawing_alien12 : std_logic;
signal alien12_pixel : std_logic_vector(5 downto 0);

-- Alien 13
signal drawing_alien13 : std_logic;
signal alien13_pixel : std_logic_vector(5 downto 0);

-- Alien 14
signal drawing_alien14 : std_logic;
signal alien14_pixel : std_logic_vector(5 downto 0);

-- Alien 15
signal drawing_alien15 : std_logic;
signal alien15_pixel : std_logic_vector(5 downto 0);

-- Alien 16
signal drawing_alien16 : std_logic;
signal alien16_pixel : std_logic_vector(5 downto 0);

-- Alien 17
signal drawing_alien17 : std_logic;
signal alien17_pixel : std_logic_vector(5 downto 0);

-- Alien 18
signal drawing_alien18 : std_logic;
signal alien18_pixel : std_logic_vector(5 downto 0);

-- Alien 19
signal drawing_alien19 : std_logic;
signal alien19_pixel : std_logic_vector(5 downto 0);

-- Alien 20
signal drawing_alien20 : std_logic;
signal alien20_pixel : std_logic_vector(5 downto 0);

component player_sprite is
	port(
		clk : in std_logic;
		xaddr : in unsigned(3 downto 0);
		yaddr : in unsigned(3 downto 0);
		rgb : out std_logic_vector(5 downto 0)
	);
end component;

component alien_sprite is
	port(
		clk : in std_logic;
		xaddr : in unsigned(3 downto 0);
		yaddr : in unsigned(3 downto 0);
		rgb : out std_logic_vector(5 downto 0)
	);
end component;

component alien2_sprite is
	port(
		clk : in std_logic;
		xaddr : in unsigned(3 downto 0);
		yaddr : in unsigned(3 downto 0);
		rgb : out std_logic_vector(5 downto 0)
	);
end component;

component bullet_sprite_rom is
	port(
		clk : in std_logic;
		xaddr : in unsigned(1 downto 0);
		yaddr : in unsigned(3 downto 0);
		rgb : out std_logic_vector(5 downto 0)
	);
end component;

component startscreen_background_rom is
  port(
		clk : in std_logic;
		xaddr : in unsigned(8 downto 0);
		yaddr : in unsigned(7 downto 0);
		rgb : out std_logic_vector(5 downto 0)
  );
end component;
	
component gameover_background is
  port(
    	clk : in std_logic;
   	 	xaddr : in unsigned(8 downto 0);
    	yaddr : in unsigned(5 downto 0);
		rgb : out std_logic_vector(5 downto 0)
  );
end component;

component win_background_rom is
  port(
		clk : in std_logic;
		xaddr : in unsigned(8 downto 0);
		yaddr : in unsigned(7 downto 0);
		rgb : out std_logic_vector(5 downto 0)
  );
end component;

begin
	start : startscreen_background_rom port map (
		clk => clk,
		xaddr => startscreen_x_diff(8 downto 0),
		yaddr => startscreen_y_diff(7 downto 0),
		rgb => startscreen_pixel
	);

	over : gameover_background port map (
		clk => clk,
		xaddr => gameover_x_diff(8 downto 0),
		yaddr => gameover_y_diff(5 downto 0),
		rgb => gameover_pixel
	);
	
	win : win_background_rom port map (
		clk => clk,
		xaddr => winscreen_x_diff(8 downto 0),
		yaddr => winscreen_y_diff(7 downto 0),
		rgb => winscreen_pixel
	);

	player_sprite_map : player_sprite port map (
		clk => clk,
		xaddr => player_diff_x(3 downto 0),
		yaddr => player_diff_y(3 downto 0),
		rgb => player_pixel
	);

	bullet_sprite_map : bullet_sprite_rom port map (
		clk => clk,
		xaddr => bullet_diff_x(1 downto 0),
		yaddr => bullet_diff_y(3 downto 0),
		rgb => bullet_pixel
	);
	
	alien1_sprite_map : alien_sprite port map (
		clk => clk,
		xaddr => alien_diff_x(3 downto 0),
		yaddr => alien_diff_y(3 downto 0),
		rgb => alien1_pixel
	);
	
	alien2_sprite_map : alien2_sprite port map (
		clk => clk,
		xaddr => alien2_diff_x(3 downto 0),
		yaddr => alien_diff_y(3 downto 0),
		rgb => alien2_pixel
	);
	
	alien3_sprite_map : alien_sprite port map (
		clk => clk,
		xaddr => alien3_diff_x(3 downto 0),
		yaddr => alien_diff_y(3 downto 0),
		rgb => alien3_pixel
	);
	
	alien4_sprite_map : alien2_sprite port map (
		clk => clk,
		xaddr => alien4_diff_x(3 downto 0),
		yaddr => alien_diff_y(3 downto 0),
		rgb => alien4_pixel
	);
	
	alien5_sprite_map : alien_sprite port map (
		clk => clk,
		xaddr => alien5_diff_x(3 downto 0),
		yaddr => alien_diff_y(3 downto 0),
		rgb => alien5_pixel
	);
	
	alien6_sprite_map : alien2_sprite port map (
		clk => clk,
		xaddr => alien6_diff_x(3 downto 0),
		yaddr => alien_diff_y(3 downto 0),
		rgb => alien6_pixel
	);
	
	alien7_sprite_map : alien_sprite port map (
		clk => clk,
		xaddr => alien7_diff_x(3 downto 0),
		yaddr => alien_diff_y(3 downto 0),
		rgb => alien7_pixel
	);
	
	alien8_sprite_map : alien2_sprite port map (
		clk => clk,
		xaddr => alien8_diff_x(3 downto 0),
		yaddr => alien_diff_y(3 downto 0),
		rgb => alien8_pixel
	);
	
	alien9_sprite_map : alien_sprite port map (
		clk => clk,
		xaddr => alien9_diff_x(3 downto 0),
		yaddr => alien_diff_y(3 downto 0),
		rgb => alien9_pixel
	);
	
	alien10_sprite_map : alien2_sprite port map (
		clk => clk,
		xaddr => alien10_diff_x(3 downto 0),
		yaddr => alien_diff_y(3 downto 0),
		rgb => alien10_pixel
	);
	
	alien11_sprite_map : alien2_sprite port map (
		clk => clk,
		xaddr => alien_diff_x(3 downto 0),
		yaddr => alien11_diff_y(3 downto 0),
		rgb => alien11_pixel
	);
	
	alien12_sprite_map : alien_sprite port map (
		clk => clk,
		xaddr => alien2_diff_x(3 downto 0),
		yaddr => alien11_diff_y(3 downto 0),
		rgb => alien12_pixel
	);
	
	alien13_sprite_map : alien2_sprite port map (
		clk => clk,
		xaddr => alien3_diff_x(3 downto 0),
		yaddr => alien11_diff_y(3 downto 0),
		rgb => alien13_pixel
	);
	
	alien14_sprite_map : alien_sprite port map (
		clk => clk,
		xaddr => alien4_diff_x(3 downto 0),
		yaddr => alien11_diff_y(3 downto 0),
		rgb => alien14_pixel
	);
	
	alien15_sprite_map : alien2_sprite port map (
		clk => clk,
		xaddr => alien5_diff_x(3 downto 0),
		yaddr => alien11_diff_y(3 downto 0),
		rgb => alien15_pixel
	);
	
	alien16_sprite_map : alien_sprite port map (
		clk => clk,
		xaddr => alien6_diff_x(3 downto 0),
		yaddr => alien11_diff_y(3 downto 0),
		rgb => alien16_pixel
	);
	
	alien17_sprite_map : alien2_sprite port map (
		clk => clk,
		xaddr => alien7_diff_x(3 downto 0),
		yaddr => alien11_diff_y(3 downto 0),
		rgb => alien17_pixel
	);
	
	alien18_sprite_map : alien_sprite port map (
		clk => clk,
		xaddr => alien8_diff_x(3 downto 0),
		yaddr => alien11_diff_y(3 downto 0),
		rgb => alien18_pixel
	);
	
	alien19_sprite_map : alien2_sprite port map (
		clk => clk,
		xaddr => alien9_diff_x(3 downto 0),
		yaddr => alien11_diff_y(3 downto 0),
		rgb => alien19_pixel
	);
	
	alien20_sprite_map : alien_sprite port map (
		clk => clk,
		xaddr => alien10_diff_x(3 downto 0),
		yaddr => alien11_diff_y(3 downto 0),
		rgb => alien20_pixel
	);

	
	player_width <= 4d"13";
	player_height <= 4d"13";
	
	bullet_width <= 2d"3";
	bullet_height <= 4d"12";
	
	alien_width <= 4d"11";
	alien_height <= 4d"8";
	
	alien_x_offset <= 10d"32";
	alien_y_offset <= 10d"29";
	
	-- Start screen disp logic --
	startscreen_x_diff <= col - 10d"160";
	startscreen_y_diff <= row - 10d"150";

	drawing_startscreen <= '1' when (col >= 10d"160" and col <= 10d"160" + 10d"320") and (row >= 10d"150" and row <= 10d"150" + 10d"180") else '0';
	
	-- game over disp logic --
	gameover_x_diff <= col - 10d"137";
	gameover_y_diff <= row - 10d"210";

	drawing_gameover <= '1' when (col >= 10d"137" and col <= 10d"137" + 10d"365") and (row >= 10d"210" and row <= 10d"210" + 10d"60") else '0';
	
	-- win screen display logic --
	winscreen_x_diff <= col - 10d"160";
	winscreen_y_diff <= row - 10d"125";
	
	drawing_winscreen <= '1' when (col >= 10d"160" and col <= 10d"160" + 10d"320") and (row >= 10d"125" and row <= 10d"125" + 10d"229") else '0';

	-- Player Display Logic --
	player_diff_x <= col - player_x;
	player_diff_y <= row - player_y;
	
	drawing_player <= '1' when (col >= player_x and col <= player_x + player_width) and (row >= player_y and row <= player_y + player_height) else '0';
	
	-- Bullet Display Logic --
	bullet_diff_x <= col - bullet_x;
	bullet_diff_y <= row - bullet_y;
	
	drawing_bullet <= '1' when (bullet_valid = '1') and (col >= bullet_x and col <= bullet_x + bullet_width) and (row >= bullet_y and row <= bullet_y + bullet_height) else '0';
	
	-- Alien Display Logic --
	alien_diff_x <= col - alien_x;
	alien_diff_y <= row - alien_y;
	
	-- Alien 1 Display Logic --
	drawing_alien1 <= '1' when (aliens(0) = '0') and (col >= alien_x and col <= alien_x + alien_width) and (row >= alien_y and row <= alien_y + alien_height) else '0';
	
	-- Alien 2 Display Logic --
	alien2_diff_x <= col - (alien_x + alien_x_offset);
	drawing_alien2 <= '1' when (aliens(1) = '0') and (col >= alien_x + alien_x_offset and col <= alien_x + alien_x_offset + alien_width) and (row >= alien_y and row <= alien_y + alien_height) else '0';
	
	-- Alien 3 Display Logic --
	alien3_diff_x <= col - (alien_x + (alien_x_offset + alien_x_offset));
	drawing_alien3 <= '1' when (aliens(2) = '0') and (col >= alien_x + (alien_x_offset + alien_x_offset) and col <= alien_x + (alien_x_offset + alien_x_offset) + alien_width) and (row >= alien_y and row <= alien_y + alien_height) else '0';
	
	-- Alien 4 Display Logic --
	alien4_diff_x <= col - (alien_x + (alien_x_offset + alien_x_offset + alien_x_offset));
	drawing_alien4 <= '1' when (aliens(3) = '0') and (col >= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset) and col <= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset) + alien_width) and (row >= alien_y and row <= alien_y + alien_height) else '0';
	
	-- Alien 5 Display Logic --
	alien5_diff_x <= col - (alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset));
	drawing_alien5 <= '1' when (aliens(4) = '0') and (col >= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) and col <= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) + alien_width) and (row >= alien_y and row <= alien_y + alien_height) else '0';
	
	-- Alien 6 Display Logic --
	alien6_diff_x <= col - (alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset));
	drawing_alien6 <= '1' when (aliens(5) = '0') and (col >= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) and col <= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) + alien_width) and (row >= alien_y and row <= alien_y + alien_height) else '0';
	
	-- Alien 7 Display Logic --
	alien7_diff_x <= col - (alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset));
	drawing_alien7 <= '1' when (aliens(6) = '0') and (col >= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) and col <= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) + alien_width) and (row >= alien_y and row <= alien_y + alien_height) else '0';
	
	-- Alien 8 Display Logic --
	alien8_diff_x <= col - (alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset));
	drawing_alien8 <= '1' when (aliens(7) = '0') and (col >= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) and col <= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) + alien_width) and (row >= alien_y and row <= alien_y + alien_height) else '0';
	
	-- Alien 9 Display Logic --
	alien9_diff_x <= col - (alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset));
	drawing_alien9 <= '1' when (aliens(8) = '0') and (col >= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) and col <= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) + alien_width) and (row >= alien_y and row <= alien_y + alien_height) else '0';
	
	-- Alien 10 Display Logic --
	alien10_diff_x <= col - (alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset));
	drawing_alien10 <= '1' when (aliens(9) = '0') and (col >= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) and col <= alien_x + (alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset + alien_x_offset) + alien_width) and (row >= alien_y and row <= alien_y + alien_height) else '0';
	
	-- Alien 11 Display Logic --
	alien11_diff_y <= row - (alien_y + alien_y_offset);
	drawing_alien11 <= '1' when (aliens(10) = '0') and (col >= alien_x and col <= alien_x + alien_width) and (row >= alien_y + alien_y_offset and row <= alien_y + alien_y_offset + alien_height) else '0';
	
	-- Alien 12 Display Logic --
	drawing_alien12 <= '1' when (aliens(11) = '0') and (col >= alien_x + alien_x_offset and col <= alien_x + alien_x_offset + alien_width) and (row >= alien_y + alien_y_offset and row <= alien_y + alien_y_offset + alien_height) else '0';
	
	-- Alien 13 Display Logic --
	drawing_alien13 <= '1' when (aliens(12) = '0') and (col >= alien_x + (alien_x_offset * 2) and col <= alien_x + (alien_x_offset * 2) + alien_width) and (row >= alien_y + alien_y_offset and row <= alien_y + alien_y_offset + alien_height) else '0';
	
	-- Alien 14 Display Logic --
	drawing_alien14 <= '1' when (aliens(13) = '0') and (col >= alien_x + (alien_x_offset * 3) and col <= alien_x + (alien_x_offset * 3) + alien_width) and (row >= alien_y + alien_y_offset and row <= alien_y + alien_y_offset + alien_height) else '0';
	
	-- Alien 15 Display Logic --
	drawing_alien15 <= '1' when (aliens(14) = '0') and (col >= alien_x + (alien_x_offset * 4) and col <= alien_x + (alien_x_offset * 4) + alien_width) and (row >= alien_y + alien_y_offset and row <= alien_y + alien_y_offset + alien_height) else '0';
	
	-- Alien 16 Display Logic --
	drawing_alien16 <= '1' when (aliens(15) = '0') and (col >= alien_x + (alien_x_offset * 5) and col <= alien_x + (alien_x_offset * 5) + alien_width) and (row >= alien_y + alien_y_offset and row <= alien_y + alien_y_offset + alien_height) else '0';
	
	-- Alien 17 Display Logic --
	drawing_alien17 <= '1' when (aliens(16) = '0') and (col >= alien_x + (alien_x_offset * 6) and col <= alien_x + (alien_x_offset * 6) + alien_width) and (row >= alien_y + alien_y_offset and row <= alien_y + alien_y_offset + alien_height) else '0';
	
	-- Alien 18 Display Logic --
	drawing_alien18 <= '1' when (aliens(17) = '0') and (col >= alien_x + (alien_x_offset * 7) and col <= alien_x + (alien_x_offset * 7) + alien_width) and (row >= alien_y + alien_y_offset and row <= alien_y + alien_y_offset + alien_height) else '0';
	
	-- Alien 19 Display Logic --
	drawing_alien19 <= '1' when (aliens(18) = '0') and (col >= alien_x + (alien_x_offset * 8) and col <= alien_x + (alien_x_offset * 8) + alien_width) and (row >= alien_y + alien_y_offset and row <= alien_y + alien_y_offset + alien_height) else '0';
	
	-- Alien 20 Display Logic --
	drawing_alien20 <= '1' when (aliens(19) = '0') and (col >= alien_x + (alien_x_offset * 9) and col <= alien_x + (alien_x_offset * 9) + alien_width) and (row >= alien_y + alien_y_offset and row <= alien_y + alien_y_offset + alien_height) else '0';
	
	
	output <= player_pixel when drawing_player else
			  bullet_pixel when drawing_bullet else
		      alien1_pixel when drawing_alien1 else
			  alien2_pixel when drawing_alien2 else
			  alien3_pixel when drawing_alien3 else
			  alien4_pixel when drawing_alien4 else
			  alien5_pixel when drawing_alien5 else
			  alien6_pixel when drawing_alien6 else
			  alien7_pixel when drawing_alien7 else
			  alien8_pixel when drawing_alien8 else
			  alien9_pixel when drawing_alien9 else
			  alien10_pixel when drawing_alien10 else
			  alien11_pixel when drawing_alien11 else
			  alien12_pixel when drawing_alien12 else
			  alien13_pixel when drawing_alien13 else
			  alien14_pixel when drawing_alien14 else
			  alien15_pixel when drawing_alien15 else
			  alien16_pixel when drawing_alien16 else
			  alien17_pixel when drawing_alien17 else
			  alien18_pixel when drawing_alien18 else
			  alien19_pixel when drawing_alien19 else
			  alien20_pixel when drawing_alien20 else 6b"0";
	
	startscreen_output <= startscreen_pixel when drawing_startscreen else 6b"0";

	gameover_output <= gameover_pixel when drawing_gameover else 6b"0";
	
	winscreen_output <= winscreen_pixel when drawing_winscreen else 6b"0";
	
	rgb <= output when (valid = '1') and (game_state = "01") else 
		   startscreen_output when (valid = '1') and (game_state = "00") else
		   winscreen_output when (valid = '1') and (game_state = "10") else
		   gameover_output when (valid = '1') and (game_state = "11")  else 6b"0";
end;