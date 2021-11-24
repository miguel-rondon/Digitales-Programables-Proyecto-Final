LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY teclado IS
	PORT (
		reloj : IN STD_LOGIC;
		ntr, pul : IN STD_LOGIC;
		col : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		filas : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		segmentos_unidades, segmentos_decenas : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
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
	--SIGNAL val2 : STD_LOGIC_VECTOR (7 DOWNTO 0) := "11111111";
	SIGNAL temp1, temp2 : STD_LOGIC_VECTOR (7 DOWNTO 0) := "11111111";
	SIGNAL ref : INTEGER;
	SIGNAL val1, val2 : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');

	-- Conversor Exadecimal a binario (x2b)
	FUNCTION x2b (
		valor : STD_LOGIC_VECTOR
	) RETURN STD_LOGIC_VECTOR IS
		VARIABLE temp : STD_LOGIC_VECTOR (7 DOWNTO 0) := "10111111";
	BEGIN
		CASE(valor) IS
			WHEN x"0" => temp := "11000000";
			WHEN x"1" => temp := "11111001";
			WHEN x"2" => temp := NOT("01011011");
			WHEN x"3" => temp := NOT("01001111");
			WHEN x"4" => temp := NOT("01100110");
			WHEN x"5" => temp := NOT("01101101");
			WHEN x"6" => temp := NOT("01111101");
			WHEN x"7" => temp := NOT("00000111");
			WHEN x"8" => temp := NOT("01111111");
			WHEN x"9" => temp := NOT("01101111");
			WHEN x"A" => temp := NOT("01110111");
			WHEN x"B" => temp := NOT("01111100");
			WHEN x"C" => temp := NOT("00111001");
			WHEN x"D" => temp := NOT("01011110");
			WHEN x"E" => temp := NOT("01111001");
			WHEN x"F" => temp := NOT("01110001");
			WHEN OTHERS => temp := temp;
		END CASE;

		RETURN temp;

	END FUNCTION x2b;

BEGIN

	componente : LIB_TEC_MATRICIAL_4x4_INTESC_RevA
	PORT MAP(reloj, col, filas, boton_pres, ind);

	proceso_teclado : PROCESS (reloj, ind, boton_pres, val1, val2, ref) BEGIN
		IF rising_edge(reloj) THEN

			IF pul = '0' THEN
				ref <= 1;
				val1 <= x"0";
				val2 <= x"0";
			END IF;

			IF ntr = '0' THEN
				ref <= 0;
			END IF;

			IF ind = '1' AND REF > 0 THEN
				ref <= ref + 1;
			END IF;

			-- Unidad

			IF (ref = 1) THEN
				IF ind = '1' AND boton_pres = x"0" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"1" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"2" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"3" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"4" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"5" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"6" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"7" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"8" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"9" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"A" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"B" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"C" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"D" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"E" THEN
					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"F" THEN
					val1 <= boton_pres;
				ELSE
					val1 <= val1;
				END IF;

			END IF;

			-- Decena

			IF (ref = 2) THEN
				IF ind = '1' AND boton_pres = x"0" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"1" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"2" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"3" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"4" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"5" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"6" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"7" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"8" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"9" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"A" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"B" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"C" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"D" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"E" THEN
					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"F" THEN
					val2 <= boton_pres;
				ELSE
					val2 <= val2;
				END IF;
			END IF;

			-- Reset REF

			IF ref > 2 THEN
				ref <= 0;
			END IF;
		END IF;

	END PROCESS;

	proceso_imprimir : PROCESS (val1, val2) BEGIN

		IF (val2 > x"0") THEN
			temp1 <= x2b(val1);
			temp2 <= x2b(val2);
		ELSE
			temp1 <= x2b(val2);
			temp2 <= x2b(val1);
		END IF;

	END PROCESS;

	-- Imprimir valores

	segmentos_unidades <= temp2;
	segmentos_decenas <= temp1;

END tecladomatricial;