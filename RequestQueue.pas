{
TITLE: PROGRAMMING II LABS
SUBTITLE: Practical 2
AUTHOR 1: Brais García Brenlla        LOGIN 1: b.brenlla
AUTHOR 2: Javier González Rodríguez   LOGIN 2: j.gonzalezr
GROUP: 2.2
DATE: 03/05/2019
}

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

{Obxectivo:Crea unha cola vacia
Entradas: Q, a cola que se desexa inicializar
Saidas:Q, a cola de entrada xa inicializada
Precondicions:
Postcondicións:A cola esta inicializada e vacia
 }
BEGIN
	Q.ini:=1;
	Q.fin:=0;
END;


function isEmptyQueue(Q:tQueue):boolean;
{Obxectivo:Comprobar se a cola esta vacia
Entradas: Q, a cola a comprobar
Saidas: un boolean que indica se a cola esta vacia
Precondicions:A cola esta inicializada
Postcondicións:}
	BEGIN
	isEmptyQueue:=(Q.fin=restaUno(Q.ini));
END;



function enqueue(VAR Q:tQueue;I:tItemQ):Boolean;
{Obxectivo:Añade un item a cola
Entradas: Q, a cola a que se vai a añadir un item
          I, o item a añadir
Saidas: Q, a cola de entrada co item añadido
        un boolean que indica o exito ou fracaso da operacion
Precondicions:A cola esta inicializada
Postcondicións:}
BEGIN
	if Q.fin=restaUno(restaUno(Q.ini)) then enqueue:=FALSE
	else BEGIN
		Q.fin:=sumaUno(Q.fin);
		Q.item[Q.fin]:=I;
		enqueue:=TRUE;
	END;
END;



function front(Q:tQueue):tItemQ;
{Obxectivo: Recupera o primeiro item da cola
Entradas: Q, a cola da que se vai recuperar o item
Saidas: O primeiro item da cola
Precondicions:A cola esta inicializada e non vacia
Postcondicións:}
BEGIN
	front:=Q.item[Q.ini];
END;



procedure dequeue(VAR Q:tQueue);
{Obxectivo: Elimina o primeiro item da cola
Entradas: Q, a cola da que se vai eliminar o item
Saidas: A cola sen o primeiro item
Precondicions:A cola esta inicializada e non vacia
Postcondicións:}
BEGIN
	Q.ini:=sumaUno(Q.ini);
END;


END.

