{
TITLE: PROGRAMMING II LABS
SUBTITLE: Practical 2
AUTHOR 1: Brais García Brenlla        LOGIN 1: b.brenlla
AUTHOR 2: Javier González Rodríguez   LOGIN 2: j.gonzalezr
GROUP: 2.2
DATE: 1/04/2019
}


program main;

uses sysutils,SharedTypes,RequestQueue,Manager;

procedure CREATE(center,voters:string;VAR manager:tManager);
{Obxectivo:Añade un novo centro a lista manager
Entradas: center, o centro a añadir
          voters, o numero de votantes dese centro
          manager, a lista na que añadir o centro
Saidas:manager, a lista co novo centro
Precondicions:O manager ten que estar inicializado
Postcondicións:
 }

BEGIN
	if insertCenter(center,StrToInt(voters),manager) then
	writeln('* Create: center ',center,' totalvoters ',voters)
	else writeln('+ Error: Create not possible');
END;



procedure STATS(manager:tManager);
{Obxectivo:Mostra as estadisticas da lista manager
Entradas: manager, a lista da cal mostrar as estadisticas
Saidas: mostra por pantalla os centros, os partidos de cada centro, os votos de cada partido,
        o porcentaxe de votos de cada partido e o procentaxe de participacion de cada centro
Precondicions:O manager ten que estar inicializado
Postcondicións:
 }
BEGIN
	showStats(manager);
END;



procedure VOTES(center,party:string;VAR manager:tManager);
{Obxectivo:Incrementa en 1 os votos dun partido nun centro
Entradas: center, o centro ao que pertenece o partido
          party, o partido ao que se lle incrementa un voto
          manager, a lista que conten os centros
Saidas: manager, a lista cos votos actualizados
Precondicions:O manager ten que estar inicializado
Postcondicións:
 }
begin
 if voteInCenter(center,party,manager) then writeln('* Vote: center ',center,' party ',party)
 else writeln('+ Error: Vote not possible. Party ',party,' not found in center ',center,'. NULLVOTE');
end;



procedure NEW(center:string;party:string;VAR manager:tManager);
{Obxectivo:Añadese a un centro un partido con 0 votos
Entradas: center, o centro ao que añadir o partido
          party, o partido a añadir
          manager, a lista cos centros
Saidas:manager, a lista actualizada
Precondicions:manager ten que estar actualizado
Postcondicións:
 }
VAR
	tmp:boolean;
	
BEGIN
	tmp:=insertPartyInCenter(center,party,manager);
	if tmp then writeln('* New: center ',center,' party ',party)
	else writeln('+ Error: New not possible');
END;
	


procedure REMOVE(VAR manager:tManager);
{
Obxectivo: Eliminanse todos os centros do tManager con 0 votos validos
Entradas: manager, o tManager a modificar
Saidas:o tManager modificado
}
	
BEGIN
	if deleteCenters(manager)=0 then writeln('* Remove: no centers removed');	
END;



procedure readTasks(filename:string);

VAR
   usersFile  : TEXT;
   line       : STRING;
   //code       : STRING;
   //param1,param2,request:string;
   q:tQueue;
   manager:tManager;
   iq:tItemQ;

BEGIN

   {proceso de lectura del fichero filename }

   {$i-} { Deactivate checkout of input/output errors}
   Assign(usersFile, filename);
   Reset(usersFile);
   {$i+} { Activate checkout of input/output errors}
   IF (IoResult <> 0) THEN BEGIN
      writeln('**** Error reading '+filename);
      halt(1)
   END;
createEmptyManager(manager);
createEmptyQueue(q);
   WHILE NOT EOF(usersFile) DO
   BEGIN
      { Read a line in the file and save it in different VARiables}
      ReadLn(usersFile, line);
      iq.code := trim(copy(line,1,2));
      iq.request:= line[4];
      iq.param1 := trim(copy(line,5,10)); { trim removes blank spaces of the string}
                                         { copy(s, i, j) copies j characters of string s }
                                       { from position i }
      iq.param2 := trim(copy(line,15,10));
      
      enqueue(q,iq);
      	  
    END;
    
    createEmptyManager(manager);
   
   Close(usersFile);

    WHILE not isEmptyQueue(q) do
    BEGIN
      iq:=front(q);
	  {CHANGE writeln for the corresponding operation}
	  writeln('********************');
	  case iq.request of 
	  'C':BEGIN
		writeln(iq.code, ' ', iq.request, ': center ', iq.param1, ' totalvoters ',iq.param2);
		writeln;
		CREATE(iq.param1,iq.param2,manager);
		END;
		
	  'N':BEGIN
		writeln(iq.code, ' ', iq.request, ': center ', iq.param1, ' party ',iq.param2);
		writeln;
		new(iq.param1,iq.param2,manager);
		END;
	  
	  'V':BEGIN
		writeln(iq.code, ' ', iq.request, ': center ', iq.param1, ' party ',iq.param2);
		writeln;
		VOTES(iq.param1,iq.param2,manager);
		END;
	  
	  'R':BEGIN
		writeln(iq.code, ' ', iq.request, ':');
		writeln;
		REMOVE(manager);
		END;
	
	  'S':BEGIN
		writeln(iq.code, ' ', iq.request, ':');
		writeln;
		STATS(manager);
		END;
		
	  END;
	  dequeue(q);
	 END;
	deletemanager(manager);
END;



{Main program}

BEGIN
   
    if (paramCount>0) then
        readTasks(ParamStr(1))
    else
        readTasks('create.txt');

END.
