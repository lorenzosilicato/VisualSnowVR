# Realtà virtuale per curare la Visual Snow
## Setup del progetto
### Requisiti 
Per importare il progetto e necessario utilizzare una versione di Unity uguale o superiore alla 2022.3.12f1, quella utilizzata per lo sviluppo del progetto. Tutte le impostazioni che seguono sono prese al fine di esportare il progetto in formato WebGL.

### Importare i package per la pipeline URP
Il progetto utilizza la pipeline di render URP, per importarla in un nuovo progetto :
1. Aprire Unity
2. Clickare 'Window' > 'Package Manager' e selezionare 'Packages: Unity Registry'
3. Cercare e installare il package 'Universal RP'

### Importare e impostare la libreria DOTween
Il progetto utilizza la libreria DOTween per gestire gli script di movimento.
Per importare la libreria :
1. Aprire Unity
2. Clickare 'Window' > 'Asset Store' e aprire lo store nel browser
3. Installare 'DOTween (HOTween v2)' dallo store.

Una volta fatto cio bisogna impostare DOTween per gestire i moduli necessari :
1. In Unity clickare 'Tools' > 'Demigiant' > 'DOTween Utility Panel'
2. Si aprirà un pannello, clickare il bottone verde 'Setup DOTween...'
3. In questa sezione si possono scegliere moduli da importare, nel nostro caso importeremo solamente 'UI' e 'Sprites'
4. Clickare 'Apply' per terminare.

### Configurazione delle scene
In questo progetto ogni scena Unity rappresenta un esercizio diverso. Tutte le scene sono composte dai seguenti oggetti :
- Una **Canvas UI** : è il GameObject principale e  rappresenta la porzione di schermo in cui saranno visualizzati gli effetti e in cui si muoveranno i pannelli figli, se esistenti.
	- Tramite l'inspector la Render Mode della canvas viene impostata a 'Screen Space - Camera' e in Render Camera viene assegnata la main camera del progetto.
	- Tutti gli script del progetto vengono attaccati alla canvas come Component.
 	- Il materiale con la shader generata viene assegnato alla canvas o ai pannelli figli a seconda dell'esercizio da ricreare.	
- Una **Main Camera** : è la camera principale e viene attaccata alla canvas in modo da riempire l'intero schermo di gioco con l'esatta dimensione della canvas, nel nostro caso la risoluzione sarà 1920x1080.
- Uno **Slider** : viene utilizzato per tenere traccia del tempo trascorso e del tempo rimanente nell'esercizio.

Infine, alcuni degli esercizi contengono delle Image UI, creati come oggetti figli della canvas e saranno gli oggetti che si muoveranno nello spazio e avranno come materiale le shader.

### Canvas
Questo GameObject è responsabile per il controllo di tutto quello che succede nella scena. All'interno dell'inspector della canvas vengono attaccati i seguenti script :
1. Lo script relativo all'esercizio è necessario solamente se vi sono dei pannelli in movimento ed è responsabile per il controllo e la gestione dei movimenti. Una volta assegnato alla canvas permette tramite l'inspector di assegnare i GameObject che rappresentano i pannelli.
2. Lo script **OnClick** : permette di clickare lo schermo per fermare o far ripartire la riproduzione dell'esercizio. Manipola il valore della variabile *Time.timeScale* per fermare il tempo.
3. Lo script **TimeBar** : gestisce l'avanzamento dello slider. Ha una variabile che contiene il tempo massimo dell'esercizio e finche la variabile *Time.timeScale* non è 0 procede fino ad arrivare al tempo massimo. Una volta assegnato alla canvas permette tramite l'inspector di decidere il GameObject che rappresenta lo slider.
4. Lo script **Toggle Fullscreen** : permette di clickare due volte lo schermo per entrare ed uscire dalla modalita' schermo intero.

## Le Shader
All'interno della cartella 'Shader' vi sono tutti i materiali e le shader sviluppate per il progetto, nominati in base all'esercizio a cui sono assegnati.
Per lo scopo di questo progetto ogni shader è diversa dall'altra anche se spesso condividono tra di loro alcune funzioni e il guscio esterno del programma.

Una shader in Unity viene scritta in due linguaggi **ShaderLab**, proprietario di Unity, e **HLSL**(High Level Shader Language).
**ShaderLab** e' un linguaggio dichiarativo che utilizza blocchi di codice nidificati per specificare un oggetto Shader.
Vi sono tre parti principali : 

 - 	il blocco **Shader** e' lo strato esterno e permette di definire le proprietà' del materiale tramite un blocco *Properties*, assegnare un editor personalizzato, assegnare un oggetto di fallback e definire uno o più' blocchi di SubShader.
 -  il blocco **SubShader** permette di definire diverse impostazioni della GPU e diversi programmi a seconda dell'hardware, inoltre permette di specificare la pipeline di render utilizzata e impostazioni di runtime. Infine si puo definire un blocco di Pass e un blocco di PackageRequirements.
 - il blocco **Pass** e' l'elemento fondamentale di una shader, contiene le istruzioni per impostare lo stato della GPU e il programma che viene utilizzato da quest'ultima. All'interno di questo blocco possiamo poi definire un ulteriore blocco che inizia e finisce con le parole chiave *HLSLPROGRAM* e *ENDHLSL* al cui interno specificare tutto il codice scritto in HLSL.

Inoltre in Unity ogni shader deve contenere due programmi : 

 - Un programma **Vertex** che permette di trasformare la posizione di un oggetto in coordinate 3D utilizzate per disegnare la shader.
 - Un programma **Fragment** che computa il colore e gli attributi di ogni pixel. Denotato dalla funzione *frag* si comporta come la funzione main di un qualsiasi altro programma e al suo interno verranno spesso compiute le azioni principali o richiamate funzioni gia' definite.
 
### ShaderLab e programma Vertex
Per lo scopo di questo progetto sia la parte ShaderLab che il programma Vertex rimangono invariati per tutte le shader sviluppate :

    Shader "Unlit/Esempio" {  
	    Properties {  
	        _Color("Color", Color) = (1,1,1,1)  
	    }  
	    SubShader {  
	        Pass  {  
	            HLSLPROGRAM  
			#pragma vertex vert  
			#pragma fragment frag  
			#include "UnityCG.cginc"  
			float4 _Color;  
 
			struct v2f {  
				float4 pos : SV_POSITION;  
				fixed4 color : COLOR;  
				float2 uv : TEXCOORD0;  
			};  
    
			v2f vert (appdata_base v){  
	                    	v2f o;  
				o.pos = UnityObjectToClipPos(v.vertex);  
				o.color.xyz = v.normal * 0.5 + 0.5;  
				o.color.w = 1.0;  
				o.uv = v.texcoord;  
				return o;  
			}  
  
	                float4 frag(v2f v) : SV_Target {
		                return _Color;  	
			}	  
	            ENDHLSL  
		}  
	    }  
	}

Questo è un semplice template per la creazione di effetti di noise tramite shader che può essere personalizzato creando funzioni in HLSL e assegnando un valore di ritorno al colore del fragment.

All'interno della cartella '**Assets/Studi**' vi sono una serie di shader semplici, atte ad apprendere le funzioni principali utilizzati nella programmazione shader, che possono essere assegnate al materiale della canvas per vedere gli effetti che generano. Queste shader non vengono esportate per il progetto finale, sono state utilizzate solamente per l'apprendimento della programmazione shader.
