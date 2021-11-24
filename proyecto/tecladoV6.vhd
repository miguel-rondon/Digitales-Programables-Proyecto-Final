LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;



ENTITY teclado IS
	PORT (
		SENSOR : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		reloj : IN STD_LOGIC;
		ntr, pul : IN STD_LOGIC;
		col : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		filas : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		segmentos_unidades, segmentos_decenas, segmentos_centenas : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		segmentos_unidades_1, segmentos_decenas_1, segmentos_centenas_1 : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
		segm1, segm2, segm3 : out std_logic_vector (7 downto 0);
		alarma : out std_logic
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
	
	-- Para el teclado

	SIGNAL boton_pres : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ind : STD_LOGIC := '0';
	SIGNAL ilma : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL mul : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL wt : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL temp1, temp2, temp3 : STD_LOGIC_VECTOR (7 DOWNTO 0) := "11111111";
	
	SIGNAL ref : INTEGER;
	
	SIGNAL val1, val2, val3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	
	SIGNAL x2sttdl_temp1, x2sttdl_temp2, x2sttdl_temp3 : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL save, save2 : STD_LOGIC_VECTOR (9 DOWNTO 0) := (OTHERS => '0');
	SIGNAL imp_temp1, imp_temp2, imp_temp3 : STD_LOGIC_VECTOR (11 DOWNTO 0) := (OTHERS => '0');

	-- Para la conversion de la referencia 2b
	SIGNAL valtotal : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL valtotal2 : STD_LOGIC_VECTOR(11 DOWNTO 0);
	
	-- Conversor Exadecimal a BCD (x2b)
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
	
	-- Conversor Exadecimal a binario (x2b)
	FUNCTION bitcomplt (
		valor : STD_LOGIC_VECTOR(3 DOWNTO 0)
	) RETURN STD_LOGIC_VECTOR IS
		VARIABLE temp : STD_LOGIC_VECTOR (9 DOWNTO 0);
	BEGIN
		--temp := to_stdlogicvector(valor);
		temp := (9 downto valor'length => '0') & valor;

		RETURN temp;

	END FUNCTION bitcomplt;
	
	FUNCTION bitcomplt12 (
		valor : STD_LOGIC_VECTOR(3 DOWNTO 0)
	) RETURN STD_LOGIC_VECTOR IS
		VARIABLE temp : STD_LOGIC_VECTOR (9 DOWNTO 0);
	BEGIN
		--temp := to_stdlogicvector(valor);
		temp := (12 downto valor'length => '0') & valor;

		RETURN temp;

	END FUNCTION bitcomplt12;
	
	-- Conversor Exadecimal a binario (x2b)
	FUNCTION x2bin (
		valor : STD_LOGIC_VECTOR
	) RETURN STD_LOGIC_VECTOR IS
		VARIABLE temp : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
	BEGIN
		CASE(valor) IS
			WHEN x"0" => temp := "0000";
			WHEN x"1" => temp := "0001";
			WHEN x"2" => temp := "0010";
			WHEN x"3" => temp := "0011";
			WHEN x"4" => temp := "0100";
			WHEN x"5" => temp := "0101";
			WHEN x"6" => temp := "0110";
			WHEN x"7" => temp := "0111";
			WHEN x"8" => temp := "1000";
			WHEN x"9" => temp := "1001";
			WHEN x"A" => temp := "1010";
			WHEN x"B" => temp := "1011";
			WHEN x"C" => temp := "1100";
			WHEN x"D" => temp := "1101";
			WHEN x"E" => temp := "1110";
			WHEN x"F" => temp := "1111";
			WHEN OTHERS => temp := "0000";
		END CASE;

		RETURN temp;

	END FUNCTION x2bin;
	
	-- ADC
	
	
	
signal lux : std_logic_vector(7 downto 0) := (OTHERS=>'0');
signal display1, display2, display3 : std_logic_vector (7 downto 0);
	
BEGIN

-- Acondicionamiento ADC

process (SENSOR,lux)
BEGIN
if SENSOR = "0011001001" THEN lux <= X"C8";--200
elsif SENSOR = "0100101001" THEN lux <= X"C3";--195
elsif sensor = "1110101001" then lux <= X"BE";--190;
elsif sensor = "1011101001" then lux <= X"B9";--185;
elsif sensor = "1100011001" then lux <= X"B4";--180;
elsif sensor = "1001011001" then lux <= X"AF";--175;
elsif sensor = "1111011001" then lux <= X"AA";--170;
elsif sensor = "1010111001" then lux <= X"A5";--165;
elsif sensor = "1101111001" then lux <= X"A0";--160;
elsif sensor = "0100000101" then lux <= X"9B";--155;
elsif sensor = "1110101101" then lux <= X"64";--100;
elsif sensor = "0000011101" then lux <= X"5F";--95;
elsif sensor = "0101011101" then lux <= X"5A";--90;
elsif sensor = "1100111101" then lux <= X"55";--85;
elsif sensor = "1011111101" then lux <= X"50";--80;
elsif sensor = "1100100011" then lux <= X"46";--70;
elsif sensor = "0101010011" then lux <= X"3C";--60;
elsif sensor = "1100001011" then lux <= X"32";--50;
elsif sensor = "1111101011" then lux <= X"28";--40;
elsif sensor = "0111111011" then lux <= X"1E";--30;
elsif sensor = "0000010111" then lux <= X"14";--20;
elsif sensor = "1001001111" then lux <= "00001010";--10;
elsif sensor = "0000011111" then lux <= "00000101";--5;
elsif sensor = "0110011111" then lux <= "00000100";--4;
elsif sensor = "1101011111" then lux <= "00000011";--3;
elsif sensor = "1000111111" then lux <= "00000010";--2;
elsif sensor = "1110111111" then lux <= "00000001";--1;
elsif sensor = "1111111111" then lux <= "00000000";--0;
else lux <= lux;
end if;
end process;

-- Imprimir el valor del sensor.

process (lux, mul, display1, reloj, display2, display3)
BEGIN
IF RISING_EDGE(reloj) THEN

case lux is
   when "00000000" =>
     display1 <= not("00111111");
	  display2 <= not("00111111");
	  display3 <= not("00111111");
	when "00000001" =>
     display1 <= not("00000110");
	  display2 <= not("00111111");
	  display3 <= not("00111111");
	when "00000010" =>
     display1 <= not("01011011");
	  display2 <= not("00111111");
	  display3 <= not("00111111");
	when "00000011" =>
     display1 <= not("01001111");
	  display2 <= not("00111111");
	  display3 <= not("00111111");
	when "00000100" =>
     display1 <= not("01100110");
	  display2 <= not("00111111");
	  display3 <= not("00111111");
	when "00000101" =>
     display1 <= not("01101101");
	  display2 <= not("00111111");
	  display3 <= not("00111111");
	when "00001010" =>
     display1 <= not("00111111");
	  display2 <= not("00000110");
	  display3 <= not("00111111");
	when X"14" =>
     display1 <= not("00111111");
	  display2 <= not("01011011");
	  display3 <= not("00111111");
	when X"1E" =>
     display1 <= not("00111111");
	  display2 <= not("01001111");
	  display3 <= not("00111111");
	when X"28" =>
     display1 <= not("00111111");
	  display2 <= not("01100110");
	  display3 <= not("00111111");
	when X"32" =>
     display1 <= not("00111111");
	  display2 <= not("01101101");
	  display3 <= not("00111111");
	when X"3C" =>
     display1 <= not("00111111");
	  display2 <= not("01111101");
	  display3 <= not("00111111");
	when X"46" =>
     display1 <= not("00111111");
	  display2 <= not("00000111");
	  display3 <= not("00111111");
	when X"50" =>
     display1 <= not("00111111");
	  display2 <= not("01111111");
	  display3 <= not("00111111");
	when X"5A" =>
     display1 <= not("00111111");
	  display2 <= not("01101111");
	  display3 <= not("00111111");
	when X"5F" =>
     display1 <= not("01101101");
	  display2 <= not("01101111");
	  display3 <= not("00111111");
	when X"64" =>
     display1 <= not("00111111");
	  display2 <= not("00111111");
	  display3 <= not("00000110");
	when X"9B" =>
     display1 <= not("01101101");
	  display2 <= not("01101101");
	  display3 <= not("00000110");
	when X"A0" =>
     display1 <= not("00111111");
	  display2 <= not("01111101");
	  display3 <= not("00000110");
	when X"A5" =>
     display1 <= not("01101101");
	  display2 <= not("01111101");
	  display3 <= not("00000110");
	when X"AA" =>
     display1 <= not("00111111");
	  display2 <= not("00000111");
	  display3 <= not("00000110");
   when X"AF" =>
     display1 <= not("01101101");
	  display2 <= not("00000111");
	  display3 <= not("00000110");
	when X"B4" =>
     display1 <= not("00111111");
	  display2 <= not("01111111");
	  display3 <= not("00000110");
	when X"B9" =>
     display1 <= not("01101101");
	  display2 <= not("01111111");
	  display3 <= not("00000110");
	when X"BE" =>
     display1 <= not("00111111");
	  display2 <= not("01101111");
	  display3 <= not("00000110");
	when X"C3" =>
     display1 <= not("01101111");
	  display2 <= not("01101111");
	  display3 <= not("00000110");
	when X"C8" =>
     display1 <= not("00111111");
	  display2 <= not("00111111");
	  display3 <= not("01011011");
	when X"55" =>
     display1 <= not("01101101");
	  display2 <= not("01111111");
	  display3 <= not("00111111");
	when others =>
	  display1 <= not("00111111");
	  display2 <= not("00111111");
	  display3 <= not("00111111");
end case;
END IF;
end process;

segm1 <= display1;
segm2 <= display2;
segm3 <= display3;

--	temp: PROCESS (lux, ilma) begin
--		wt <= STD_LOGIC_VECTOR(UNSIGNED(lux)*UNSIGNED(mul));
--	END PROCESS;





	componente : LIB_TEC_MATRICIAL_4x4_INTESC_RevA
	PORT MAP(reloj, col, filas, boton_pres, ind);

	proceso_teclado : PROCESS (reloj, ind, boton_pres, val1, val2, ref) BEGIN
		IF rising_edge(reloj) THEN
		
--		-- BD Pulsador de referencia
--
--			IF pul = '0' THEN
--				ref <= 1;
--				val1 <= x"0";
--				val2 <= x"0";
--				val3 <= x"0";
--			END IF;
				
			-- Ref
			
			IF ind = '1' AND boton_pres = x"A" THEN
				ref <= 1;
				val1 <= x"0";
				val2 <= x"0";
				val3 <= x"0";
			END IF;
			
			-- BD Pulsador Enter

			IF ntr = '0' THEN
				ref <= 0;
			END IF;
			
			-- BD Accion del teclado 4*4

			IF ind = '1' AND REF > 0 THEN
				ref <= ref + 1;
			END IF;
			
			IF ind = '1'  AND boton_pres = x"B" THEN
				ilma <=x"5A";
				mul <= "00000001";
			END IF;
			
			IF ind = '1'  AND boton_pres = x"C" THEN
				ilma <=x"14";
				mul <= "00000010";
			END IF;
			

			-- Unidades

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
--				ELSIF ind = '1' AND boton_pres = x"A" THEN
--					val1 <= boton_pres;
--				ELSIF ind = '1' AND boton_pres = x"B" THEN
--					val1 <= boton_pres;
--				ELSIF ind = '1' AND boton_pres = x"C" THEN
--					val1 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"D" THEN
					val1 <= boton_pres;
					ref <= 0;
--				ELSIF ind = '1' AND boton_pres = x"E" THEN
--					val1 <= boton_pres;
--				ELSIF ind = '1' AND boton_pres = x"F" THEN
--					val1 <= boton_pres;
--				ELSE
--					val1 <= val1;
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
--				ELSIF ind = '1' AND boton_pres = x"A" THEN
--					val2 <= boton_pres;
--				ELSIF ind = '1' AND boton_pres = x"B" THEN
--					val2 <= boton_pres;
--				ELSIF ind = '1' AND boton_pres = x"C" THEN
--					val2 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"D" THEN
					ref <= 0;
--				ELSIF ind = '1' AND boton_pres = x"E" THEN
--					val2 <= boton_pres;
--				ELSIF ind = '1' AND boton_pres = x"F" THEN
--					val2 <= boton_pres;
				ELSE
					val2 <= val2;
				END IF;
			END IF;

			-- centenas

			IF (ref = 3) THEN
				IF ind = '1' AND boton_pres = x"0" THEN
					val3 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"1" THEN
					val3 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"2" THEN
					val3 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"3" THEN
					val3 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"4" THEN
					val3 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"5" THEN
					val3 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"6" THEN
					val3 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"7" THEN
					val3 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"8" THEN
					val3 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"9" THEN
					val3 <= boton_pres;
--				ELSIF ind = '1' AND boton_pres = x"A" THEN
--					val3 <= boton_pres;
--				ELSIF ind = '1' AND boton_pres = x"B" THEN
--					val3 <= boton_pres;
--				ELSIF ind = '1' AND boton_pres = x"C" THEN
--					val3 <= boton_pres;
				ELSIF ind = '1' AND boton_pres = x"D" THEN
					ref <= 0;
--				ELSIF ind = '1' AND boton_pres = x"E" THEN
--					val3 <= boton_pres;
--				ELSIF ind = '1' AND boton_pres = x"F" THEN
--					val3 <= boton_pres;
				ELSE
					val3 <= val3;
				END IF;
			END IF;

			-- Reset REF

			IF ref > 3 THEN
				ref <= 0;
			END IF;
		END IF;

	END PROCESS;

	proceso_selecion_unidades : PROCESS (val1, val2, val3) BEGIN

		IF (val3 > x"0") THEN
			temp1 <= x2b(val2);
			temp2 <= x2b(val3);
			temp3 <= x2b(val1);
			
			valtotal2<= (val1*x"64")+(val2*x"A")+val3;
			imp_temp3 <= valtotal2;
			save <= imp_temp3(9 DOWNTO 0);
			
		ELSIF (val2 > x"0") THEN
			temp1 <= x2b(val1);
			temp2 <= x2b(val2);
			temp3 <= x2b(val3);
			
			valtotal<=(val1*x"A")+val2;
			
			--x2sttdl_temp2(3 DOWNTO 0) <= valtotal;
			imp_temp2 <= "0000" & valtotal;
			save <= imp_temp2(9 DOWNTO 0);
		ELSE
			temp1 <= x2b(val2);
			temp2 <= x2b(val1);
			temp3 <= x2b(val3);
			
			x2sttdl_temp1(3 DOWNTO 0) <= x2bin(val1);
			imp_temp1 <= "00000000" & x2sttdl_temp1;
			save <= imp_temp1(9 DOWNTO 0);
		END IF;

	END PROCESS;

	-- Imprimir de referencia

	segmentos_unidades <= temp2;
	segmentos_decenas <= temp1;
	segmentos_centenas <= temp3;
	
	-- Alarma
	alarma_process: PROCESS (save) BEGIN
	IF save <= lux THEN
		alarma <= '1';
	ELSE
		alarma <= '0';
	END IF;
	END PROCESS;
	
	-- Imprimir valores de LUX/W
	
--	segmentos_unidades_1 <= save2;
--	segmentos_decenas_1 <= imp_temp2(9 DOWNTO 0);
--	segmentos_centenas_1 <= imp_temp3(9 DOWNTO 0);

END tecladomatricial;