%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

%%

"<!DOCTYPE html>" { return DOCTYPE; }
"<html>"          { return HTML_OPEN; }
"</html>"         { return HTML_CLOSE; }
"<head>"          { return HEAD_OPEN; }
"</head>"         { return HEAD_CLOSE; }
"<title>"         { return TITLE_OPEN; }
"</title>"        { return TITLE_CLOSE; }
"<body>"          { return BODY_OPEN; }
"</body>"         { return BODY_CLOSE; }
"<p>"             { return P_OPEN; }
"</p>"            { return P_CLOSE; }
"<div>"           { return DIV_OPEN; }
"</div>"          { return DIV_CLOSE; }
"<h1>"            { return H1_OPEN; }
"</h1>"           { return H1_CLOSE; }
"<meta"           { return META; }
"<img"            { return IMG; }
"<!--"            { return COMMENT; }
"-->"             { return COMMENT; }
"<table>"         { return TABLE_OPEN; }
"</table>"        { return TABLE_CLOSE; }
"<tr>"            { return TR_OPEN; }
"</tr>"           { return TR_CLOSE; }
"<th>"            { return TH_OPEN; }
"</th>"           { return TH_CLOSE; }
"<td>"            { return TD_OPEN; }
"</td>"           { return TD_CLOSE; }
"<ul>"            { return UL_OPEN; }
"</ul>"           { return UL_CLOSE; }
"<ol>"            { return OL_OPEN; }
"</ol>"           { return OL_CLOSE; }
"<li>"            { return LI_OPEN; }
"</li>"           { return LI_CLOSE; }
"<style>[^<]*</style>" { yylval.str = strdup(yytext); return TEXT; } 
[a-zA-Z0-9,!.:@ ]+ { yylval.str = strdup(yytext); return TEXT; }
[ \t\n]+          { /* skip whitespace */ }
.                 { /* skip other characters */ }

%%

int yywrap() { return 1; }
