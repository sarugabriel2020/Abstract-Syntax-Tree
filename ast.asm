section .data
    delim db " ", 0
    current_node dd 0
section .bss
    root resd 1
    temp resd 1

section .text

extern strtok
extern calloc
extern malloc
extern strlen
extern memcpy

global create_tree
global iocla_atoi


;; functie care returneaza in registrul eax un numar pe 4 octeti,
;; care reprezina numarul in urma conversiei stringului primit ca
;; parametru in stiva
iocla_atoi:
    push    ebp
    mov     ebp, esp
    
    ;; salvam initial registrii pe care vrem sa ii folosim
    push    ebx
    push    ecx
    push    edx
    
    mov     edi, [ebp + 8]      ;; edi retine adresa stringului de convertit
    xor     ecx, ecx            ;; ecx este contor (index) pentru string
    xor     ebx, ebx
    xor     esi, esi            ;; 1 daca numarul este pozitiv, 0 altfel

    ;; presupunem prima oara ca numarul este pozitiv
    mov     esi, 1

    mov     bl, [edi + ecx] ;; luam primul caracter; verificam daca este minus
    xor     eax, eax
    cmp     ebx, 45         ;; daca este minus, atunci avem numar negativ
    je      negative_start_point

;; in acest label se face conversia din string in numar intreg (se face insa
;; abstractie de semnul minus)
calculate_integer:
    mov     ebx, 10
    mul     ebx
    ;; calcularea se face de la cea mai semnificativa cifra, intr-un while,
    ;; cifra cu cifra, pana ajungem la NULL
    mov     bl, [edi + ecx]
    sub     ebx, 48
    add     eax, ebx        ;; adaugam cifra din string la cifra din intreg
    inc     ecx
    mov     bl, [edi + ecx]
    cmp     ebx, 0          ;; s-a ajuns la NULL
    jne     calculate_integer

    ;; daca numarul nu este pozitiv, intram pe cazul negativ
    cmp     esi, 0
    je      is_negative
    jmp     finish_itoa     ;;altfel, returnam direct numarul         

;; daca e minus, setam bitul de semn
negative_start_point:
    mov     esi, 0
    add     ecx, 1
    jmp calculate_integer

;; cazul negativ: return -eax (practic)
is_negative:
    mov     esi, 0
    sub     esi, eax
    mov     eax, esi

finish_itoa:
    pop     edx
    pop     ecx
    pop     ebx

    leave
    ret

;; functie care verifica daca un string este operand sau numar
;; intoarce 0 daca nu este operand, si un numar diferit de 0 altfel
is_operand:
    push    ebp
    mov     ebp, esp

    mov     ecx, [ebp + 8]      ;; aici o sa avem stringul
    mov     ebx, [ecx]
    cmp     bl, 47
    ;; daca poate sa fie litera, atunci nu poate fi operand
    jg      not_operand
    ;; verificam daca operandul este minus, intrucat poate sa fie si de la un
    ;; numar minusul
    cmp     bl, 45
    jne     finish_is_operand
    mov     ebx, [ecx + 1]
    cmp     bl, 0
    je      finish_is_operand
;; cazul in care nu este operand
not_operand:
    mov     eax, 0

finish_is_operand:
    leave
    ret

;; functie care creeaza un nod (aloca memorie + pune in data valoarea
;; nodului respectiv)
make_node:
    push    ebp
    mov     ebp, esp
    ;; se face strtok pentru a obtine valoarea ce trebuie pusa in nod
    push    delim
    push    0
    call    strtok
    add     esp, 8
    ;; verficare daca nu mai merge strtok, ecx == -1 (error code)
    mov     ecx, eax
    dec     ecx
    cmp     ecx, -1
    je      finish_make_node
    mov     [temp], eax 
    ;; alocam memorie pe heap, folosind functia calloc
    push    1
    push    12 ;; numarul de octeti ce trebuie alocati (3 * 4)
    call    calloc
    add     esp, 8
    mov     edx, [current_node]
    mov     [edx], eax
    ;; salvam adresa alocata intr-o variabila ajutatoare
    mov     edx, [current_node]
    mov     edx, [edx]
    mov     eax, [temp]
    mov     [temp], edx
    ;; calculam lungimea valorii nodului
    push    eax
    push    eax
    call    strlen
    add     esp, 4
    mov     edx, eax
    ;; dupa care o si alocam pe heap, intrucat am obtinut doar o
    ;; valoare statica initial
    push    edx
    call    malloc
    pop     edx
    mov     ecx, eax
    ;; vom copia valoarea statica in zona de memorie pe care
    ;; tocmai am alocat-o, folosind functia memcpy
    pop     eax
    push    edx
    mov     edx, eax
    push    edx
    mov     eax, ecx
    push    eax
    call    memcpy
    add     esp, 12
    mov     edx, [temp]
    mov     [edx], eax

finish_make_node:
    leave
    ret

;; cea mai importanta functie din tot programul, si anume functia
;; care creeaza toate nodurile care pornesc de la radacina, folosind
;; apeluri utile ale diferitor functii declarate mai sus
;; algoritmul de realizare al acestei functii se regaseste in README
tree_nodes_generator:
    push    ebp
    mov     ebp, esp
    ;; aici se ia adresa radacinii, salvata pe stiva
    mov     edx, [ebp + 8]
    push    edx
;; subarborele din stanga radacinii    
left_side:
    cmp     esp, ebp
    ;; daca esp == ebp, inseamna ca stiva apelului de functie este goala
    je      finish_tree_nodes_generator
    mov     edx, [esp]
    mov     edx, [edx]
    add     edx, 4
    ;; in current_node se salveaza nodul curent in crearea arborelui
    mov     [current_node], edx
    cmp     dword [edx], 0
    ;; daca nodul din stanga nu este NULL, inseamna ca trebuie sa
    ;; cream nodul dreapta
    jne     right_side
    push    current_node
    call    make_node           ;; creeam noul nod
    add     esp, 4
    cmp     eax, 0
    ;; daca nu s-a putut crea nodul, inseamna ca am ajuns la final
    je      finish_tree_nodes_generator
    push    eax
    call    is_operand          ;; vrem sa vedem daca este operand sau nu
    add     esp, 4
    cmp     eax, 0
    ;; daca nu este operand, atunci e frunza, si urmatorul nod va fi
    ;; in partea dreapta
    je      right_side
    push    dword [current_node]
    jmp     left_side
;; subarborele din dreapta radacinii 
right_side:
    cmp     esp, ebp
    je      finish_tree_nodes_generator
    ;; daca esp == ebp, inseamna ca stiva apelului de functie este goala 
    mov     edx, [esp]
    mov     edx, [edx]
    add     edx, 8
    ;; salvam nodul curent in current_node
    mov     [current_node], edx
    cmp     dword [edx], 0
    ;; valoarea lui current_node NU este NULL, atunci ne intoarcem
    ;; in nodul parinte, pana putem sa inseram
    jne     back_with_pop
    ;; lucram la fel si ca la un nod stanga in rest
    push    current_node
    call    make_node
    add     esp, 4
    cmp     eax, 0
    je      finish_tree_nodes_generator
    push    eax
    call    is_operand
    add     esp, 4
    cmp     eax, 0
    je      back
    push    dword [current_node]
    jmp     left_side

;; eliminare de pe stiva (ne intoarcem practic la nodul parinte)
back_with_pop:
    add     esp, 4
;; nu se poate continua in stanga, ne intoarcem la nod parinte
;; si mergem in dreapta
back:
    jmp     right_side

finish_tree_nodes_generator:
    mov     esp, ebp
    leave
    ret

;; functia care creeaza radacina si apeleaza functia de creare a
;; nodurilor arborelui
create_tree:
    enter 0, 0
    xor eax, eax
    ;; salvam valorile initiale, pentru siguranta
    push ebx
    push ecx
    push edx
    ;; alocam memorie pentru radacina
    push 1
    push 12
    call calloc
    add esp, 8
    mov [root], eax
    ;; trebuie sa folosim strtok pentru a obtine valorile din input
    mov edx, [ebp + 8] 
    push delim
    push edx
    call strtok
    add esp, 8
    ;; calculam lungimea valorii din radacina...
    push eax
    push eax
    call strlen
    add esp, 4
    mov edx, eax
    ;; ...si apoi o alocam pe heap
    push edx
    call malloc
    pop edx
    mov ecx, eax
    ;; + copiere a valorii in zona alocata
    pop eax
    push edx
    mov edx, eax
    push edx
    mov eax, ecx
    push eax
    call memcpy
    add esp, 12
    mov edx, [root]
    mov [edx], eax
    ;; creeam arborele dorit in root
    push root
    call tree_nodes_generator
    add esp, 4
    ;; functia noastra trebuie sa intoarca rezultatul in eax, deci
    ;; vom pune in eax valoarea din root (adica adresa de start arborelui)
    mov eax, [root]
    ;; refacem registrii
    pop edx
    pop ecx
    pop ebx

    leave
    ret
