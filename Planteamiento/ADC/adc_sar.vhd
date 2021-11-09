LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ADC IS
    PORT (
        Clock : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        CompIn : IN STD_LOGIC;
        ChargeOut : OUT STD_LOGIC;
        DataOut : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE A OF ADC IS
    SIGNAL DComp : STD_LOGIC;
    SIGNAL QComp : STD_LOGIC;
    SIGNAL CompSel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL DCounter : STD_LOGIC_VECTOR(21 DOWNTO 0);
    SIGNAL QCounter : STD_LOGIC_VECTOR(21 DOWNTO 0);
    SIGNAL DShiftReg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL QShiftReg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL ShiftRegEnable : STD_LOGIC;
    SIGNAL DOutReg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL QOutReg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL OutRegEnable : STD_LOGIC;
    CONSTANT Conversion1Cycle : INTEGER := 346574;
    CONSTANT Conversion2Cycle : INTEGER := 519860;
    CONSTANT Conversion3Cycle : INTEGER := 606503;
    CONSTANT Conversion4Cycle : INTEGER := 649824;
BEGIN
    -- comparator d flip-flop
    PROCESS (Clock)
    BEGIN
        IF (Clock'event AND (Clock = '1')) THEN
            QComp <= DComp;
        END IF;
    END PROCESS;

    DComp <= '0' WHEN ((CompSel = "00") OR (Reset = '1')) ELSE
        '1' WHEN (CompSel = "01") ELSE
        CompIn WHEN (CompSel = "10") ELSE
        QComp;
    ChargeOut <= QComp;

    -- shift register
    PROCESS (Clock)
    BEGIN
        IF (Clock'event AND (Clock = '1')) THEN
            QShiftReg <= DShiftReg;
        END IF;
    END PROCESS;

    DShiftReg <= (QShiftReg(2 DOWNTO 0) & QComp) WHEN (ShiftRegEnable = '1') ELSE
        QShiftReg;

    -- output register
    PROCESS (Clock)
    BEGIN
        IF (Clock'event AND (Clock = '1')) THEN
            QOutReg <= DOutReg;
        END IF;
    END PROCESS;

    DOutReg <= QShiftReg WHEN (OutRegEnable = '1') ELSE
        QOutReg;
    DataOut <= QOutReg;

    -- 22 bit counter & fsm
    PROCESS (Clock)
    BEGIN
        IF (Clock'event AND (Clock = '1')) THEN
            QCounter <= DCounter;
        END IF;
    END PROCESS;

    DCounter <= STD_LOGIC_VECTOR(to_unsigned(0, 22)) WHEN (Reset = '1') ELSE
        STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(QCounter)) + 1, 22));

    CompSel <= "00" WHEN (to_integer(unsigned(QCounter)) = (Conversion4Cycle + 1)) ELSE
        "01" WHEN (to_integer(unsigned(QCounter)) = 0) ELSE
        "10" WHEN ((to_integer(unsigned(QCounter)) = Conversion1Cycle) OR (to_integer(unsigned(QCounter)) = Conversion2Cycle) OR (to_integer(unsigned(QCounter)) = Conversion3Cycle) OR (to_integer(unsigned(QCounter)) = Conversion4Cycle)) ELSE
        "11";
    ShiftRegEnable <= '1' WHEN ((to_integer(unsigned(QCounter)) = (Conversion1Cycle + 1)) OR (to_integer(unsigned(QCounter)) = (Conversion2Cycle + 1)) OR (to_integer(unsigned(QCounter)) = (Conversion3Cycle + 1)) OR (to_integer(unsigned(QCounter)) = (Conversion4Cycle + 1))) ELSE
        '0';
    OutRegEnable <= '1' WHEN (to_integer(unsigned(QCounter)) = (Conversion4Cycle + 2)) ELSE
        '0';
END ARCHITECTURE;