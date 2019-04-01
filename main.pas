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

procedure CREATE(center,voters:string;m:tManager);

begin
if insertCenter(center,StrToInt(voters),m) then
writeln('* Create: center ',center,' totalvoters ',voters)
else writeln('+ Error: Create not possible');
end;

procedure readTasks(filename:string);

VAR
   usersFile  : TEXT;
   line       : STRING;
   //code       : STRING;
   //param1,param2,request:string;
   q:tQueue;
   M:tManager;
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
createEmptyManager(M);
createEmptyQueue(q);
   WHILE NOT EOF(usersFile) DO
   BEGIN
      { Read a line in the file and save it in different variables}
      ReadLn(usersFile, line);
      iq.code := trim(copy(line,1,2));
      iq.request:= line[4];
      iq.param1 := trim(copy(line,5,10)); { trim removes blank spaces of the string}
                                         { copy(s, i, j) copies j characters of string s }
                                       { from position i }
      iq.param2 := trim(copy(line,15,10));
      
      //writeln(iq.code, ' ', iq.request, ': ', iq.param1, ' ',iq.param2);
      writeln(enqueue(q,iq));
      {enqueue(q,iq);}
      	  
    END;
   
   Close(usersFile);

    WHILE not isEmptyQueue(q) do
    begin
      iq:=front(q);
	  {CHANGE writeln for the corresponding operation}
	  writeln('********************');
	  writeln(iq.code, ' ', iq.request, ': ', iq.param1, ' ',iq.param2);
	  writeln;
	  case iq.request of 
	  'C':CREATE(iq.param1,iq.param2,M);
	  'N'://NEW();
	  ;
	  'V'://VOTE();
	  ;
	  'R'://REMOVE();
	  ;
	  'S'://STATS();
	  ;
	  end;
	  
	  //writeln;
	  dequeue(q);
	 end;
END;



{Main program}

BEGIN
   
    if (paramCount>0) then
        readTasks(ParamStr(1))
    else
        readTasks('create.txt');

END.
