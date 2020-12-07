-- board.vhd

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use ieee.std_logic_unsigned.all ;
use ieee.std_logic_arith.all ;

entity board is
	port(
		clk	: in	STD_LOGIC;
		reset	: in	STD_LOGIC;
		--switch: in	STD_LOGIC_VECTOR (7 downto 0);
		leds	: out	STD_LOGIC_VECTOR (7 downto 0)
		--leds	: out	STD_LOGIC_VECTOR (31 downto 0)
	);
end entity;

architecture board_arch of board is 
	component mips port
	(
		clk, reset				: in  STD_LOGIC;
		writedata, dataadr	: out STD_LOGIC_VECTOR(31 downto 0);
		memwrite					: out STD_LOGIC;
		readdata_out			: out STD_LOGIC_VECTOR(6 downto 0)
	);
	end component;
	
	component clk_div 
	port(
		clk, rst	: in  STD_LOGIC;
		clk_out	: out STD_LOGIC
	);
	end component;
	
	signal clk_10hz : STD_LOGIC;

begin

	clkDivide: clk_div port map (
		clk => clk,
		rst => reset,
		clk_out => clk_10hz
	);
	
	mipsProcessor: mips port map (
		--clk 		=> clk_10hz,
		clk 		=> clk,
		reset 	=> reset,
		--writedata (7 downto 0)=> leds
		readdata_out => leds ( 6 downto 0)
	);
	
	leds(7) <= clk_10hz;

end architecture;