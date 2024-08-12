----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:32:05 06/30/2022 
-- Design Name: 
-- Module Name:    Cash_withdrawal - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all ;
USE ieee.std_logic_arith.all ;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Cash_withdrawal is
    Port ( push_b : in  STD_LOGIC_VECTOR (4 downto 0); -- push_b0:enter   push_b1:10$/up   push_b2:20$/down   push_b3:50$/left   push_b4:100$/right
			  second : in  STD_LOGIC;
           led0,led1,led3 : out  STD_LOGIC;
           seven_s : out  STD_LOGIC_VECTOR (10 downto 0);
           mony_in : in  STD_LOGIC_VECTOR (10 downto 0) ;
           mony_out : out  STD_LOGIC_VECTOR (10 downto 0));
end Cash_withdrawal;

architecture Behavioral of Cash_withdrawal is

signal sum : STD_logic_vector(10 downto 0) := (others=>'0');
signal temp : STD_logic_vector(10 downto 0) := (others=>'0');
signal mony_out_t : STD_logic_vector(10 downto 0) := (others=>'0');
signal comp_max : STD_logic; -- comparing sum to 500$ 
signal comp_min : STD_logic; -- comparing sum to 20$    
signal t_count : STD_logic_vector(4 downto 0) := (others => '0'); -- comparing sum to 500$ . 
signal active : STD_logic := '1';
signal counter_enable : STD_logic := '0';
signal counter_reset : STD_logic := '0';

 
begin
mony_out<= sum + mony_in;
led0<='1';
led1<='1';
led3<='1';
comp_max <= '1' when temp>500 else
			'0';
comp_min <= '1' when mony_in - temp<20 else
			'0';
	process(push_b,second)
	
	variable state : integer := 1;
	
	begin
	if (active = '1') then
		if (state =0 ) then
			sum <= (others => '0');
			temp <= (others => '0');
			counter_reset <= '0';
		end if;
		
		if (state = 1) then
			
			if(rising_edge(second) ) then
			t_count<= t_count +1;
			end if;
			
			if(rising_edge(push_b(1)) ) then
			temp <= sum + 10;
			end if;
			
			
			if(rising_edge(push_b(2)) ) then
			temp <= sum + 20;
			end if;
			
			
			if(rising_edge(push_b(3)) ) then
			temp <= sum + 50;
			end if;
	
			
			if(rising_edge(push_b(4)) ) then
			temp <= sum + 100;
			end if;
			
			if( comp_max = '0' and comp_min ='0' ) then 
			sum<=temp;
			else
			temp<=sum;
			end if; 
		

			if( rising_edge(push_b(0)) and ( conv_integer(sum) mod 20 = 0 )  )   then
			state := 2;
			elsif ( rising_edge(push_b(0)) ) then
			 seven_s <= "00000001000";
			end if;
		end if;
		
		if (state = 2) then
			if(counter_reset = '0') then  -- counter
				t_count <= (others => '0');
			elsif(rising_edge(second)) then
				t_count <= t_count + 1;
			end if;
			
			seven_s <= sum;        -- show the added amount on seven segment
			
			if(t_count = 5) then
				counter_reset <= '1';
				state := 3;
			end if;
		end if;
		
		if(state = 3) then
			mony_out_t<= (mony_in - sum);
			seven_s <= mony_out_t ;
			
			
			if(rising_edge(push_b(1)) ) then
				state := 1;
				sum <= (others => '0');
			 end if;
			 if(rising_edge(push_b(2)) ) then
				state := 1;
				sum <= (others => '0');
			 end if;
			 if(rising_edge(push_b(3)) ) then
				state := 1;
				sum <= (others => '0');
			 end if;
			 if(rising_edge(push_b(4)) ) then
				state := 1;
				sum <= (others => '0');
			 end if;
			 if(rising_edge(push_b(0)) ) then
				active <= '0';
				state := 0;
			end if;
		end if;
		
		
	end if;
	end process;
	
	
mony_out<= mony_out_t;	
counter_reset <= t_count(0) and t_count(2);
end Behavioral;

