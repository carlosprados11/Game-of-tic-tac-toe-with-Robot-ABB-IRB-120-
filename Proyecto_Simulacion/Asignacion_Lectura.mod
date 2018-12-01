MODULE Asignacion_Lectura

    PROC LeeFichero()

        VAR num found{5};
        VAR num tam;
        VAR num suma:=0;
        VAR string texto;

        ! Abrimos el fichero y lo leemos en la variable texto
        Open "HOME:"\File:="verdes.txt",fichero\Read;
        texto:=ReadStr(fichero);
        Close fichero;

        ! Buscamos las letras
        found{1}:=StrFind(texto,1,"A");
        found{2}:=StrFind(texto,1,"B");
        found{3}:=StrFind(texto,1,"C");
        found{4}:=StrFind(texto,1,"D");
        found{5}:=StrFind(texto,1,"E");
        tam:=StrLen(texto);

        FOR i FROM 1 TO 5 DO

            ! Asignamos las posiciones al vector verdes
            IF (found{i}<>tam+1) THEN
                verdes{i}:=1;
                suma:=suma+1;
            ENDIF

            ! Asignamos la pieza más cercana al robot como referencia
            IF (verdes{i}=1 AND primera_verde=0) THEN
                primera_verde:=i;
            ENDIF

        ENDFOR

        IF (suma<3 OR suma>5) THEN
            TPWrite "Parametros del fichero erroneos.";
            TPWrite "Introduzca parametros legales.";
            TPWrite "FIN DEL PROGRAMA.";
            EXIT;
        ENDIF

        ! Verdes es un vector con unos en las posiciones de los cubos

        ! Rutina de errores
    ERROR
        IF ERRNO=ERR_FILEACC THEN
            TPErase;
            TPWrite "Error al acceder al archivo verdes.txt";
            EXIT;
            
        ELSEIF ERRNO=ERR_FILEOPEN THEN
            TPErase;
            TPWrite "No se puede abrir al archivo verdes.txt";
            EXIT;
        
        ELSEIF ERRNO=ERR_FILNOTFND THEN
            TPErase;
            TPWrite "Archivo verdes.txt no encontrado";
            EXIT;
            
        ENDIF    
    
    ENDPROC


    PROC Asigna_Tablero()

        VAR num dist:=110;

        ! Describimos las posiciones posibles a dejar las piezas
        FOR i FROM 1 TO 3 DO
            FOR j FROM 1 TO 3 DO
                pos_tab{i,j}:=offs(Inicial_Mesa,(i-1)*dist,(j-1)*dist,0);
            ENDFOR
        ENDFOR

        FOR i FROM 1 TO 3 DO
            ! Rellenamos el tableros con ceros (sin piezas)
            FOR j FROM 1 TO 3 DO
                tablero{i,j}:=0;
            ENDFOR
        ENDFOR

    ENDPROC

ENDMODULE