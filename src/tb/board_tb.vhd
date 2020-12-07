-- board_tb.vhd

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use ieee.std_logic_unsigned.all ;
use ieee.std_logic_arith.all ;

entity board_tb is 
end entity;

architecture test of board_tb is 

	component board is
		port(
			clk	: in	STD_LOGIC;
			reset	: in	STD_LOGIC;
			leds	: out	STD_LOGIC_VECTOR (7 downto 0)
		);
	end component;
	
	signal clk_tb, reset_tb : STD_LOGIC;
	signal leds_tb				: STD_LOGIC_VECTOR(7 downto 0);
	
begin
	-- Instantiate the DUT
	DUT: board port map (clk_tb, reset_tb, leds_tb);

	clk_gen: 		-- Process to generate 20ns Clk cycle
	process begin	
		clk_tb <= '1';
		wait for 10ns;
		clk_tb <= '0';
		wait for 10ns;
	end process;

	init_reset:		-- Process to reset for 2 clk cycles
	process begin
		reset_tb <= '1';
		wait for 42ns;
		reset_tb <= '0';
		wait;
	end process;
	
	process begin
		wait for 1000ns;
		report "Simulation stopped" severity failure;
	end process;
	
--	prog_check:		-- check that 7 gets written to address 84 at end of program
--	process (clk_tb) begin
--		if (clk_tb'event and clk_tb = '0' and memwrite_tb = '1') then
--			if (conv_integer(dataadr_tb) = 84 and conv_integer(writedata_tb) = 7) then 
--				report "NO ERRORS: Simulation succeeded" severity failure;
--			elsif (dataadr_tb /= 80) then 
--				report "Simulation failed" severity failure;
--			end if;
--		end if;
--	end process;
	
end architecture;