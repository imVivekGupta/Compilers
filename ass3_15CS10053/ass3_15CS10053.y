%{
        #include <stdio.h>
        int yyerror(char *);    
         
%}

%token VOID
%token CHAR
%token SHORT 
%token INT
%token LONG 
%token FLOAT
%token DOUBLE
%token MATRIX
%token SIGNED
%token UNSIGNED
%token BOOL
%token ID       
%token CONST   
%token STRING  
%token LP
%token RP     
%token LSQ
%token RSQ
%token LB
%token RB
%token BREAK
%token CASE
%token DEFAULT
%token IF
%token ELSE
%token SWITCH
%token WHILE
%token DO
%token FOR
%token GOTO
%token CONTINUE
%token RETURN
%token SEMICOLON
%token COMMA
%token COLON
%token QUESTION
%token OR
%token AND
%token E
%token NE
%token L
%token LE
%token G
%token GE
%token EQ
%token SL
%token SR
%token INC
%token DEC
%token PLUS  
%token MINUS
%token MUL
%token DIV
%token MOD
%token MULA
%token DIVA
%token PLUSA
%token MINUSA
%token SLA
%token SRA
%token ANDA
%token EXPA
%token ORA  
%token MODA  
%token DOT
%token DEREF
%token BITAND
%token BITOR
%token NOT
%token EXP
%token TILDE
%token HASH
%token APOST
%token ERR

%start translation_unit
%%

primary_expression: ID      {printf("primary-expression => identifier\n");}
| CONST         {printf("primary-expression => constant\n");}
| STRING        {printf("primary-expression => string-literal\n");}
| LP expression RP    {printf("primary-expression => (expression)\n");}
;

expression: assignment_expression       {printf("expression => assignment-expression\n");}
| expression COMMA assignment_expression  {printf("expression => expression,assignment-expression\n");}
;

assignment_expression: conditional_expression   {printf("assignment-expression => conditional-expression\n");}
| unary_expression      assignment_operator     assignment_expression   {printf("assignment_expression => unary_expression assignment_operator assignment-expression\n");}
;

conditional_expression: logical_or      {printf("conditional-expression => logical-OR-expression\n");}
| logical_or QUESTION expression COLON conditional_expression  {printf("conditional-expression => logical-OR-expression ? expression : conditional_expression\n");}
;

logical_or:     logical_and     {printf("logical-OR-expression => logical-AND-expression\n");}
| logical_or OR logical_and   {printf("logical-OR-expression => logical-OR-expression || logical-AND-expression\n");}       
;

logical_and:    inclusive_or    {printf("logical-AND-expression => inclusive-OR-expression\n");}
| logical_and AND inclusive_or {printf("logical-AND-expression => logical-AND-expression && inclusive-OR-expression\n");}      
;

inclusive_or:  exclusive_or     {printf("inclusive-OR-expression => exclusive-OR-expression\n");}
| inclusive_or BITOR exclusive_or {printf("inclusive-OR-expression => inclusive-OR-expression | exclusive-OR-expression\n");}
;

exclusive_or:  and              {printf("exclusive-OR-expression => AND-expression\n");} 
| exclusive_or EXP and          {printf("exclusive-OR-expression => exclusive-OR-expression ^ AND-expression\n");} 
;

and:    equality                {printf("AND-expression => equality-expression\n");}
| and BITAND equality              {printf("AND-expression => AND-expression & equality-expression\n");}
;

equality:  relational           {printf("equality-expression => relational-expression\n");}
| equality E relational      {printf("equality-expression => equality-expression == relational-expression\n");} 
| equality NE relational      {printf("equality-expression => equality-expression != relational-expression\n");} 
;
 
relational: shift               {printf("relational-expression => shift-expression\n");} 
| relational L shift          {printf("relational-expression => relational-expression < shift-expression\n");}
| relational G shift          {printf("relational-expression => relational-expression > shift-expression\n");}
| relational LE shift          {printf("relational-expression => relational-expression <= shift-expression\n");}
| relational GE shift          {printf("relational-expression => relational-expression >= shift-expression\n");}
;
 
shift:  additive                {printf("shift-expression => additive-expression\n");} 
| shift SL additive           {printf("shift-expression => shift-expression << additive-expression\n");} 
| shift SR additive           {printf("shift-expression => shift-expression >> additive-expression\n");} 
;

additive: multiplicative        {printf("additive-expression => multiplicative-expression\n");}
| additive PLUS multiplicative   {printf("additive-expression => additive-expression + multiplicative-expression\n");}
| additive MINUS multiplicative   {printf("additive-expression => additive-expression - multiplicative-expression\n");}
;

multiplicative: cast            {printf("multiplicative-expression => cast-expression\n");}
| multiplicative MUL cast       {printf("multiplicative-expression => multiplicative-expression * cast-expression\n");}
| multiplicative DIV cast       {printf("multiplicative-expression => multiplicative-expression / cast-expression\n");}
| multiplicative MOD cast       {printf("multiplicative-expression => multiplicative-expression %% cast-expression\n");}
;

cast: unary_expression          {printf("cast-expression => unary-expression\n");}
;

unary_expression: postfix       {printf("unary-expression => postfix-expression\n");}
| INC unary_expression         {printf("unary-expression => ++unary-expression\n");}
| DEC unary_expression         {printf("unary-expression => --unary-expression\n");}
| unary_op cast                 {printf("unary-expression => unary-operator cast-expression\n");}
;

unary_op: BITAND                   {printf("unary-operator => &\n");}
| MUL                           {printf("unary-operator => *\n");}
| PLUS                          {printf("unary-operator => +\n");}
| MINUS                         {printf("unary-operator => -\n");}
;

postfix: primary_expression     {printf("postfix-expression => primary-expression\n");}
| postfix LSQ expression RSQ    {printf("postfix-expression => postfix-expression [expression]\n");}
| postfix LP args_opt RP      {printf("postfix-expression => postfix-expression(argument-expression-list-opt)\n");}
| postfix DOT ID                {printf("postfix-expression => postfix-expression.identifier\n");}
| postfix DEREF ID               {printf("postfix-expression => postfix-expression->identifier\n");}
| postfix INC                  {printf("postfix-expression => postfix-expression++\n");}
| postfix DEC                  {printf("postfix-expression => postfix-expression--\n");}
| postfix APOST                  {printf("postfix-expression => postfix-expression.'\n");}
;

args_opt:       
|       args_list       
;

args_list: assignment_expression        {printf("argument-expression-list => assignment-expression\n");}
| args_list COMMA assignment_expression   {printf("argument-expression-list => argument-expression-list,assignment-expression\n");}
;

const_expression: conditional_expression       {printf("constant-expression => conditional-expression\n");}
;

assignment_operator: EQ        {printf("assignment-operator => =\n");}
| MULA                          {printf("assignment-operator => *=\n");}
| DIVA                          {printf("assignment-operator => /=\n");}
| MODA                          {printf("assignment-operator => %%=\n");}
| PLUSA                          {printf("assignment-operator => +=\n");}
| MINUSA                          {printf("assignment-operator => -=\n");}
| SLA                          {printf("assignment-operator => <<=\n");}
| SRA                          {printf("assignment-operator => >>=\n");}
| ANDA                          {printf("assignment-operator => &=\n");}
| EXPA                          {printf("assignment-operator => ^=\n");}
| ORA                          {printf("assignment-operator => |=\n");}
;

/*declarations*/

declaration: declaration_specifiers init_opt SEMICOLON {printf("declaration => declaration-specifiers init-declarator-list-opt;\n");}
;

declaration_specifiers: type_specifier declaration_specifiers   {printf("declaration-specifiers => type-specifier declaration-specifiers \n");}
| type_specifier          {printf("declaration-specifiers => type-specifier\n");}
;

init_opt:               
| init_decl_list        
;

init_decl_list: init_decl      {printf("init-declarator-list => init-declarator\n");}
| init_decl_list COMMA init_decl      {printf("init-declarator-list => init-declarator-list,init-declarator\n");}
;

init_decl: decl {printf("init-declarator => declarator\n");}
| decl EQ initializer {printf("init-declarator => declarator = initializer\n");}  
;


type_specifier: VOID    {printf("type-specifier => void\n");}
| CHAR {printf("type-specifier => char\n");}
| SHORT {printf("type-specifier => short\n");}
| INT {printf("type-specifier => int\n");}
| LONG {printf("type-specifier => long\n");}
| FLOAT {printf("type-specifier => float\n");}
| DOUBLE {printf("type-specifier => double\n");}
| MATRIX {printf("type-specifier => Matrix\n");}
| SIGNED {printf("type-specifier => signed\n");}
| UNSIGNED{printf("type-specifier => unsigned\n");}
| BOOL {printf("type-specifier => Bool\n");}
;

decl: direct_decl {printf("declarator => direct-declarator\n");}
| pointer direct_decl {printf("declarator => pointer direct-declarator\n");}
;

direct_decl: ID  {printf("direct-declarator => identifier\n");}
| LP decl RP     {printf("direct-declarator => (declarator)\n");} 
| direct_decl LSQ RSQ {printf("direct-declarator => direct-declarator[]\n");} 
| direct_decl LSQ assignment_expression RSQ {printf("direct-declarator => direct-declarator[assignment-expression]\n");} 
| direct_decl LP param_type_list RP {printf("direct-declarator => direct-declarator(parameter-type-list)\n");} 
| direct_decl LP RP {printf("direct-declarator => direct-declarator()\n");} 
| direct_decl LP identifier_list RP {printf("direct-declarator => direct-declarator(identifier-list)\n");} 
;

pointer: MUL pointer {printf("pointer => *pointer\n");} 
| MUL {printf("pointer => *\n");} 
;

param_type_list: param_list {printf("parameter-type-list => parameter-list\n");} 
;

param_list: param_decl {printf("parameter-list => parameter-declaration\n");} 
| param_list COMMA param_decl {printf("parameter-list => parameter-list,parameter-declaration\n");} 
;

param_decl: declaration_specifiers decl {printf("parameter-declaration => declaration-specifiers declarator\n");} 
| declaration_specifiers                {printf("parameter-declaration => declaration-specifiers\n");} 
;

identifier_list: ID {printf("identifier-list => identifier\n");}
| identifier_list COMMA ID {printf("identifier-list => identifier-list,identifier\n");}
;

initializer: assignment_expression {printf("initializer => assignment-expression\n");}
| LB init_row_list RB {printf("initializer => {initializer-row-list}\n");}
;

init_row_list: init_row {printf("initializer-row-list => initializer-row\n");}
|init_row_list SEMICOLON init_row  {printf("initializer-row-list => initializer-row-list ; initializer-row\n");}
;

init_row: designation initializer {printf("initializer-row => designation initializer\n");}
| initializer {printf("initializer-row => initializer\n");}
| init_row COMMA designation initializer {printf("initializer-row => initializer-row, designation initializer\n");}
| init_row COMMA initializer {printf("initializer-row => initializer-row,initializer\n");}
;

designation: designator_list EQ {printf("designation => designator_list = \n");}
;

designator_list: designator {printf("designator_list => designator\n");}
| designator_list designator {printf("designator_list => designator_list designator\n");}
;

designator: LSQ const_expression RSQ {printf("designator => constant-expression\n");}
|DOT ID   {printf("designator => .identifier\n");}
;

/*statements*/

statement:labeled_statement     {printf("statement => labeled-statement\n");}
| compound_statement            {printf("statement => compound-statement\n");}
| expression_statement          {printf("statement => expression-statement\n");}
| selection_statement           {printf("statement => selection-statement\n");}
| iteration_statement           {printf("statement => iteration-statement\n");}
| jump_statement                {printf("statement => jump-statement\n");}
;       

labeled_statement: ID COLON  statement    {printf("labeled-statement => identifier : statement\n");}
| CASE const_expression COLON  statement          {printf("labeled-statement => case constant-expression : statement\n");}
| DEFAULT COLON  statement                        {printf("labeled-statement => default : statement\n");}
;

compound_statement: LB RB               {printf("compound-statement => {}\n");}
| LB block_item_list RB                 {printf("compound-statement => {block-item-list}\n");}      
;

block_item_list: block_item             {printf("block-item-list => block-item\n");}
| block_item_list block_item             {printf("block-item-list => block-item-list block-item\n");}
;

block_item: declaration                        {printf("block-item => declaration\n");}
| statement                             {printf("block-item => statement\n");}
;

expression_statement: expression SEMICOLON      {printf("expression-statement => expression;\n");}
| SEMICOLON                                     {printf("expression-statement => ;\n");}
;

selection_statement: IF LP expression RP statement      {printf("selection-statement => if(expression) statement\n");}
| IF LP expression RP statement ELSE statement    {printf("selection-statement => if(expression) statement else statement\n");}
| SWITCH LP expression RP statement                       {printf("selection-statement => switch(expression) statement\n");}
;

iteration_statement: WHILE LP expression RP statement    {printf("iteration-statement => while(expression) statement\n");}
| DO statement WHILE LP expression RP SEMICOLON                {printf("iteration-statement => do statement while(expression);\n");}     
| FOR LP exp_opt SEMICOLON exp_opt SEMICOLON exp_opt RP statement     {printf("iteration-statement => for(expression-opt;expression-opt;expression-opt) statement\n");}    
| FOR LP declaration exp_opt SEMICOLON exp_opt RP statement     {printf("iteration-statement => for(declaration expression-opt;expression-opt) statement\n");}
;

exp_opt: 
| expression
;

jump_statement: GOTO ID SEMICOLON                             {printf("jump-statement => goto identifier;\n");}
| CONTINUE SEMICOLON                                          {printf("jump-statement => continue;\n");}
| BREAK SEMICOLON                                             {printf("jump-statement => break;\n");}
| RETURN exp_opt SEMICOLON                                    {printf("jump-statement => return expression-opt;\n");}
;

/*external definitions*/
translation_unit: external_declaration                  {printf("translation-unit => external-declaration\n");}
| translation_unit external_declaration                 {printf("translation-unit => translation-unit external-declaration\n");}
;

external_declaration: function_definition               {printf("external-declaration => function-definition\n");}        
| declaration                                           {printf("external-declaration => declaration\n");}
;

function_definition: declaration_specifiers decl declaration_list compound_statement     {printf("function-definition => declaration-specifiers declarator declaration-list compound-statement\n");}
| declaration_specifiers decl compound_statement        {printf("function-definition => declaration-specifiers declarator compound-statement\n");}
;

declaration_list: declaration                           {printf("declaration-list => declaration\n");}        
| declaration_list declaration                          {printf("declaration-list => declaration-list declaration\n");}
;

%%
int yyerror(char *s){
  printf("Parser Error : %s\n",s);
  return -1;
}
