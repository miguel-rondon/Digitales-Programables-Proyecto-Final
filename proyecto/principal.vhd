LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY principal IS
	PORT (
		reloj : IN STD_LOGIC;
		col : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		filas : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		segmentos : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END principal;

ARCHITECTURE arc OF principal IS
	-- FUNCTION nombre - función (
	-- 	nombre - señal : typo - señal;
	-- 	nombre - señal : typo - señal;
	-- 	………………………………………….
	-- 	nombre - señal : typo - señal;
	-- ) RETURN tipo - retorno IS
	-- 	declaración de tipo
	-- 	declaración de constantes
	-- 	declaración de variables
	-- 	definición de funciones
	-- 	definición de procedimiento
	-- BEGIN
	-- 	enunciado secuencial
	-- 	enunciado secuencial
	-- 	…………………………………..
	-- 	enunciado secuencial
	-- END nombre - función

	COMPONENT LIB_TEC_MATRICIAL_4x4_INTESC_RevA IS
		PORT (
			CLK : IN STD_LOGIC; --RELOJ FPGA
			COLUMNAS : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --PUERTO CONECTADO A LAS COLUMNAS DEL TECLADO
			FILAS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --PUERTO CONECTADO A LA FILAS DEL TECLADO
			BOTON_PRES : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --PUERTO QUE INDICA LA TECLA QUE SE PRESIONA
			IND : OUT STD_LOGIC --BANDERA QUE INDICA CUANDO SE PRESIONA UNA TECLA (SOLO DURA UN CICLO DE RELOJ)
		);
	END COMPONENT;

BEGIN

	componente : LIB_TEC_MATRICIAL_4x4_INTESC_RevA
	PORT MAP(reloj, col, filas, boton_pres, ind);

	componente : LIB_TEC_MATRICIAL_4x4_INTESC_RevA
	PORT MAP(reloj, col, filas, boton_pres, ind);

END arc;