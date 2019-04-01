unit RequestQueue;

interface

const
	MAX=25;
	NULL=0;
	BLANKVOTE='B';
	NULLVOTE='N';

type
	tPosQ=0..MAX;
	{tPartyName=string;
	tNumVotes=word;}
  tRequest=char;
	tItemQ=record
	request:tRequest;
    code:string;
    param1:string;
    param2:string;
	end;
	tQueue=record
	item:array[1..MAX] of tItemQ;
	ini:tPosQ;
	fin:tPosQ;
	end;
	
procedure createEmptyQueue(var Q:tQueue);
function isEmptyQueue(Q:tQueue):boolean;
function enqueue(var Q:tQueue;I:tItemQ):Boolean;
function front(Q:tQueue):tItemQ;
procedure dequeue(var Q:tQueue);

implementation

function sumaUno(p:tPosQ):tPosQ;
begin
if p<>MAX then sumaUno:=p+1
else sumaUno:=0;
end;
function restaUno(p:tPosQ):tPosQ;
begin
if p<>0 then restaUno:=p-1
else restaUno:=MAX;
end;
procedure createEmptyQueue(var Q:tQueue);
{Crea una cola vacia
* PostCD:La cola queda inicializada y vacia
* }
begin
Q.ini:=1;
Q.fin:=0;
end;

function isEmptyQueue(Q:tQueue):boolean;
begin
isEmptyQueue:=(Q.fin=restaUno(Q.ini));
end;

function enqueue(var Q:tQueue;I:tItemQ):Boolean;
begin
if Q.fin=restaUno(restaUno(Q.ini)) then enqueue:=FALSE
	else begin
		Q.fin:=sumaUno(Q.fin);
		Q.item[Q.fin]:=I;
		enqueue:=TRUE;
	end;
end;

function front(Q:tQueue):tItemQ;
begin
front:=Q.item[Q.ini];
end;

procedure dequeue(var Q:tQueue);
begin
Q.ini:=sumaUno(Q.ini);
end;


end.
