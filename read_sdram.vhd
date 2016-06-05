library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity read_sdram is
    port(
	clk		:   in std_logic;
	rst		:   in std_logic;
	address		:   out std_logic_vector(28 downto 0);
	burstCount	:   out std_logic(7 downto 0);
	waitRequest	:   in std_logic;
	data		:   in std_logic_vector(63 downto 0);
	dataValid	:   in std_logic;
	read		:   out std_logic;
	LEDs		:   out std_logic_vector(7 downto 0)
    );
end read_sdram;

architecture default of read_sdram is
    signal  ctr		:   std_logic_vector(31 downto 0) := X"0000_0000";
    signal  sampleData	:   std_logic;
begin
    process(rst, clk) begin
	if( rst = '1' ) then
	    ctr		<= X"0000_0000"; 
	    address	<= X"0000_0000";
	    read	<= '0';
	    LEDs	<= X"00";
	    burstCount	<= X"01";
	    sampleData	<= '0';
	elsif( clk'event and clk = '1' ) then
	    if( ctr = X"0000_0001") then
		    address	<= X"0FFF_AAAA";
		    read	<= '1';
		    burstCount	<= X"01";
	    elsif( dataValid = '1' ) then
		sampleData <= '1';
	    elsif( sampleData = '1' ) then
		LEDs	<= data(7 downto 0);
		read	<= '0';
	    elsif( ctr = X"0000_0FFF") then
		ctr <= X"0000_0000";
	    end if;
	end if;
    end process;
end architecture;
