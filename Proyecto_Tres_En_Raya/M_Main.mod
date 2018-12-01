MODULE M_Main

    ! VARIABLES A UTILIZAR

    ! Variables de fichero y posiciones indicadas en el mismo
    VAR iodev fichero;
    VAR iodev resultados;
    VAR num verdes{5};
    VAR num primera_verde;

    ! Posiciones en el tablero ocupadas y puntos del mismo
    VAR num tablero{3,3};
    VAR robtarget pos_tab{3,3};
    VAR num n_piezas;

    ! Variables para la localización de piezas
    VAR robtarget pieza_v{5};
    VAR robtarget pieza_r{5};
    VAR robtarget ref_verde;
    VAR robtarget punto_v;
    VAR robtarget punto_r;
    CONST num dist_verd:=80;

    ! Variables auxiliares para saltar piezas y realizar busquedas o no
    VAR bool saltar{5};
    VAR bool busqueda{5};

    ! Variables controladoras de la partida
    VAR num veces;
    VAR num empieza;
    VAR num ganador{2};
    VAR num juegos;
    VAR clock tiempo{2};

    ! Variable de interrupción
    VAR intnum interrupcion;
    VAR num ultima_colu;
    VAR num ultima_fila;
    VAR bool repetir;
    PERS wobjdata mesanegra:=[FALSE,TRUE,"",[[179.622105871,155.837,126.215],[0.999897341,0.009771073,-0.008831533,0.005642562]],[[-0.000223517,0.000342727,-0.000037253],[1,0.000003308,-0.000000036,-0.000002491]]];

    PROC main()

        ! Asignamos la interrupcion a di1 y la definimos
        CONNECT interrupcion WITH int1;
        ISignalDI di1,1,interrupcion;
        ISleep interrupcion;
        ! Desactivamos la interrupcion de momento

        TPErase;
        TPWrite "Inicio del Programa";

        ! Leemos fichero para saber donde están las piezas verdes
        LeeFichero;
        juegos:=1;

        ! Maximo 2 juegos
        WHILE juegos<=2 DO

            ! Si iniciamos el juego reiniciamos tablero y variables
            Asigna_Tablero;
            veces:=0;
            ganador{juegos}:=0;
            n_piezas:=0;
            punto_v:=Cubo_Verde;
            punto_r:=Cubo_Rojo;

            ! Vamos a posicion de reposo
            MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;

            ! Se elige quien empieza
            TPWrite "Partida nueva.";
            TPReadFK empieza,"¿Quieres empezar?","Si","No","","","";

            ! Pongo el tiempo de juego a 0 y empiezo a contar
            ClkReset tiempo{juegos};
            ClkStart tiempo{juegos};

            ! Maximo 5 piezas por juego
            WHILE veces<5 DO

                veces:=veces+1;

                ! EMPIEZA JUGANDO USUARIO
                IF empieza=1 THEN
                    ! Mueve usuario (fichas rojas)
                    IF (ganador{juegos}=0 AND n_piezas<9) THEN

                        Juega_Rojo;
                        ! Si se produce una interrupcion se repite
                        WHILE repetir=TRUE DO
                            Juega_Rojo;
                        ENDWHILE

                    ENDIF

                    ! Mueve robot (fichas verdes)
                    IF (ganador{juegos}=0 AND n_piezas<9) THEN

                        Juega_Verde;

                    ENDIF


                ! EMPIEZA JUGANDO MÁQUINA
                ELSE
                    ! Mueve robot (fichas verdes)
                    IF (ganador{juegos}=0 AND n_piezas<9) THEN

                        Juega_Verde;

                    ENDIF

                    ! Mueve usuario (fichas rojas)
                    IF (ganador{juegos}=0 AND n_piezas<9 AND saltar{veces}=FALSE) THEN

                        Juega_Rojo;
                        ! Si se produce una interrupcion se repite
                        WHILE repetir=TRUE DO
                            Juega_Rojo;
                        ENDWHILE

                    ENDIF
                ENDIF

            ENDWHILE

            TPWrite "Fin de la partida.";
            ClkStop tiempo{juegos};
            Recoge_piezas;
            juegos:=juegos+1;

        ENDWHILE

        Ganador_Tiempo;

        IDelete interrupcion;
        ! Eliminamos la interrupcion

    ERROR
        IF ERRNO=ERR_INOMAX THEN
            ! Se producirá con una pieza en la pinza
            TPWrite "Se ha pulsado reiteradas veces di1 hasta saturación";
            
            ! Dejamos la pieza que porta el robot
            MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;
            MoveJ offs(pieza_r{veces},0,0,200), v400,fine,Pinza_Neumatica\WObj:=mesanegra;
            MoveL pieza_r{veces}, v100,fine,Pinza_Neumatica\WObj:=mesanegra;
            AbrirPinza;
            MoveL offs(pieza_r{veces},0,0,200), v400,fine,Pinza_Neumatica\WObj:=mesanegra;
            MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;
            
            ! Recogemos el resto de piezas
            Recoge_Piezas;
            EXIT;
            
        ELSEIF ERRNO=ERR_NORUNUNIT THEN
            TPWrite "Se ha perdido el contacto con la unidad";
            EXIT;
            
        ELSEIF ERRNO=ERR_OVERFLOW THEN
            TPWrite "Tiempo sobrepasado";
            MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;
            Recoge_Piezas;
            EXIT;
            
        ENDIF
    

    ENDPROC
    

    TRAP int1

        ! Vacio la posición del tablero donde ibamos a dejar la pieza
        tablero{ultima_fila,ultima_colu}:=0;
        repetir:=TRUE;

        ! Cuando se termine el movimiento que se estaba produciendo lo llevo a reposo
        MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;

        RETURN ;

    ENDTRAP

ENDMODULE