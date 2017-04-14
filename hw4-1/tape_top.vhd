use WORK.all;
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use std.TEXTIO.all;

entity TP_TEST_BENCH is
end TP_TEST_BENCH;

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture TEST of TP_TEST_BENCH is
  signal RESET : std_logic;
  signal CLK : std_logic := '0';
  signal PLAY, STOP, FAST_FORWARD, REWIND, MUSIC, P, F, R : std_logic;
  signal FF_ONE, RW_ONE : std_logic;
  signal COUNT : unsigned (15 downto 0);
begin
  U1: entity work.ONE_CYCLE(BEHAV)
      port map (PUSH => FAST_FORWARD, CLK => CLK, R => RESET,
                SINGLE => FF_ONE);
  U2: entity work.ONE_CYCLE(BEHAV)
      port map (PUSH => REWIND, CLK => CLK, R => RESET,
                SINGLE => RW_ONE);
  U3: entity work.TAPE_PLAYER(BEHAV)
      port map (PL => PLAY, CLK => CLK, RESET => RESET, RE => RW_ONE,
                FF => FF_ONE, ST => STOP, P => P, F => F, R => R,
                M => MUSIC, COUNT => COUNT);
  process(CLK)
  begin
    CLK <= not CLK after 50 ns;
  end process;
  process
    variable VLINE: LINE;
    variable V : std_logic_vector (5 downto 0);
    file INVECT : TEXT is "tape_player.txt";
  begin
    READLINE(INVECT, VLINE);
    READLINE(INVECT, VLINE);
    READ(VLINE, V);
    RESET <= V(5);
    PLAY <= V(4);
    FAST_FORWARD <= V(3);
    REWIND <= V(2);
    MUSIC <= V(1);
    STOP <= V(0);
    while not(ENDFILE(INVECT)) loop
      wait until CLK = '0';
      READLINE(INVECT, VLINE);
      READ(VLINE, V);
      RESET <= V(5);
      PLAY <= V(4);
      FAST_FORWARD <= V(3);
      REWIND <= V(2);
      MUSIC <= V(1);
      STOP <= V(0);
      wait until CLK = '1';
      wait for 2 ns;
    end loop;
    wait;
  end process;
end TEST;
