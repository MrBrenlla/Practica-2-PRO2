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

BEGIN
	if insertCenter(center,StrToInt(voters),manager) then
	writeln('* Create: center ',center,' totalvoters ',voters)
	else writeln('+ Error: Create not possible');
END;



procedure STATS(manager:tManager);

BEGIN
	showStats(manager);
END;



procedure NEW(center:string;party:string;VAR manager:tManager);

VAR
	tmp:boolean;
	
BEGIN
	tmp:=insertPartyInCenter(center,party,manager);
	if tmp then writeln('* New: center ',center,' party ',party)
	else writeln('+ Error: New not possible');
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
	  
	  //'V':VOTE();
	  
	  //'R':REMOVE();
	
	  'S':BEGIN
		writeln(iq.code, ' ', iq.request, ':');
		writeln;
		STATS(manager);
		END;
		
	  END;
	  
	  //writeln;
	  dequeue(q);
	 END;
END;



{Main program}

BEGIN
   
    if (paramCount>0) then
        readTasks(ParamStr(1))
    else
        readTasks('create.txt');

END.
