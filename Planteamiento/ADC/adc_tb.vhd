library ieee;
use ieee.std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.sine_package.all;

entity adc_tb is end;

architecture test of adc_tb is

  component sine_wave
    port( clock, reset, enable: in std_logic;
          wave_out: out sine_vector_type);
  end component;

  component ADC_8_bit is
    port (analog_in : in real range -15.0 to +15.0;
          digital_out : out std_logic_vector(7 downto 0)
         );
  end component;

  signal clock, reset, enable: std_logic;
  signal wave_out: sine_vector_type;

  signal adc_in : real range -15.0 to +15.0;
  signal adc_out : std_logic_vector(7 downto 0);


  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  sw  : sine_wave
    port map ( clock => clock,
               reset => reset,
               enable => enable,
               wave_out => wave_out);
  adc : ADC_8_bit
    port map (analog_in => adc_in,
              digital_out => adc_out);

  adc_in <= ((real(to_integer(signed(wave_out))))/16.0)-1.0;

  stimulus: process
  begin

    enable <= '0';
    reset <= '1';
    wait for 5 ns;
    reset <= '0';

    wait for 5115 ns;
    enable <= '1';

    wait for 1 ms;

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clock <= '1', '0' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
