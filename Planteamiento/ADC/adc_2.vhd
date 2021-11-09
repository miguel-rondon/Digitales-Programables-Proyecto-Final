LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY adc_dac_interface IS PORT (
    CLK_SAMP : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    enable_in : IN STD_LOGIC;
    Real_in_from_ADC : IN STD_LOGIC_VECTOR(11 DOWNTO 0);--receiver side i/p
    imag_in_from_ADC : IN STD_LOGIC_VECTOR(11 DOWNTO 0); --receiver side i/p

    Real_adc_to_phy : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);--receiver side 0/p
    imag_adc_to_phy : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);--receiver side o/p

    ADC_CLK1 : OUT STD_LOGIC;
    ADC_CLK2 : OUT STD_LOGIC;
    enable_out : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE beh OF adc_dac_interface IS

BEGIN

    PROCESS (CLK_SAMP, reset)
    BEGIN
        IF reset = '1' THEN
            enable_out <= '0';
            real_adc_to_phy <= (OTHERS => '0');
            imag_adc_to_phy <= (OTHERS => '0');

        ELSIF CLK_SAMP = '1' AND CLK_SAMP'event THEN

            real_adc_to_phy <= Real_in_from_ADC (11) & Real_in_from_ADC (11) & Real_in_from_ADC (11) & Real_in_from_ADC (11) & Real_in_from_ADC;
            imag_adc_to_phy <= imag_in_from_ADC(11) & imag_in_from_ADC(11) & imag_in_from_ADC(11) & imag_in_from_ADC(11) & imag_in_from_ADC;
            enable_out <= enable_in;

        END IF;

    END PROCESS;

    ADC_CLK1 <= CLK_SAMP;
    ADC_CLK2 <= CLK_SAMP;

END beh;

-- https://www.rfwireless-world.com/source-code/VHDL/ADC-DAC-interfacing-with-FPGA-vhdl-code.html