library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity TAPE_PLAYER is
  port(PL, RE, FF, ST, M : in std_logic;
       P, F, R : out std_logic;
       COUNT : out unsigned (15 downto 0);
       RESET, CLK : in std_logic);
end TAPE_PLAYER;

architecture BEHAV of TAPE_PLAYER is
  type STATE_TYPE is (INIT, PUSHPLAY, PP_RE1, PP_REW, PP_FF1, PP_FFOR, PLAY);
  signal STATE : STATE_TYPE;
  signal INT_COUNT : unsigned (15 downto 0);
begin
  process(RESET, CLK)
  begin
    if (RESET = '1') then
      STATE <= INIT;
    elsif (CLK'event and CLK = '1') then
      if (STATE = INIT) then
        if (PL = '1') then
          STATE <= PUSHPLAY;
        end if;
        INT_COUNT <= "0000000000000000";
      elsif (STATE = PUSHPLAY) then
        if (PL = '0' or ST = '1') then 
          STATE <= INIT;
        else 
          if (RE = '1') then
            STATE <= PP_RE1;
          elsif (FF = '1') then
            STATE <= PP_FF1;
          else
            STATE <= PLAY;
          end if;
        end if;
        INT_COUNT <= "0000000000000000";
      elsif (STATE = PP_RE1) then
        if (PL = '0' or ST = '1') then
          STATE <= INIT;
        else
          if (RE = '0') then
            STATE <= PP_REW;
          else
            STATE <= PP_RE1;
          end if;
        end if;
        INT_COUNT <= "0000000000000000";
      elsif (STATE = PP_REW) then
        if (ST = '1') then
          STATE <= INIT;
        else
          if (M = '1') then
            STATE <= PP_REW;
          else
            STATE <= INIT;
          end if;
        end if;
        INT_COUNT <= INT_COUNT + 1;
      elsif (STATE = PP_FF1) then
        if (PL = '0' or ST = '1') then
          STATE <= INIT;
        else
          if (FF = '0') then
            STATE <= PP_FFOR;
          else
            STATE <= PP_FF1;
          end if;
        end if;
        INT_COUNT <= "0000000000000000";
      elsif (STATE = PP_FFOR) then
        if (ST = '1') then
          STATE <= INIT;
        else
          if (M = '1') then
            STATE <= PP_FFOR;
          else
            STATE <= INIT;
          end if;
        end if;
        INT_COUNT <= INT_COUNT + 1;
      elsif (STATE = PLAY) then
        if (ST = '1') then 
          STATE <= INIT;
        else
          STATE <= PLAY;
        end if;
        INT_COUNT <= INT_COUNT + 1;
      end if;
    end if;
    COUNT <= INT_COUNT;
  end process;
 
  P <= '1' WHEN STATE = PLAY else '0';
  F <= '1' WHEN STATE = PP_FFOR else '0';
  R <= '1' WHEN STATE = PP_REW else '0';

end BEHAV;
