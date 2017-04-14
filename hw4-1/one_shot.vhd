library ieee;
use ieee.std_logic_1164.all;

entity ONE_CYCLE is
  port (PUSH, CLK, R : in std_logic;
        SINGLE : out std_logic);
end ONE_CYCLE;

architecture BEHAV of ONE_CYCLE is
  type STATE_TYPE is (INIT, FIRST, CONTINUE);
  signal STATE : STATE_TYPE;
  signal NEXT_S : std_logic;
begin
  process(R, CLK)
  begin
    if (R = '1') then
      STATE <= INIT;
      NEXT_S <= '0';
    elsif (CLK'event and CLK = '1') then
      if (STATE = INIT) then
        if (PUSH = '1') then
          STATE <= FIRST;
          NEXT_S <= '1';
        end if;
      elsif (STATE = FIRST) then
        if (PUSH = '1') then
          STATE <= CONTINUE;
        else
          STATE <= INIT;
        end if;
        NEXT_S <= '0';
      elsif (STATE = CONTINUE) then
        if (PUSH = '1') then
          STATE <= CONTINUE;
        else
          STATE <= INIT;
        end if;
        NEXT_S <= '0';
      end if;
    end if;
  end process;
  process (R, CLK)
  begin
    if (R = '1') then
      SINGLE <='0';
    elsif (CLK'event and CLK = '0') then
      SINGLE <= NEXT_S;
    end if;
  end process;
end BEHAV;

library ieee;
use ieee.std_logic_1164.all;

entity TB is
end TB;

architecture BEHAV of TB is
  signal CLK : std_logic := '0';
  signal S0, S1, S2, S3, S4, S5 : std_logic;
  --component ONE_CYCLE
  --  port (P, CLK, R : in std_logic;
  --        S : out std_logic);
  --end component;
begin
  process (CLK)
  begin
   CLK <= not CLK after 50 ns;
  end process;
  U1 : entity work.ONE_CYCLE(BEHAV) port map(S0, CLK, S1, S2);
  process
  begin
    S0 <= '0', '1' after 280 ns, '0' after 1000 ns;
    S1 <= '0', '1' after 35 ns, '0' after 55 ns;
    wait;
  end process;
end BEHAV;
