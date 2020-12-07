
----------------------------------------------------------------------------------------------
-------------- ADDER (adder) -----------------------------------------------------------------
----------------------------------------------------------------------------------------------

  library IEEE; 
  use IEEE.STD_LOGIC_1164.all; 
  --use IEEE.NUMERIC_STD_UNSIGNED.all;
  use ieee.std_logic_unsigned.all ;
  use ieee.std_logic_arith.all ;

  entity adder is -- adder
    port(a, b: in  STD_LOGIC_VECTOR(31 downto 0);
        y:    out STD_LOGIC_VECTOR(31 downto 0));
  end;

  architecture behave of adder is
  begin
    y <= a + b;
  end;

----------------------------------------------------------------------------------------------
-------------- LEFT SHIFT BY 2 (s12) ---------------------------------------------------------
----------------------------------------------------------------------------------------------

  library IEEE; use IEEE.STD_LOGIC_1164.all;

  entity sl2 is -- shift left by 2
    port(a: in  STD_LOGIC_VECTOR(31 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0));
  end;

  architecture behave of sl2 is
  begin
    y <= a(29 downto 0) & "00";
  end;

----------------------------------------------------------------------------------------------
-------------- SIGN EXTENDER (signext) -------------------------------------------------------
----------------------------------------------------------------------------------------------

  library IEEE; 
  use IEEE.STD_LOGIC_1164.all;

  entity signext is -- sign extender
    port(a: in  STD_LOGIC_VECTOR(15 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0));
  end;

  architecture behave of signext is
  begin
    y <= X"ffff" & a when a(15) else X"0000" & a; 
  end;

----------------------------------------------------------------------------------------------
-------------- SYNC RST FLIP FLOP (flopr) ----------------------------------------------------
----------------------------------------------------------------------------------------------

  library IEEE; use IEEE.STD_LOGIC_1164.all;  
  use IEEE.STD_LOGIC_ARITH.all;

  entity flopr is -- flip-flop with synchronous reset
    generic(width: integer);
    port(clk, 
         reset:      in  STD_LOGIC;
         d:          in  STD_LOGIC_VECTOR(width-1 downto 0);
         q:          out STD_LOGIC_VECTOR(width-1 downto 0));
  end;

  architecture asynchronous of flopr is
  begin
    process(clk, reset) begin
      if reset then  q <= (others => '0');
      elsif rising_edge(clk) then
        q <= d;
      end if;
    end process;
  end;

----------------------------------------------------------------------------------------------
-------------- 2 - INPUT MUX (mux2) ----------------------------------------------------------
----------------------------------------------------------------------------------------------

  library IEEE;
  use IEEE.STD_LOGIC_1164.all;

  entity mux2 is -- two-input multiplexer
    generic(width: integer);
    port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
         s:      in  STD_LOGIC;
         y:      out STD_LOGIC_VECTOR(width-1 downto 0));
  end;

  architecture behave of mux2 is
  begin
    y <= d1 when s else d0;
  end;

----------------------------------------------------------------------------------------------
-------------- ALU (alu) ---------------------------------------------------------------------
----------------------------------------------------------------------------------------------

  library IEEE; 
  use IEEE.STD_LOGIC_1164.all; 
  --use IEEE.NUMERIC_STD_UNSIGNED.all;
  use ieee.std_logic_unsigned.all ;
  use ieee.std_logic_arith.all ;

  entity alu is 
    port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
         alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
         result:     buffer STD_LOGIC_VECTOR(31 downto 0);
         zero:       out STD_LOGIC);
  end;

  architecture behave of alu is
    signal condinvb, sum: STD_LOGIC_VECTOR(31 downto 0);
  begin
    condinvb <= not b when alucontrol(2) else b;
    sum <= a + condinvb + alucontrol(2);

    process(all) begin
      case alucontrol(1 downto 0) is
        when "00"   => result <= a and b; 
        when "01"   => result <= a or b; 
        when "10"   => result <= sum; 
        when "11"   => result <= (0 => sum(31), others => '0'); 
        when others => result <= (others => 'X'); 
      end case;
    end process;

    zero <= '1' when result = X"00000000" else '0';
  end;
