-- -----------------------------
--  Copyright 1995-2008 DOULOS
--     designer : Tim Pagden
--      opened:  2 Feb 1996
-- -----------------------------

-- Architectures:
--   02.02.96 original
--   20/05/08 edited to replace vfp_lib with numeric_std

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ADC_8_bit IS
  PORT (
    analog_in : IN real RANGE -15.0 TO +15.0;
    digital_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE original OF ADC_8_bit IS

  CONSTANT conversion_time : TIME := 25 ns;

  SIGNAL instantly_digitized_signal : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL delayed_digitized_signal : STD_LOGIC_VECTOR(7 DOWNTO 0);

  FUNCTION ADC_8b_10v_bipolar (
    analog_in : real RANGE -15.0 TO +15.0
  ) RETURN STD_LOGIC_VECTOR IS
    CONSTANT max_abs_digital_value : INTEGER := 128;
    CONSTANT max_in_signal : real := 10.0;
    VARIABLE analog_signal : real;
    VARIABLE analog_abs : real;
    VARIABLE analog_limited : real;
    VARIABLE digitized_signal : INTEGER;
    VARIABLE digital_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
  BEGIN
    analog_signal := real(analog_in);
    IF (analog_signal < 0.0) THEN -- i/p = -ve
      digitized_signal := INTEGER(analog_signal * 12.8);
      IF (digitized_signal <- (max_abs_digital_value)) THEN
        digitized_signal := - (max_abs_digital_value);
      END IF;
    ELSE -- i/p = +ve
      digitized_signal := INTEGER(analog_signal * 12.8);
      IF (digitized_signal > (max_abs_digital_value - 1)) THEN
        digitized_signal := max_abs_digital_value - 1;
      END IF;
    END IF;
    digital_out := STD_LOGIC_VECTOR(to_signed(digitized_signal, digital_out'length));
    RETURN digital_out;
  END ADC_8b_10v_bipolar;

BEGIN

  s0 : instantly_digitized_signal <=
  STD_LOGIC_VECTOR (ADC_8b_10v_bipolar (analog_in));

  s1 : delayed_digitized_signal <=
  instantly_digitized_signal AFTER conversion_time;

  s2 : digital_out <= delayed_digitized_signal;

END original;