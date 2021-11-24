LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY teclado IS
	PORT (
		reloj : IN STD_LOGIC;
		save, pul : IN STD_LOGIC;
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
	SIGNAL segm : STD_LOGIC_VECTOR (7 DOWNTO 0) := "11111111";
	SIGNAL temp : STD_LOGIC_VECTOR (7 DOWNTO 0) := "11111111";
	SIGNAL ref : STD_LOGIC;
	SIGNAL val1 : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');

BEGIN

	componente : LIB_TEC_MATRICIAL_4x4_INTESC_RevA
	PORT MAP(reloj, col, filas, boton_pres, ind);

	proceso_teclado : PROCESS (reloj, ind, boton_pres, segm, ref) BEGIN
		IF rising_edge(reloj) THEN
		
			IF pul='0' THEN
				ref <= '1';
			END IF;
		
			IF ind = '1' AND boton_pres = x"0" THEN
				segm <= "11000000";
			ELSIF ind = '1' AND boton_pres = x"1" THEN
				segm <= "11111001";
			ELSIF ind = '1' AND boton_pres = x"2" THEN
				segm <= NOT("01011011");
			ELSIF ind = '1' AND boton_pres = x"3" THEN
				segm <= NOT("01001111");
			ELSIF ind = '1' AND boton_pres = x"4" THEN
				segm <= NOT("01100110");
			ELSIF ind = '1' AND boton_pres = x"5" THEN
				segm <= NOT("01101101");
			ELSIF ind = '1' AND boton_pres = x"6" THEN
				segm <= NOT("01111101");
			ELSIF ind = '1' AND boton_pres = x"7" THEN
				segm <= NOT("00000111");
			ELSIF ind = '1' AND boton_pres = x"8" THEN
				segm <= NOT("01111111");
			ELSIF ind = '1' AND boton_pres = x"9" THEN
				segm <= NOT("01101111");
			ELSIF ind = '1' AND boton_pres = x"A" THEN
				segm <= NOT("01110111");
			ELSIF ind = '1' AND boton_pres = x"B" THEN
				segm <= NOT("01111100");
			ELSIF ind = '1' AND boton_pres = x"C" THEN
				segm <= NOT("00111001");
			ELSIF ind = '1' AND boton_pres = x"D" THEN
				segm <= NOT("01011110");
			ELSIF ind = '1' AND boton_pres = x"E" THEN
				segm <= NOT("01111001");
			ELSIF ind = '1' AND boton_pres = x"F" THEN
				segm <= NOT("01110001");
			ELSE
				segm <= segm;
			END IF;

			IF (ref = '1') THEN
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
				
				IF ind = '1' THEN
					ref <= '0';
				END IF;
			END IF;
		END IF;

		CASE(val1) IS
			WHEN x"0" => temp <= "11000000";
			WHEN x"1" => temp <= "11111001";
			WHEN x"2" => temp <= NOT("01011011");
			WHEN x"3" => temp <= NOT("01001111");
			WHEN x"4" => temp <= NOT("01100110");
			WHEN x"5" => temp <= NOT("01101101");
			WHEN x"6" => temp <= NOT("01111101");
			WHEN x"7" => temp <= NOT("00000111");
			WHEN x"8" => temp <= NOT("01111111");
			WHEN x"9" => temp <= NOT("01101111");
			WHEN x"A" => temp <= NOT("01110111");
			WHEN x"B" => temp <= NOT("01111100");
			WHEN x"C" => temp <= NOT("00111001");
			WHEN x"D" => temp <= NOT("01011110");
			WHEN x"E" => temp <= NOT("01111001");
			WHEN x"F" => temp <= NOT("01110001");
			WHEN OTHERS => temp <= temp;
		END CASE;

	END PROCESS;

	segmentos_unidades <= segm;
	segmentos_decenas <= temp;
END tecladomatricial;