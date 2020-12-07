-- mips_tb.vhd

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use ieee.std_logic_unsigned.all ;
use ieee.std_logic_arith.all ;

entity mips_tb is 
end entity;

architecture test of mips_tb is 

	component mips 
	port (
		clk, reset				: in  STD_LOGIC;
		writedata, dataadr	: out STD_LOGIC_VECTOR(31 downto 0);
		memwrite					: out	STD_LOGIC;
		clk_out					: out STD_LOGIC
	);
	end component;
	
	signal clk_tb, reset_tb 			: STD_LOGIC;
	signal memwrite_tb, clk_out_tb	: STD_LOGIC;
	signal writedata_tb, dataadr_tb	: STD_LOGIC_VECTOR(31 downto 0);
	
begin
	-- Instantiate the DUT
	DUT: mips port map (clk_tb, reset_tb, writedata_tb, dataadr_tb, memwrite_tb, clk_out_tb);

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
		wait for 40ns;
		reset_tb <= '0';
		wait;
	end process;
	
	prog_check:		-- check that 7 gets written to address 84 at end of program
	process (clk_tb) begin
		if (clk_tb'event and clk_tb = '0' and memwrite_tb = '1') then
			if (conv_integer(dataadr_tb) = 84 and conv_integer(writedata_tb) = 7) then 
				report "NO ERRORS: Simulation succeeded" severity failure;
			elsif (dataadr_tb /= 80) then 
				report "Simulation failed" severity failure;
			end if;
		end if;
	end process;
	
end architecture;