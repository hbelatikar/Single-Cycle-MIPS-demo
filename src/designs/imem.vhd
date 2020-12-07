----------------------------------------------------------------------------------------------
-------------- INSTRUCTION MEMORY (imem) -----------------------------------------------------
----------------------------------------------------------------------------------------------

  library IEEE; 
  use IEEE.STD_LOGIC_1164.all; use STD.TEXTIO.all;
  --use IEEE.NUMERIC_STD_UNSIGNED.all;  
  use ieee.std_logic_unsigned.all ;
  use ieee.std_logic_arith.all ;

  entity imem is -- instruction memory
    port(a:  in  STD_LOGIC_VECTOR(5 downto 0);
         rd: out STD_LOGIC_VECTOR(31 downto 0));
  end;  --end imem entity

  architecture behave of imem is
      type ramtype is array (0 to 63) of STD_LOGIC_VECTOR(31 downto 0);

      signal mem: ramtype := (
			--Initialize
			x"20020005" , 	-- Addi	r2, r0, "5"			--LABEL Store						[0]
			x"20030004" , 	-- Addi	r3, r0, "4"
			x"20060001" ,  -- Addi	r6, r0, "1"
			--Add Instruction
			x"00622020" , 	-- Add	r4, r2, r3			--LABEL: Repeat					[3]
			x"aC040000" , 	-- Store r4 in dmem[0+r0] 	
			--Delay loop 3s
			x"20050003" ,	-- Addi 	r5, r0, "1"
			x"10A00002" ,	-- Beq	r5, r0, 'Sub'		--LABEL: Check delay 1			[6]
			x"00A62822" ,	-- sub	r5, r5, r6
			x"08000006" ,	-- goto Check Delay 1
			--Sub Instruction			
			x"00432022" ,	-- Sub	r4, r2, r3			--Label: Sub 						[9]
			x"aC040001" ,	-- Store r4 in dmem[1+r0]
			--Delay loop 3s
			x"20050003" ,	-- Addi 	r5, r0, "1"
			x"10A00002" ,	-- Beq	r5, r0, 'And'		--LABEL: Check delay	2			[C]
			x"00A62822" ,	-- sub	r5, r5, r6
			x"0800000C" ,	-- goto Check Delay 2
			--And Instruction			
			x"00622024" ,	-- And	r4, r2, r3			--LABEL: And				 		[F]	
			x"aC040002" ,	-- Store r4 in dmem[2+r0] 
			--Delay loop 3s
			x"20050003" ,	-- Addi 	r5, r0, "1"
			x"10A00002" ,	-- Beq	r5, r0, 'Or'		--LABEL: Check delay	3			[12]
			x"00A62822" ,	-- sub	r5, r5, r6
			x"08000012" ,	-- goto Check Delay 3			
			--Or Instruction			
			x"00622025" ,	-- Or		r4, r2, r3			--LABEL: Or 						[15]	 
			x"aC040003" ,	--	Store r4 in dmem[3+r0]
			--Delay loop 3s
			x"20050003" ,	-- Addi 	r5, r0, "1"
			x"10A00002" ,	-- Beq	r5, r0, 'Label'	--LABEL: Check delay	4			[18]
			x"00A62822" ,	-- sub	r5, r5, r6
			x"08000018" ,	-- goto Check Delay 4
			
			x"08000003" ,	-- goto Repeat					--LABEL: End						[1B]
			
			x"00000000" ,	-- 
			x"00000000" ,	-- 
			x"00000000" ,	-- 
			x"00000000" ,	-- 
			x"00000000" , 				
			x"00000000" , 		x"00000000" , 		x"00000000" , 		 		
			x"00000000" , 		x"00000000" , 		x"00000000" , 		 		
			x"00000000" , 		x"00000000" , 		x"00000000" , 		 		
			x"00000000" , 		x"00000000" , 		x"00000000" , 		 		
			x"00000000" , 		x"00000000" , 		x"00000000" , 		 		
			x"00000000" , 		x"00000000" , 		x"00000000" , 		 		
			x"00000000" , 		x"00000000" , 		x"00000000" , 		 		
			x"00000000" , 		x"00000000" , 		x"00000000" , 		 		
			x"00000000" , 		x"00000000" , 		x"00000000" , 		 		
			x"00000000" , 		x"00000000" , 		x"00000000" , 		 		
			x"00000000" 
		);  -- END mem SIGNAL
--		
		
--		      signal mem: ramtype := (
--        x"20020005" ,	-- Add imm → reg2 = reg0 + "5" 
--        x"2003000c" ,	-- Add imm → reg3 = reg0 + "12"
--        x"2067fff7" ,	-- Add imm → reg7 = reg3 + "-9"
--        x"00e22025" ,	-- Or  reg → reg4 = reg2 | reg7
--        x"00642824" ,	-- And reg → reg5 = reg8 & reg3
--        x"00a42820" ,	-- Add reg → reg5 = reg4 + reg5					--LABEL ADD_HERE
--        x"10a7000a" ,	-- Beq 	  → reg7 = reg5 ? ADD_HERE : next
--        x"0064202a" ,	-- Slt 	  → reg4 = reg3 < reg4 ? 1 : 0
--        x"10800001" ,	--	Beq	  → reg7 = reg5 ? ADD_HERE : next
--        x"20050000" ,	-- Add imm → reg5 = reg0 + "0"
--        x"00e2202a" ,	-- Slt 	  → reg4 = reg7 < reg2 ? 1 : 0		--LABEL here
--        x"00853820" ,	-- Add reg → reg7 = reg4 + reg5
--        x"00e23822" ,	-- Sub reg → reg7 = reg7 - reg2
--        x"ac670044" ,	-- Str word→ dmem[reg3+"68"] = reg7
--        x"8c020050" ,	-- Ld word → reg2 = dmem[reg0+"80]
--        x"08000011" ,	-- goto here
--        x"20020001" ,	-- Add imm → reg2 = reg0 + "1"
--        x"ac020054" ,	-- Str word→ dmem[reg0+"54"] = reg2
--		  x"00000000" , 		x"00000000" , 		
--        x"00000000" , 		x"00000000" , 		x"00000000" , 		x"00000000" , 		
--        x"00000000" , 		x"00000000" , 		x"00000000" , 		x"00000000" , 		
--        x"00000000" , 		x"00000000" , 		x"00000000" , 		x"00000000" , 		
--        x"00000000" , 		x"00000000" , 		x"00000000" , 		x"00000000" , 		
--        x"00000000" , 		x"00000000" , 		x"00000000" , 		x"00000000" , 		
--        x"00000000" , 		x"00000000" , 		x"00000000" , 		x"00000000" , 		
--        x"00000000" , 		x"00000000" , 		x"00000000" , 		x"00000000" , 		
--        x"00000000" , 		x"00000000" , 		x"00000000" , 		x"00000000" , 		
--        x"00000000" , 		x"00000000" , 		x"00000000" , 		x"00000000" , 		
--        x"00000000" , 		x"00000000" , 		x"00000000" , 		x"00000000" , 		
--        x"00000000" , 		x"00000000" , 		x"00000000" , 		x"00000000"	 
--		);  --
		

  begin --BEGIN ARCHITECTURE
    process (all) 
    begin	--BEGIN process
	     rd <= mem(conv_integer(a));
    end process; --END process
  end; --END ARCHITECTURE behave OF imem
