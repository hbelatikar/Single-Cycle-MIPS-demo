----------------------------------------------------------------------------------------------
-------------- MAIN CONTROL DECODER (maindec) ------------------------------------------------
----------------------------------------------------------------------------------------------

	library IEEE; 
	use IEEE.STD_LOGIC_1164.all;

	entity maindec is -- main control decoder
		port(
			op						: in  STD_LOGIC_VECTOR(5 downto 0);
			memtoreg, memwrite: out STD_LOGIC;
			branch, alusrc		: out STD_LOGIC;
			regdst, regwrite	: out STD_LOGIC;
			jump					: out STD_LOGIC;
			aluop					: out STD_LOGIC_VECTOR(1 downto 0)
		);
	end;

	architecture behave of maindec is
		signal controls: STD_LOGIC_VECTOR(8 downto 0);
	begin
		process(all) 
		begin
			case op is
				when "000000" => controls <= "110000010"; -- RTYPE
				when "100011" => controls <= "101001000"; -- LW
				when "101011" => controls <= "001010000"; -- SW
				when "000100" => controls <= "000100001"; -- BEQ
				when "001000" => controls <= "101000000"; -- ADDI
				when "000010" => controls <= "000000100"; -- J
				when others   => controls <= "---------"; -- illegal op
			end case;
		end process;

		(regwrite, regdst, alusrc, branch, memwrite, memtoreg, jump ) <= controls (8 downto 2 );

		aluop(1 downto 0) <= controls(1 downto 0);

	end;

----------------------------------------------------------------------------------------------
-------------- ALU CONTROL DECODER (aludec) --------------------------------------------------
----------------------------------------------------------------------------------------------

  library IEEE; use IEEE.STD_LOGIC_1164.all;

	entity aludec is -- ALU control decoder
	port(
		funct:      in  STD_LOGIC_VECTOR(5 downto 0);
		aluop:      in  STD_LOGIC_VECTOR(1 downto 0);
		alucontrol: out STD_LOGIC_VECTOR(2 downto 0)
	);
	end;

  architecture behave of aludec is
  begin
    process(all) begin
      case aluop is
        when "00" => alucontrol <= "010"; 							-- add (for lw/sw/addi)
        when "01" => alucontrol <= "110"; 							-- sub (for beq)
        when others => case funct is      							-- R-type instructions
                        when "100000" => alucontrol <= "010"; 		-- add 
                        when "100010" => alucontrol <= "110"; 		-- sub
                        when "100100" => alucontrol <= "000"; 		-- and
                        when "100101" => alucontrol <= "001"; 		-- or
                        when "101010" => alucontrol <= "111"; 		-- slt
                        when others   => alucontrol <= "---"; 		-- ???
                      end case;
      end case;
    end process;
  end;
