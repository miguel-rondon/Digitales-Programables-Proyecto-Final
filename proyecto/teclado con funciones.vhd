LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY teclado IS
	PORT (
		reloj : IN STD_LOGIC;
		col : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		filas : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		segmentos : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END teclado;

ARCHITECTURE tecladomatricial OF teclado IS

	COMPONENT LIB_TEC_MATRICIAL_4x4_INTESC_RevA IS
		PORT (
			CLK : IN STD_LOGIC; --RELOJ FPGA
			COLUMNAS : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --PUERTO CONECTADO A LAS COLUMNAS DEL TECLADO
			FILAS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --PUERTO CONECTADO A LA FILAS DEL TECLADO
			BOTON_PRES : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --PUERTO QUE INDICA LA TECLA QUE SE PRESIONA
			IND : OUT STD_LOGIC --BANDERA QUE INDICA CUANDO SE PRESIONA UNA TECLA (SOLO DURA UN CICLO DE RELOJ)
		);
	END COMPONENT;

	SIGNAL boton_pres : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ind : STD_LOGIC := '0';
	SIGNAL segm : STD_LOGIC_VECTOR (7 DOWNTO 0);

	FUNCTION imprimir (
		boton_pres : STD_LOGIC_VECTOR;
		ind : STD_LOGIC
	) RETURN STD_LOGIC_VECTOR IS
		VARIABLE segm : STD_LOGIC_VECTOR (7 DOWNTO 0) := "10111111";
	BEGIN
		IF ind = '1' AND boton_pres = x"0" THEN
			segm := "11000000";
		ELSIF ind = '1' AND boton_pres = x"1" THEN
			segm := "11111001";
		ELSIF ind = '1' AND boton_pres = x"2" THEN
			segm := NOT("01011011");
		ELSIF ind = '1' AND boton_pres = x"3" THEN
			segm := NOT("01001111");
		ELSIF ind = '1' AND boton_pres = x"4" THEN
			segm := NOT("01100110");
		ELSIF ind = '1' AND boton_pres = x"5" THEN
			segm := NOT("01101101");
		ELSIF ind = '1' AND boton_pres = x"6" THEN
			segm := NOT("01111101");
		ELSIF ind = '1' AND boton_pres = x"7" THEN
			segm := NOT("00000111");
		ELSIF ind = '1' AND boton_pres = x"8" THEN
			segm := NOT("01111111");
		ELSIF ind = '1' AND boton_pres = x"9" THEN
			segm := NOT("01101111");
		ELSIF ind = '1' AND boton_pres = x"A" THEN
			segm := NOT("01110111");
		ELSIF ind = '1' AND boton_pres = x"B" THEN
			segm := NOT("01111100");
		ELSIF ind = '1' AND boton_pres = x"C" THEN
			segm := NOT("00111001");
		ELSIF ind = '1' AND boton_pres = x"D" THEN
			segm := NOT("01011110");
		ELSIF ind = '1' AND boton_pres = x"E" THEN
			segm := NOT("01111001");
		ELSIF ind = '1' AND boton_pres = x"F" THEN
			segm := NOT("01110001");
		ELSE
			segm := segm;
		END IF;
		RETURN segm;

	END FUNCTION imprimir;

BEGIN

	componente : LIB_TEC_MATRICIAL_4x4_INTESC_RevA
	PORT MAP(reloj, col, filas, boton_pres, ind);

	proceso_teclado :
	PROCESS (reloj, ind, boton_pres, segm)

	BEGIN
		IF rising_edge(reloj) THEN
			segm <= imprimir(boton_pres, ind);
		END IF;
	END PROCESS;
	segmentos <= segm;
END tecladomatricial;