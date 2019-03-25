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
	fin:tPosQ;
	end;

procedure createEmptyQueue(var Q:tQueue);
function isEmptyQueue(Q:tQueue):boolean;
function enqueue(var Q:tQueue;I:tItemQ):Boolean;
function front(Q:tQueue):tItemQ;
procedure dequeue(Q:tQueue);

implementation

procedure createEmptyQueue(var Q:tQueue);
{Crea una cola vacia
* PostCD:La cola queda inicializada y vacia
* }
begin
Q.fin:=NULL;
end;

function isEmptyQueue(Q:tQueue):boolean;
begin
isEmptyQueue:=(Q.fin=0);
end;

function enqueue(var Q:tQueue;I:tItemQ):Boolean;
begin
end;
function front(Q:tQueue):tItemQ;
begin
end;
procedure dequeue(Q:tQueue);
begin
end;
begin
end.
