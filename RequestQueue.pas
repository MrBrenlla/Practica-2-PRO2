unit RequestQueue;

interface

	const
	MAX=25;
	NULL=0;
	BLANKVOTE='B';
	NULLVOTE='N';

type
	tPosQ=0..MAX;
	tRequest=char;
	tItemQ=record
		request:tRequest;
		code:string;
		param1:string;
		param2:string;
	END;
	tQueue=record
		item:array[1..MAX] of tItemQ;
		ini:tPosQ;
		fin:tPosQ;
	END;
	
procedure createEmptyQueue(VAR Q:tQueue);
function isEmptyQueue(Q:tQueue):boolean;
function enqueue(VAR Q:tQueue;I:tItemQ):Boolean;
function front(Q:tQueue):tItemQ;
procedure dequeue(VAR Q:tQueue);



implementation


function sumaUno(p:tPosQ):tPosQ;

BEGIN
	if p<>MAX then sumaUno:=p+1
	else sumaUno:=0;
END;


function restaUno(p:tPosQ):tPosQ;

BEGIN
	if p<>0 then restaUno:=p-1
	else restaUno:=MAX;
END;


procedure createEmptyQueue(VAR Q:tQueue);

{Crea una cola vacia
 PostCD:La cola queda inicializada y vacia
 }
BEGIN
	Q.ini:=1;
	Q.fin:=0;
END;


function isEmptyQueue(Q:tQueue):boolean;

	BEGIN
	isEmptyQueue:=(Q.fin=restaUno(Q.ini));
END;



function enqueue(VAR Q:tQueue;I:tItemQ):Boolean;

BEGIN
	if Q.fin=restaUno(restaUno(Q.ini)) then enqueue:=FALSE
	else BEGIN
		Q.fin:=sumaUno(Q.fin);
		Q.item[Q.fin]:=I;
		enqueue:=TRUE;
	END;
END;



function front(Q:tQueue):tItemQ;

BEGIN
	front:=Q.item[Q.ini];
END;



procedure dequeue(VAR Q:tQueue);

BEGIN
	Q.ini:=sumaUno(Q.ini);
END;


END.
