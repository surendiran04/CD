%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "node.h"
extern int yylex();
void yyerror(const char *s);
Node *root;
#define YYDEBUG 1
%}

%code requires {
    #include "node.h"
}

%union {
    char *str;
    Node *node;
}

%token <str> DOCTYPE HTML_OPEN HTML_CLOSE HEAD_OPEN HEAD_CLOSE TITLE_OPEN TITLE_CLOSE
%token <str> BODY_OPEN BODY_CLOSE P_OPEN P_CLOSE DIV_OPEN DIV_CLOSE H1_OPEN H1_CLOSE
%token <str> META IMG COMMENT STYLE_OPEN STYLE_CLOSE
%token <str> TABLE_OPEN TABLE_CLOSE TR_OPEN TR_CLOSE TH_OPEN TH_CLOSE TD_OPEN TD_CLOSE
%token <str> UL_OPEN UL_CLOSE OL_OPEN OL_CLOSE LI_OPEN LI_CLOSE
%token <str> TEXT

%type <node> html head title body content element table_rows table_row table_data list_item list_items list_content style_content

%%

html: DOCTYPE HTML_OPEN head body HTML_CLOSE      { root = createNode("html"); addChild(root, $3); addChild(root, $4); }
    | HTML_OPEN head body HTML_CLOSE             { root = createNode("html"); addChild(root, $2); addChild(root, $3); }
    ;

head: HEAD_OPEN content HEAD_CLOSE               { $$ = createNode("head"); addChild($$, $2); }
    ;

title: TITLE_OPEN TEXT TITLE_CLOSE               { $$ = createNode("title"); addChild($$, createNode($2)); }
     ;

body: BODY_OPEN content BODY_CLOSE               { $$ = createNode("body"); addChild($$, $2); }
     ;

content: /* empty */                             { $$ = NULL; }
       | content element                         { if ($1) addChild($1, $2); else $$ = $2; }
       ;

element: title
       | P_OPEN TEXT P_CLOSE                     { $$ = createNode("p"); addChild($$, createNode($2)); }
       | DIV_OPEN content DIV_CLOSE              { $$ = createNode("div"); addChild($$, $2); }
       | H1_OPEN TEXT H1_CLOSE                   { $$ = createNode("h1"); addChild($$, createNode($2)); }
       | TABLE_OPEN table_rows TABLE_CLOSE       { $$ = createNode("table"); addChild($$, $2); }
       | UL_OPEN list_items UL_CLOSE             { $$ = createNode("ul"); addChild($$, $2); }
       | OL_OPEN list_items OL_CLOSE             { $$ = createNode("ol"); addChild($$, $2); }
       | META                                    { $$ = createNode("meta"); }
       | IMG                                     { $$ = createNode("img"); }
       | COMMENT                                 { $$ = createNode("comment"); }
       | STYLE_OPEN style_content STYLE_CLOSE    { $$ = createNode("style"); addChild($$, $2); }
       | TEXT                                    { $$ = createNode($1); }
       ;

style_content: TEXT                               { $$ = createNode($1); }
             ;

table_rows: table_row                            { $$ = $1; }
          | table_rows table_row                 { addChild($1, $2); $$ = $1; }
          ;

table_row: TR_OPEN table_data TR_CLOSE           { $$ = createNode("tr"); addChild($$, $2); }
         ;

table_data: TD_OPEN TEXT TD_CLOSE                { $$ = createNode("td"); addChild($$, createNode($2)); }
          | table_data table_data                { addChild($1, $2); $$ = $1; }
          ;

list_items: list_item                            { $$ = $1; }
          | list_items list_item                 { addChild($1, $2); $$ = $1; }
          ;

list_item: LI_OPEN TEXT list_content LI_CLOSE    { $$ = createNode("li"); addChild($$, createNode($2)); addChild($$, $3); }
         | LI_OPEN list_content LI_CLOSE         { $$ = createNode("li"); addChild($$, $2); }
         ;

list_content: TEXT                               { $$ = createNode($1); }
            | UL_OPEN list_items UL_CLOSE        { $$ = createNode("ul"); addChild($$, $2); }
            | OL_OPEN list_items OL_CLOSE        { $$ = createNode("ol"); addChild($$, $2); }
            | TABLE_OPEN table_rows TABLE_CLOSE  { $$ = createNode("table"); addChild($$, $2); }
            | list_content TEXT                  { addChild($1, createNode($2)); $$ = $1; }
            | list_content UL_OPEN list_items UL_CLOSE { addChild($1, createNode("ul")); addChild($1->sibling, $3); $$ = $1; }
            | list_content OL_OPEN list_items OL_CLOSE { addChild($1, createNode("ol")); addChild($1->sibling, $3); $$ = $1; }
            | list_content TABLE_OPEN table_rows TABLE_CLOSE { addChild($1, createNode("table")); addChild($1->sibling, $3); $$ = $1; }
            ;

%%

Node *createNode(char *tag) {
    Node *node = (Node *)malloc(sizeof(Node));
    node->tag = strdup(tag);
    node->child = NULL;
    node->sibling = NULL;
    return node;
}

void addChild(Node *parent, Node *child) {
    if (!parent->child) {
        parent->child = child;
    } else {
        Node *temp = parent->child;
        while (temp->sibling) temp = temp->sibling;
        temp->sibling = child;
    }
}

void printTree(Node *node, int depth) {
    if (!node) return;
    for (int i = 0; i < depth; i++) printf("  ");
    printf("%s\n", node->tag);
    printTree(node->child, depth + 1);
    printTree(node->sibling, depth);
}

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}

int main() {
    yydebug = 1;  
    yyparse();
    printTree(root, 0);
    return 0;
}
