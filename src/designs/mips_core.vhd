----------------------------------------------------------------------------------------------
-------------- SINGLE CYCLE MIPS PROCESSOR (mips_core) ---------------------------------------
----------------------------------------------------------------------------------------------

	library IEEE; 
	use IEEE.STD_LOGIC_1164.all;

 	entity mips_core is
	port(
		clk, reset			: in  STD_LOGIC;
		pc						: out STD_LOGIC_VECTOR(31 downto 0);
		instr					: in  STD_LOGIC_VECTOR(31 downto 0);
		memwrite				: out STD_LOGIC;
		aluout, writedata	: out STD_LOGIC_VECTOR(31 downto 0);
		readdata				: in  STD_LOGIC_VECTOR(31 downto 0)
		);
  end;

  architecture struct of mips_core is
    
	 component controller
      port(
			op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
			zero:               in  STD_LOGIC;
			memtoreg, memwrite: out STD_LOGIC;
			pcsrc, alusrc:      out STD_LOGIC;
			regdst, regwrite:   out STD_LOGIC;
			jump:               out STD_LOGIC;
			alucontrol:         out STD_LOGIC_VECTOR(2 downto 0)
		);
    end component;
	 
    component datapath
      port(
			clk, reset:        in  STD_LOGIC;
			memtoreg, pcsrc:   in  STD_LOGIC;
			alusrc, regdst:    in  STD_LOGIC;
			regwrite, jump:    in  STD_LOGIC;
			alucontrol:        in  STD_LOGIC_VECTOR(2 downto 0);
			zero:              out STD_LOGIC;
			pc:                buffer STD_LOGIC_VECTOR(31 downto 0);
			instr:             in STD_LOGIC_VECTOR(31 downto 0);
			aluout, writedata: buffer STD_LOGIC_VECTOR(31 downto 0);
			readdata:          in  STD_LOGIC_VECTOR(31 downto 0)
		);
    end component;
    
    signal memtoreg, alusrc, regdst, regwrite, jump, pcsrc: STD_LOGIC;
    signal zero: STD_LOGIC;
    signal alucontrol: STD_LOGIC_VECTOR(2 downto 0);

  begin
    cont: controller port map(instr(31 downto 26), instr(5 downto 0),
                              zero, memtoreg, memwrite, pcsrc, alusrc,
                              regdst, regwrite, jump, alucontrol);
										
    dp: datapath port map(clk, reset, memtoreg, pcsrc, alusrc, regdst,
                          regwrite, jump, alucontrol, zero, pc, instr,
                          aluout, writedata, readdata);
  end;
  
----------------------------------------------------------------------------------------------
-------------- SINGLE CYCLE CONTROL DECODER (controller) -------------------------------------
----------------------------------------------------------------------------------------------

  library IEEE; use IEEE.STD_LOGIC_1164.all;

  entity controller is -- single cycle control decoder
    port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
        zero:               in  STD_LOGIC;
        memtoreg, memwrite: out STD_LOGIC;
        pcsrc, alusrc:      out STD_LOGIC;
        regdst, regwrite:   out STD_LOGIC;
        jump:               out STD_LOGIC;
        alucontrol:         out STD_LOGIC_VECTOR(2 downto 0));
  end;


  architecture struct of controller is
    component maindec
      port(op:                 in  STD_LOGIC_VECTOR(5 downto 0);
          memtoreg, memwrite: out STD_LOGIC;
          branch, alusrc:     out STD_LOGIC;
          regdst, regwrite:   out STD_LOGIC;
          jump:               out STD_LOGIC;
          aluop:              out STD_LOGIC_VECTOR(1 downto 0));
    end component;
    component aludec
      port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
          aluop:      in  STD_LOGIC_VECTOR(1 downto 0);
          alucontrol: out STD_LOGIC_VECTOR(2 downto 0));
    end component;
    signal aluop:  STD_LOGIC_VECTOR(1 downto 0);
    signal branch: STD_LOGIC;
  begin
    md: maindec port map(op, memtoreg, memwrite, branch,
                        alusrc, regdst, regwrite, jump, aluop);
    ad: aludec port map(funct, aluop, alucontrol);

    pcsrc <= branch and zero;
  end;
  
----------------------------------------------------------------------------------------------
-------------- MIPS DATA PATH (datapath) -----------------------------------------------------
----------------------------------------------------------------------------------------------

  library IEEE; use IEEE.STD_LOGIC_1164.all; 
  use IEEE.STD_LOGIC_ARITH.all;

  entity datapath is  -- MIPS datapath
    port(clk, reset:        in  STD_LOGIC;
         memtoreg, pcsrc:   in  STD_LOGIC;
         alusrc, regdst:    in  STD_LOGIC;
         regwrite, jump:    in  STD_LOGIC;
         alucontrol:        in  STD_LOGIC_VECTOR(2 downto 0);
         zero:              out STD_LOGIC;
         pc:                buffer STD_LOGIC_VECTOR(31 downto 0);
         instr:             in  STD_LOGIC_VECTOR(31 downto 0);
         aluout, writedata: buffer STD_LOGIC_VECTOR(31 downto 0);
         readdata:          in  STD_LOGIC_VECTOR(31 downto 0));
  end;

  architecture struct of datapath is
    component alu
      port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
          alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
          result:     buffer STD_LOGIC_VECTOR(31 downto 0);
          zero:       out STD_LOGIC);
    end component;
    component regfile
      port(clk:           in  STD_LOGIC;
          we3:           in  STD_LOGIC;
          ra1, ra2, wa3: in  STD_LOGIC_VECTOR(4 downto 0);
          wd3:           in  STD_LOGIC_VECTOR(31 downto 0);
          rd1, rd2:      out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    component adder
      port(a, b: in  STD_LOGIC_VECTOR(31 downto 0);
          y:    out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    component sl2
      port(a: in  STD_LOGIC_VECTOR(31 downto 0);
          y: out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    component signext
      port(a: in  STD_LOGIC_VECTOR(15 downto 0);
          y: out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    component flopr generic(width: integer);
      port(clk, reset: in  STD_LOGIC;
          d:          in  STD_LOGIC_VECTOR(width-1 downto 0);
          q:          out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
    component mux2 generic(width: integer);
      port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
          s:      in  STD_LOGIC;
          y:      out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
    
    signal writereg:           STD_LOGIC_VECTOR(4 downto 0);
    signal pcjump, 
           pcnext, 
           pcnextbr, 
           pcplus4, 
           pcbranch:           STD_LOGIC_VECTOR(31 downto 0);
    signal signimm, signimmsh: STD_LOGIC_VECTOR(31 downto 0);
    signal srca, srcb, result: STD_LOGIC_VECTOR(31 downto 0);
  
  begin
    -- Next PC logic
    pcjump <= pcplus4(31 downto 28) & instr(25 downto 0) & "00";
   
    immsh:    sl2   port    map (signimm, signimmsh);
    pcadd1:   adder port    map (pc, X"00000004", pcplus4);
    pcadd2:   adder port    map (pcplus4, signimmsh, pcbranch);
    pcreg:    flopr generic map (32) 
                    port    map (clk, reset, pcnext, pc);
    pcbrmux:  mux2  generic map (32) 
                    port    map (pcplus4, pcbranch, pcsrc, pcnextbr);
    pcmux:    mux2  generic map (32) 
                    port    map (pcnextbr, pcjump, jump, pcnext);

    -- Register file logic
    rf: regfile port map( clk, regwrite, instr(25 downto 21), 
                          instr(20 downto 16), writereg, result,
                          srca, writedata );

    wrmux: mux2 generic map(5) 
                port    map( instr(20 downto 16), 
                             instr(15 downto 11), 
                             regdst, writereg );

    resmux: mux2  generic map(32) 
                  port    map( aluout, readdata, 
                               memtoreg, result );
    
    se: signext port map(instr(15 downto 0), signimm);

    -- ALU logic
    srcbmux: mux2 generic map(32) port map(writedata, signimm, alusrc, 
                                          srcb);
    mainalu: alu port map(srca, srcb, alucontrol, aluout, zero);
  end;
