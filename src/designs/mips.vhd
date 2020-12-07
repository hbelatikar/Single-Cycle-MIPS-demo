-- mips.vhd

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use ieee.std_logic_unsigned.all ;
use ieee.std_logic_arith.all ;

entity mips is -- mips core + memories
  port(clk, reset				: in     STD_LOGIC;
       writedata, dataadr	: buffer STD_LOGIC_VECTOR(31 downto 0);
       memwrite				: buffer STD_LOGIC;
		 readdata_out			: out		STD_LOGIC_VECTOR(6 downto 0)
		 );
end;  -- END ENTITY mips

architecture test of mips is
	component mips_core port
	(
		clk, reset			: in  STD_LOGIC;
		pc						: out STD_LOGIC_VECTOR(31 downto 0);
		instr					: in  STD_LOGIC_VECTOR(31 downto 0);
		memwrite				: out STD_LOGIC;
		aluout, writedata	: out STD_LOGIC_VECTOR(31 downto 0);
		readdata				: in  STD_LOGIC_VECTOR(31 downto 0)
	);
	end component; --END COMPONENT mips_core

	component imem port
	(
		a :  in  STD_LOGIC_VECTOR(5 downto 0);
		rd: out STD_LOGIC_VECTOR(31 downto 0)
	);
	end component; --END COMPONENT imem

	component data_mem PORT
	(
		address	: IN  STD_LOGIC_VECTOR (5 DOWNTO 0);
		clock		: IN  STD_LOGIC  := '1';
		data		: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN  STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component; --END COMPONENT data_mem


	signal pc, instr, readdata	: STD_LOGIC_VECTOR(31 downto 0) := ( others => '0' );
	signal clk_bar 				: STD_LOGIC;

begin --begin architecture test
   
	-- instantiate processor and memories
	mips1: mips_core	port map (clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);
	imem1: imem 		port map (pc(7 downto 2), instr);
	dmem1: data_mem 	port map (dataadr(7 downto 2), clk_bar, writedata, memwrite, readdata);

	clk_bar <= not clk ;
	readdata_out <= readdata (6 downto 0);

end; -- end architecture test of mips