%{
    #include "ass4_15CS10053_translator.h"
    void yyerror(const char*);
    extern int yylex(void);
    using namespace std;
    int symbol_count = 0;
%}
/*
	Augmentations : M and N non terminals are introduced to allow for backpatching incase the label of GOTO is unknown during current parse 
*/

%union{
	string *strval; // to hold the value of enumeration constant
    declaration_str decl;   //to define the declarators
    arglistStr argsl; //to define the argumnets list
    int instr;  // to define the type used by M->(epsilon)
    int intval;   //to hold the value of integer constant
    char charval; //to hold the value of character constant
    identifier_str idl;    // to define the type for Identifier
    float floatval; //to hold the value of floating constant
    expr expon;   // to define the structure of expression
    list *nextlist;  //to define the nextlist type for N->(epsilon)
}

%token BREAK CASE CHAR CONTINUE DEFAULT DO DOUBLE ELSE 
%token FLOAT FOR GOTO IF INT LONG RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH MATRIX
%token TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE BOOL COMPLEX IMAGINARY
%token POINTER INCREMENT DECREMENT LEFT_SHIFT RIGHT_SHIFT LESS_EQUALS GREATER_EQUALS EQUALS NOT_EQUALS TRANSPOSE
%token AND OR ELLIPSIS MULTIPLY_ASSIGN DIVIDE_ASSIGN MODULO_ASSIGN ADD_ASSIGN SUBTRACT_ASSIGN
%token LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN SINGLE_LINE_COMMENT MULTI_LINE_COMMENT
%token <idl> IDENTIFIER  
%token <intval> INTEGER_CONSTANT
%token <floatval> FLOATING_CONSTANT
%token <charval> CHAR_CONST
%token <strval> STRING_LITERAL 
%type <expon> primary_expression postfix_expression unary_expression cast_expression multiplicative_expression additive_expression shift_expression relational_expression equality_expression AND_expression exclusive_OR_expression inclusive_OR_expression logical_AND_expression logical_OR_expression conditional_expression assignment_expression_opt assignment_expression constant_expression expression expression_statement expression_opt declarator direct_declarator initializer declaration init_declarator_list init_declarator_list_opt init_declarator initializer_list initializer_row_list


%type <nextlist> block_item_list block_item statement labeled_statement compound_statement selection_statement iteration_statement jump_statement block_item_list_opt
%type <argsl> argument_expression_list argument_expression_list_opt
%type <decl> type_specifier declaration_specifiers   pointer pointer_opt
%type <instr>       M
%type <nextlist>    N
%type <charval>     unary_operator

%start translation_unit

%left '+' '-'
%left '*' '/' '%'
%nonassoc UNARY

%%

N:{				// N is a list of quad array indices where backpatching needs to be done
    $$ = makelist(nxt_instr);
    global_quad.emit(quad(Q_GOTO, -1));
};

M:{					//M has integer attribute instr which stores the instruction number to jump to during backpatching
    $$ = nxt_instr;
};

/*Expressions*/
primary_expression:             IDENTIFIER {
                                                //Check whether its a function
                                                symdata * check_func = global_ST->lookup(*$1.name,true);
                                                if(check_func == NULL)
                                                {
                                                    $$.loc  =  curr_ST->lookup(*$1.name);
                                                    if($$.loc->tp_n != NULL && $$.loc->tp_n->basetp == tp_mat)
                                                    {
                                                        //If matrix
                                                        $$.mat = $$.loc;
                                                        $$.loc = curr_ST->gentemp(new node_type(tp_int));
                                                        $$.loc->i_val.int_val = 8;
                                                        $$.loc->isInitialized = true;
                                                        global_quad.emit(quad(Q_ASSIGN,8,$$.loc->name));
                                                        $$.type = $$.mat->tp_n;
                                                    }
                                                    else
                                                    {
                                                        // If not a matrix
                                                        
                                                        $$.type = $$.loc->tp_n;
                                                        if($$.mat != NULL)
                                                        	$$.mat = NULL;
                                                        if($$.isPointer)
                                                        	$$.isPointer = false;
                                                    }
                                                }
                                                else
                                                {
                                                    // It is a function
                                                    $$.loc = check_func;
                                                    $$.type = check_func->tp_n;
                                                    if($$.mat != NULL)
                                                    	$$.mat = NULL;
                                                    if($$.isPointer)
                                                    	$$.isPointer = false;
                                                    symbol_count++;
                                                }
                                            } |
                                INTEGER_CONSTANT {
                                                    // Declare and initialize the value of the temporary variable with the integer
                                                    $$.loc  = curr_ST->gentemp(new node_type(tp_int));
                                                    
                                                    $$.loc->i_val.int_val = $1;
                                                    $$.type = $$.loc->tp_n;
                                                    if(!$$.loc->isInitialized)
                                                    	$$.loc->isInitialized = true;
                                                     if($$.mat != NULL)
                                                    	$$.mat = NULL;
                                                    global_quad.emit(quad(Q_ASSIGN, $1, $$.loc->name));
                                                    symbol_count++;
                                                } |
                                FLOATING_CONSTANT {
                                                    // Declare and initialize the value of the temporary variable with the floatval
                                                    $$.loc  = curr_ST->gentemp(new node_type(tp_double));
                                                    $$.type = $$.loc->tp_n;
                                                    $$.loc->i_val.double_val = $1;
                                                    $$.loc->isInitialized = true;
                                                    $$.mat = NULL;
                                                    global_quad.emit(quad(Q_ASSIGN, $1, $$.loc->name));
                                                  } |
                                CHAR_CONST {
                                                // Declare and initialize the value of the temporary variable with the character
                                                $$.loc  = curr_ST->gentemp(new node_type(tp_char));
                                                $$.type = $$.loc->tp_n;
                                                $$.loc->i_val.char_val = $1;
                                                $$.loc->isInitialized = true;
                                                $$.mat = NULL;
                                                global_quad.emit(quad(Q_ASSIGN, $1, $$.loc->name));
                                            } |
                                STRING_LITERAL {} |
                                '(' expression ')' {
                                                        $$ = $2;
                                                   };

postfix_expression :            primary_expression {
                                                         $$ = $1;
                                                    } |
                                postfix_expression '[' expression ']' {
                                                                        //Explanation of Array handling
                                        
                                                                        $$.loc = curr_ST->gentemp(new node_type(tp_int));
                                                                        
                                                                        symdata* temporary = curr_ST->gentemp(new node_type(tp_int));
                                                                        
                                                                        char temp[10];
                                                                        
                                                                        sprintf(temp,"%d",$1.type->next->getSize());
                                                                        
                                                                        global_quad.emit(quad(Q_MULT,$3.loc->name,temp,temporary->name));
                                                                        global_quad.emit(quad(Q_PLUS,$1.loc->name,temporary->name,$$.loc->name));
                                                                        
                                                                        // the new size will be calculated and the temporary variable storing the size will be passed on a $$.loc
                                                                        
                                                                        //$$.mat <= base pointer
                                                                        $$.mat = $1.mat;
                                                                        
                                                                        //$$.type <= basetp(mat)
                                                                        $$.type = $1.type->next;

                                                                        //$$.mat->tp_n has the full type of the mat which will be used for size calculations
                                                                        symbol_count++;
                                                                     } |
                                postfix_expression '(' argument_expression_list_opt ')' {
                                                                                            //Explanation of Function Handling
                                                                                            $$.loc = curr_ST->gentemp(CopyType($1.type));
                                                                                            //temporary is created 
                                                                                            char str[10];
                                                                                            if($3.arguments == NULL)
                                                                                            {
                                                                                                //No function Parameters
                                                                                                sprintf(str,"0");
                                                                                                global_quad.emit(quad(Q_CALL,$1.loc->name,str,$$.loc->name));
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                for(int i=0;i<$3.arguments->size();i++)
                                                                                                {
                                                                                                    // To print the parameters 
                                                                                                    global_quad.emit(quad(Q_PARAM,(*$3.arguments)[i]->loc->name));
                                                                    
                                                                                                }
                                                                                                sprintf(str,"%ld",$3.arguments->size());
                                                                                                global_quad.emit(quad(Q_CALL,$1.loc->name,str,$$.loc->name));
                                                                                            }

                                                                                            $$.mat = NULL;
                                                                                            $$.type = $$.loc->tp_n;
                                                                                         } |
                                postfix_expression '.' IDENTIFIER {/*Struct Logic to be Skipped*/}|
                                postfix_expression POINTER IDENTIFIER {
                                                                            /*Not required*/
                                                                      } |
                                postfix_expression INCREMENT {
                                                                $$.loc = curr_ST->gentemp(CopyType($1.type));
                                                                if($1.mat != NULL)
                                                                {
                                                                    // Post increment of an array element
                                                                    symdata * temp_elem = curr_ST->gentemp(CopyType($1.type));
                                                                    global_quad.emit(quad(Q_RINDEX,$1.mat->name,$1.loc->name,$$.loc->name));
                                                                    global_quad.emit(quad(Q_RINDEX,$1.mat->name,$1.loc->name,temp_elem->name));
                                                                    global_quad.emit(quad(Q_PLUS,temp_elem->name,"1",temp_elem->name));
                                                                    global_quad.emit(quad(Q_LINDEX,$1.loc->name,temp_elem->name,$1.mat->name));
                                                                    $$.mat = NULL;
                                                                    symbol_count++;
                                                                }
                                                                else
                                                                {
                                                                    //post increment of an simple element
                                                                    global_quad.emit(quad(Q_ASSIGN,$1.loc->name,$$.loc->name));
                                                                    global_quad.emit(quad(Q_PLUS,$1.loc->name,"1",$1.loc->name));    
                                                                }
                                                                $$.type = $$.loc->tp_n;                                 
                                                             } |
                                postfix_expression DECREMENT {
                                                                $$.loc = curr_ST->gentemp(CopyType($1.type));
                                                                if($1.mat != NULL)
                                                                {
                                                                    // Post decrement of an array element
                                                                    symdata * temp_elem = curr_ST->gentemp(CopyType($1.type));
                                                                    global_quad.emit(quad(Q_RINDEX,$1.mat->name,$1.loc->name,$$.loc->name));
                                                                    global_quad.emit(quad(Q_RINDEX,$1.mat->name,$1.loc->name,temp_elem->name));
                                                                    global_quad.emit(quad(Q_MINUS,temp_elem->name,"1",temp_elem->name));
                                                                    global_quad.emit(quad(Q_LINDEX,$1.loc->name,temp_elem->name,$1.mat->name));
                                                                    $$.mat = NULL;
                                                                }
                                                                else
                                                                {
                                                                    //post decrement of an simple element
                                                                    global_quad.emit(quad(Q_ASSIGN,$1.loc->name,$$.loc->name));
                                                                    global_quad.emit(quad(Q_MINUS,$1.loc->name,"1",$1.loc->name));
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                              } |

                                postfix_expression TRANSPOSE {
                                									$$.loc = curr_ST->gentemp(CopyType($1.type));
                                									 if($1.mat != NULL)
                                                                	{
                                                                		global_quad.emit(quad(Q_TRANS,$1.loc->name,$$.loc->name));

                                                                	}
                                                                	$$.type = $$.loc->tp_n;
                                                                	symbol_count++;
                                							}
                                                              ;

argument_expression_list:       assignment_expression {
                                                        $$.arguments = new vector<expr*>;
                                                        expr * tex = new expr($1);
                                                        $$.arguments->push_back(tex);
                                                     }|
                                argument_expression_list ',' assignment_expression {
                                                                                        expr * tex = new expr($3);
                                                                                        $$.arguments->push_back(tex);
                                                                                    };

argument_expression_list_opt:   argument_expression_list {
                                                            $$ = $1;
                                                          }|
                                /*epsilon*/ {
                                                $$.arguments = NULL;
                                            };

unary_expression:               postfix_expression {
                                                        $$ = $1;
                                                   }|
                                INCREMENT unary_expression {
                                                                $$.loc = curr_ST->gentemp($2.type);
                                                                if($2.mat != NULL)
                                                                {
                                                                    // pre increment of an Array element 
                                                                    symdata * temp_elem = curr_ST->gentemp(CopyType($2.type));
                                                                    global_quad.emit(quad(Q_RINDEX,$2.mat->name,$2.loc->name,temp_elem->name));
                                                                    global_quad.emit(quad(Q_PLUS,temp_elem->name,"1",temp_elem->name));
                                                                    global_quad.emit(quad(Q_LINDEX,$2.loc->name,temp_elem->name,$2.mat->name));
                                                                    global_quad.emit(quad(Q_RINDEX,$2.mat->name,$2.loc->name,$$.loc->name));
                                                                    $$.mat = NULL;
                                                                    symbol_count++;
                                                                }
                                                                else
                                                                {
                                                                    // pre increment
                                                                    global_quad.emit(quad(Q_PLUS,$2.loc->name,"1",$2.loc->name));
                                                                    global_quad.emit(quad(Q_ASSIGN,$2.loc->name,$$.loc->name));
                                                                    symbol_count++;
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                            }|
                                DECREMENT unary_expression {
                                                                $$.loc = curr_ST->gentemp(CopyType($2.type));
                                                                if($2.mat != NULL)
                                                                {
                                                                    //pre decrement of  Array Element 
                                                                    symdata * temp_elem = curr_ST->gentemp(CopyType($2.type));
                                                                    global_quad.emit(quad(Q_RINDEX,$2.mat->name,$2.loc->name,temp_elem->name));
                                                                    global_quad.emit(quad(Q_MINUS,temp_elem->name,"1",temp_elem->name));
                                                                    global_quad.emit(quad(Q_LINDEX,$2.loc->name,temp_elem->name,$2.mat->name));
                                                                    global_quad.emit(quad(Q_RINDEX,$2.mat->name,$2.loc->name,$$.loc->name));
                                                                    if($$.mat != NULL)
                                                                    	$$.mat = NULL;
                                                                    symbol_count++;
                                                                }
                                                                else
                                                                {
                                                                    // pre decrement
                                                                    global_quad.emit(quad(Q_MINUS,$2.loc->name,"1",$2.loc->name));
                                                                    global_quad.emit(quad(Q_ASSIGN,$2.loc->name,$$.loc->name));
                                                                    symbol_count++;
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                                symbol_count++;
                                                            }|
                                unary_operator cast_expression
                                                                {
                                                                    node_type * temp_type;
                                                                    switch($1)
                                                                    {
                                                                        case '&':
                                                                            //create a temporary type store the type
                                                                            temp_type = new node_type(tp_ptr,1,$2.type);
                                                                            $$.loc = curr_ST->gentemp(CopyType(temp_type));
                                                                            $$.type = $$.loc->tp_n;
                                                                            global_quad.emit(quad(Q_ADDR,$2.loc->name,$$.loc->name));
                                                                            symbol_count++;
                                                                            $$.mat = NULL;
                                                                            break;
                                                                        case '*':
                                                                            if(!$$.isPointer)
                                                                            	$$.isPointer = true;
                                                                            $$.type = $2.loc->tp_n->next;
                                                                            $$.loc = $2.loc;
                                                                            if($$.mat != NULL)
                                                                            	$$.mat = NULL;
                                                                            symbol_count++;
                                                                            break;
                                                                        case '+':
                                                                            $$.loc = curr_ST->gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc->tp_n;
                                                                            global_quad.emit(quad(Q_ASSIGN,$2.loc->name,$$.loc->name));
                                                                            symbol_count++;
                                                                            break;
                                                                        case '-':
                                                                            $$.loc = curr_ST->gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc->tp_n;
                                                                            global_quad.emit(quad(Q_UNARY_MINUS,$2.loc->name,$$.loc->name));
                                                                            symbol_count++;
                                                                            break;
                                                                        case '~':
                                                                            /*Bitwise Not to be implemented Later on*/
                                                                            $$.loc = curr_ST->gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc->tp_n;
                                                                            global_quad.emit(quad(Q_NOT,$2.loc->name,$$.loc->name));
                                                                            break;
                                                                            symbol_count++;
                                                                        case '!':
                                                                            $$.loc = curr_ST->gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc->tp_n;
                                                                            $$.truelist = $2.falselist;
                                                                            $$.falselist = $2.truelist;
                                                                            break;
                                                                        default:symbol_count++;
                                                                            break;
                                                                    }
                                                                };

unary_operator  :               '&' {
                                        $$ = '&';
                                    }|
                                '*' {
                                        $$ = '*';
                                    }|
                                '+' {
                                        $$ = '+';
                                    }|
                                '-' {
                                        $$ = '-';
                                    }|
                                '~' {
                                        $$ = '~';
                                    }|
                                '!' {
                                        $$ = '!';
                                    };

cast_expression :               unary_expression {
                                                    if($1.mat != NULL && $1.mat->tp_n != NULL)
                                                    {
                                                        //Right Indexing of an array element as unary expression is converted into cast expression
                                                        $$.loc = curr_ST->gentemp(new node_type($1.type->basetp));
                                                        global_quad.emit(quad(Q_RINDEX,$1.mat->name,$1.loc->name,$$.loc->name));
                                                        $$.mat = NULL;
                                                        $$.type = $$.loc->tp_n;
                                                        symbol_count++;
                                                    }
                                                    else if($1.isPointer == true)
                                                    {
                                                        //RDereferencing as its a pointer
                                                        $$.loc = curr_ST->gentemp(CopyType($1.type));
                                                        $$.isPointer = false;
                                                        global_quad.emit(quad(Q_RDEREF,$1.loc->name,$$.loc->name));
                                                        symbol_count++;
                                                    }
                                                    else
                                                        $$ = $1;
                                                };

multiplicative_expression:      cast_expression {
                                                    $$ = $1;
                                                }|
                                multiplicative_expression '*' cast_expression {
                                                                                    typecheck(&$1,&$3);
                                                                                    $$.loc = curr_ST->gentemp($1.type);
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    global_quad.emit(quad(Q_MULT,$1.loc->name,$3.loc->name,$$.loc->name));
                                                                                    symbol_count++;
                                                                              }|
                                multiplicative_expression '/' cast_expression {
                                                                                    typecheck(&$1,&$3);
                                                                                    $$.loc = curr_ST->gentemp($1.type);
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    global_quad.emit(quad(Q_DIVIDE,$1.loc->name,$3.loc->name,$$.loc->name));
                                                                                    symbol_count++;
                                                                              }|
                                multiplicative_expression '%' cast_expression{
                                                                                    typecheck(&$1,&$3);
                                                                                    $$.loc = curr_ST->gentemp($1.type);
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    global_quad.emit(quad(Q_MODULO,$1.loc->name,$3.loc->name,$$.loc->name));
                                                                                    symbol_count++;
                                                                             };

additive_expression :           multiplicative_expression {
                                                                $$ = $1;
                                                          }|
                                additive_expression '+' multiplicative_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        $$.loc = curr_ST->gentemp($1.type);
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        global_quad.emit(quad(Q_PLUS,$1.loc->name,$3.loc->name,$$.loc->name));
                                                                                        symbol_count++;
                                                                                  }|
                                additive_expression '-' multiplicative_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        $$.loc = curr_ST->gentemp($1.type);
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        global_quad.emit(quad(Q_MINUS,$1.loc->name,$3.loc->name,$$.loc->name));
                                                                                        symbol_count++;
                                                                                  };

shift_expression:               additive_expression {
                                                        $$ = $1;
                                                    }|
                                shift_expression LEFT_SHIFT additive_expression {
                                                                                    $$.loc = curr_ST->gentemp($1.type);
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    global_quad.emit(quad(Q_LEFT_OP,$1.loc->name,$3.loc->name,$$.loc->name));
                                                                                    symbol_count++;
                                                                                }|
                                shift_expression RIGHT_SHIFT additive_expression{
                                                                                    $$.loc = curr_ST->gentemp($1.type);
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    global_quad.emit(quad(Q_RIGHT_OP,$1.loc->name,$3.loc->name,$$.loc->name));
                                                                                    quad(Q_RIGHT_OP,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                    symbol_count++;
                                                                                };

relational_expression:          shift_expression {
                                                        $$ = $1;
                                                 }|
                                relational_expression '<' shift_expression {
                                                                                typecheck(&$1,&$3);
                                                                                $$.type = new node_type(tp_bool);
                                                                                $$.truelist = makelist(nxt_instr);
                                                                                $$.falselist = makelist(nxt_instr+1);
                                                                                propagate($$.truelist);
                                                                                propagate($$.falselist);
                                                                                global_quad.emit(quad(Q_IF_LESS,$1.loc->name,$3.loc->name,"-1"));
                                                                                global_quad.emit(quad(Q_GOTO,"-1"));
                                                                                symbol_count++;
                                                                           }|
                                relational_expression '>' shift_expression {
                                                                                typecheck(&$1,&$3);
                                                                                $$.type = new node_type(tp_bool);
                                                                                $$.truelist = makelist(nxt_instr);
                                                                                $$.falselist = makelist(nxt_instr+1);
                                                                                global_quad.emit(quad(Q_IF_GREATER,$1.loc->name,$3.loc->name,"-1"));
                                                                                global_quad.emit(quad(Q_GOTO,"-1"));
                                                                                symbol_count++;
                                                                           }|
                                relational_expression LESS_EQUALS shift_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        $$.type = new node_type(tp_bool);
                                                                                        $$.truelist = makelist(nxt_instr);
                                                                                        $$.falselist = makelist(nxt_instr+1);
                                                                                        global_quad.emit(quad(Q_IF_LESS_OR_EQUAL,$1.loc->name,$3.loc->name,"-1"));
                                                                                        global_quad.emit(quad(Q_GOTO,"-1"));
                                                                                        symbol_count++;
                                                                                    }|
                                relational_expression GREATER_EQUALS shift_expression {
                                                                                            typecheck(&$1,&$3);
                                                                                            $$.type = new node_type(tp_bool);
                                                                                            quad(Q_GOTO,"-1");
                                                                                            $$.truelist = makelist(nxt_instr);
                                                                                            $$.falselist = makelist(nxt_instr+1);
                                                                                            global_quad.emit(quad(Q_IF_GREATER_OR_EQUAL,$1.loc->name,$3.loc->name,"-1"));
                                                                                            global_quad.emit(quad(Q_GOTO,"-1"));
                                                                                            symbol_count++;
                                                                                      };

equality_expression:            relational_expression {
                                                            $$ = $1;
                                                      }|
                                equality_expression EQUALS relational_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        $$.type = new node_type(tp_bool);
                                                                                        $$.truelist = makelist(nxt_instr);
                                                                                        $$.falselist = makelist(nxt_instr+1);
                                                                                        global_quad.emit(quad(Q_IF_EQUAL,$1.loc->name,$3.loc->name,"-1"));
                                                                                        global_quad.emit(quad(Q_GOTO,"-1"));
                                                                                        quad(Q_GOTO,"-1");
                                                                                        symbol_count++;
                                                                                 }|
                                equality_expression NOT_EQUALS relational_expression {
                                                                                            typecheck(&$1,&$3);
                                                                                            $$.type = new node_type(tp_bool);
                                                                                            $$.truelist = makelist(nxt_instr);
                                                                                            $$.falselist = makelist(nxt_instr+1);
                                                                                            global_quad.emit(quad(Q_IF_NOT_EQUAL,$1.loc->name,$3.loc->name,"-1"));
                                                                                            symbol_count++;
                                                                                            quad(Q_GOTO,"-1");
                                                                                            global_quad.emit(quad(Q_GOTO,"-1"));
                                                                                     };

AND_expression :                equality_expression {
                                                        $$ = $1;
                                                        symbol_count++;
                                                    }|
                                AND_expression '&' equality_expression {
                                                                            $$.loc = curr_ST->gentemp($1.type);
                                                                            $$.type = $$.loc->tp_n;
                                                                            symbol_count++;
                                                                            global_quad.emit(quad(Q_LOG_AND,$1.loc->name,$3.loc->name,$$.loc->name));
                                                                            symbol_count++;
                                                                        };

exclusive_OR_expression:        AND_expression {
                                                    $$ = $1;
                                               }|
                                exclusive_OR_expression '^' AND_expression {
                                                                                $$.loc = curr_ST->gentemp($1.type);
                                                                                $$.type = $$.loc->tp_n;
                                                                                global_quad.emit(quad(Q_XOR,$1.loc->name,$3.loc->name,$$.loc->name));
                                                                                symbol_count++;
                                                                           };

inclusive_OR_expression:        exclusive_OR_expression {
                                                            $$ = $1;
                                                        }|
                                inclusive_OR_expression '|' exclusive_OR_expression {
                                                                                        $$.loc = curr_ST->gentemp($1.type);
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        symbol_count++;
                                                                                        global_quad.emit(quad(Q_LOG_OR,$1.loc->name,$3.loc->name,$$.loc->name));
                                                                                    };

logical_AND_expression:         inclusive_OR_expression {
                                                            $$ = $1;
                                                        }|
                                logical_AND_expression AND M inclusive_OR_expression {
                                                                                        if($1.type->basetp != tp_bool)
                                                                                            conv2Bool(&$1);
                                                                                        if($4.type->basetp != tp_bool)
                                                                                            conv2Bool(&$4);
                                                                                        backpatch($1.truelist,$3);
                                                                                        $$.type = new node_type(tp_bool);
                                                                                        $$.falselist = merge($1.falselist,$4.falselist);
                                                                                        $$.truelist = $4.truelist;
                                                                                        symbol_count++;
                                                                                    };

logical_OR_expression:          logical_AND_expression {
                                                            $$ = $1;
                                                       }|
                                logical_OR_expression OR M logical_AND_expression   {
                                                                                        if($1.type->basetp != tp_bool)
                                                                                            conv2Bool(&$1);
                                                                                        if($4.type->basetp != tp_bool)
                                                                                            conv2Bool(&$4); 
                                                                                        backpatch($1.falselist,$3);
                                                                                        $$.type = new node_type(tp_bool);
                                                                                        $$.truelist = merge($1.truelist,$4.truelist);
                                                                                        $$.falselist = $4.falselist;
                                                                                        symbol_count++;
                                                                                    };

/*It is assumed that type of expression and conditional expression are same*/
conditional_expression:         logical_OR_expression {
                                                            $$ = $1;
                                                      }|
                                logical_OR_expression N '?' M expression N ':' M conditional_expression {
                                                                                                            $$.loc = curr_ST->gentemp($5.type);
                                                                                                            $$.type = $$.loc->tp_n;
                                                                                                            global_quad.emit(quad(Q_ASSIGN,$9.loc->name,$$.loc->name));
                                                                                                            list* TEMP_LIST = makelist(nxt_instr);
                                                                                                            global_quad.emit(quad(Q_GOTO,"-1"));
                                                                                                            backpatch($6,nxt_instr);
                                                                                                            global_quad.emit(quad(Q_ASSIGN,$5.loc->name,$$.loc->name));
                                                                                                            TEMP_LIST = merge(TEMP_LIST,makelist(nxt_instr));
                                                                                                            global_quad.emit(quad(Q_GOTO,"-1"));
                                                                                                            backpatch($2,nxt_instr);
                                                                                                            conv2Bool(&$1);
                                                                                                            backpatch($1.truelist,$4);
                                                                                                            backpatch($1.falselist,$8);
                                                                                                            backpatch(TEMP_LIST,nxt_instr);
                                                                                                            symbol_count++;
                                                                                                        };

assignment_operator:            '='                                                     |
								ADD_ASSIGN                                              |
                                SUBTRACT_ASSIGN                                         |
                                LEFT_SHIFT_ASSIGN                                       |
                                MULTIPLY_ASSIGN                                         |
                                DIVIDE_ASSIGN                                           |
                                MODULO_ASSIGN                                           |
                                RIGHT_SHIFT_ASSIGN                                      |
                                AND_ASSIGN                                              |
                                XOR_ASSIGN                                              |
                                OR_ASSIGN                                               ;

assignment_expression:          conditional_expression {
                                                            $$ = $1;
                                                        }|
                                unary_expression assignment_operator assignment_expression {
                                                                                                //LDereferencing
                                                                                                if($1.isPointer)
                                                                                                {
                                                                                                    global_quad.emit(quad(Q_LDEREF,$3.loc->name,$1.loc->name));
                                                                                                }
                                                                                                typecheck(&$1,&$3,true);
                                                                                                if($1.mat != NULL)
                                                                                                {
                                                                                                    global_quad.emit(quad(Q_LINDEX,$1.loc->name,$3.loc->name,$1.mat->name));
                                                                                                }
                                                                                                else if(!$1.isPointer)
                                                                                                    global_quad.emit(quad(Q_ASSIGN,$3.loc->name,$1.loc->name));
                                                                                                $$.loc = curr_ST->gentemp($3.type);
                                                                                                $$.type = $$.loc->tp_n;
                                                                                                global_quad.emit(quad(Q_ASSIGN,$3.loc->name,$$.loc->name));
                                                                                                symbol_count++;
                                                                                            };

/*A constant value of this expression exists*/
constant_expression:            conditional_expression {
                                                            $$ = $1;
                                                       };

expression :                    assignment_expression {
                                                            $$ = $1;
                                                      }|
                                expression ',' assignment_expression {
                                                                        $$ = $3;
                                                                     };

/*Declarations*/ 

declaration:                    declaration_specifiers init_declarator_list_opt ';' {
                                                                                        if($2.loc != NULL && $2.type != NULL && $2.type->basetp == tp_func)
                                                                                        {
                                                                                            /*Delete curr_ST*/
                                                                                            curr_ST = new symtab();
                                                                                        }
                                                                                    };

init_declarator_list_opt:       init_declarator_list {
                                                        if($1.type != NULL && $1.type->basetp == tp_func)
                                                        {
                                                            $$ = $1;
                                                        }
                                                     }|
                                /*epsilon*/ {
                                                $$.loc = NULL;
                                            };

declaration_specifiers:         type_specifier declaration_specifiers_opt              ;

declaration_specifiers_opt:     declaration_specifiers                                  |
                                /*epsilon*/                                             ;

init_declarator_list:           init_declarator {
                                                    /*Expecting only function declaration*/
                                                    $$ = $1;
                                                }|
                                init_declarator_list ',' init_declarator                ;

init_declarator:                declarator {
                                                /*Nothing to be done here*/
                                                if($1.type != NULL && $1.type->basetp == tp_func)
                                                {
                                                    $$ = $1;
                                                }
                                                //$$ = $1;
                                            }|
                                declarator '=' initializer {
                                                                //initializations of declarators
                                                                typecheck(&$1,&$3,true);
                                                                global_quad.emit(quad(Q_ASSIGN,$3.loc->name,$1.loc->name));
                                                                $1.loc->i_val = $3.loc->i_val;
                                                                $1.loc->isInitialized = true;
                                                                symbol_count++;
                                                            };

type_specifier:                 VOID {
                                        global_type = new node_type(tp_void);
                                    }|
                                CHAR {
                                        global_type = new node_type(tp_char);
                                    }|
                                SHORT {}|
                                INT {
                                        global_type = new node_type(tp_int);
                                    }|
                                DOUBLE {
                                            global_type = new node_type(tp_double);
                                        }|
                                SIGNED {}|
                                UNSIGNED {}|
                                BOOL {}|
                                LONG {}|
                                FLOAT {}|
                                MATRIX	{	global_type = new node_type(tp_mat);}	
                                ;

declarator :                    pointer_opt direct_declarator {
                                                                if($1.type == NULL)
                                                                {
                                                                    /*--------------*/
                                                                }
                                                                else
                                                                {
                                                                    if($2.loc->tp_n->basetp != tp_ptr)
                                                                    {
                                                                        node_type * test = $1.type;
                                                                        while(test->next != NULL)
                                                                        {
                                                                            test = test->next;
                                                                        }
                                                                        test->next = $2.loc->tp_n;
                                                                        $2.loc->tp_n = $1.type;
                                                                        symbol_count++;
                                                                    }
                                                                }

                                                                if($2.type != NULL && $2.type->basetp == tp_func)
                                                                {
                                                                    $$ = $2;
                                                                }
                                                                else
                                                                {
                                                                    //its not a function
                                                                    $2.loc->size = $2.loc->tp_n->getSize();
                                                                    $2.loc->offset = curr_ST->offset;
                                                                    curr_ST->offset += $2.loc->size;
                                                                    $$ = $2;
                                                                    $$.type = $$.loc->tp_n;
                                                                }
                                                            };

pointer_opt:                    pointer {
                                            $$ = $1;
                                        }|
                                /*epsilon*/ {
                                                $$.type = NULL;
                                            };

direct_declarator:              IDENTIFIER {
                                                    $$.loc = curr_ST->lookup(*$1.name);
                                                    if($$.loc->var_type == "")
                                                    {
                                                        //Type initialization
                                                        
                                                        $$.loc->tp_n = new node_type(global_type->basetp);
                                                        $$.loc->var_type = "local";
                                                        symbol_count++;
                                                    }
                                                    $$.type = $$.loc->tp_n;
                                            }|
                                '(' declarator ')' {
                                                        $$ = $2;
                                                    }|
                                direct_declarator '['  assignment_expression_opt ']' {
                                                                                                        if($1.type->next==NULL){
                                                                                                        	node_type *temp = $1.type;
                                                                                                        	 if($3.loc == NULL)
                                                                                                                        $1.type = new node_type(tp_mat,-1,$1.type);
                                                                                                                    else
                                                                                                                        $1.type = new node_type(tp_mat,$3.loc->i_val.int_val,$1.type);
                                                                                                            $1.type->next = temp;
                                                                                                            temp->basetp = tp_double;            
                                                                                                        }
                                                                                                        else{
                                                                                                       				node_type * typ1 = $1.type,*typ = $1.type;
                                                                                                                    typ1 = typ1->next;
                                                                                                                    while(typ1->next != NULL)
                                                                                                                    {
                                                                                                                        typ1 = typ1->next;
                                                                                                                        typ = typ->next;
                                                                                                                    }
                                                                                                                    typ->next = new node_type(tp_mat,$3.loc->i_val.int_val,typ1);
                                                                                                            }


                                                                                                                $$ = $1;
                                                                                                                $$.loc->tp_n = $$.type;
																												symbol_count++;

                                                                                                            }|
                               
                                direct_declarator '(' parameter_type_list ')' {
                                                                                    symdata * new_func = global_ST->lookup(curr_ST->symbol_tab[0]->name,true);
                                                                                    //printf("Hello1\n");
                                                                                    if(new_func != NULL)
                                                                                    {
                                                                                    	curr_ST = new_func->nest_tab;
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        
                                                                                        new_func = global_ST->lookup(curr_ST->symbol_tab[0]->name);
                                                                                        $$.loc = curr_ST->symbol_tab[0];
                                                                                        if(new_func->var_type == "")
                                                                                        {
                                                                                        	new_func->var_type = "func";
                                                                                            // Declaration of the function for the first time
                                                                                            new_func->tp_n = CopyType(curr_ST->symbol_tab[0]->tp_n);
                                                                                            if(new_func->isInitialized)
                                                                                            	new_func->isInitialized = false;
                                                                                            new_func->nest_tab = curr_ST;
                                                                                            curr_ST->name = curr_ST->symbol_tab[0]->name;
                                                                                            //curr_ST->symbol_tab[0]->name = "retVal";
                                                                                            curr_ST->symbol_tab[0]->var_type = "return";
                                                                                            curr_ST->symbol_tab[0]->size = curr_ST->symbol_tab[0]->tp_n->getSize();
                                                                                            curr_ST->symbol_tab[0]->offset = 0;
                                                                                            curr_ST->offset = curr_ST->symbol_tab[0]->size;
                                                                                            int i=1;
                                                                                            while(i<curr_ST->symbol_tab.size())
                                                                                            {
                                                                                                curr_ST->symbol_tab[i]->offset += curr_ST->symbol_tab[0]->size;

                                                                                                curr_ST->symbol_tab[i]->var_type = "param";
                                                                                                
                                                                                                curr_ST->offset += curr_ST->symbol_tab[i]->size;
                                                                                                i++;
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    $$.loc = new_func;
                                                                                    $$.type = new node_type(tp_func);
                                                                                    symbol_count++;
                                                                                }|
                                direct_declarator '(' identifier_list_opt ')' {
                                                                                symdata * new_func = global_ST->lookup(curr_ST->symbol_tab[0]->name,true);
                                                                                if(new_func != NULL)
                                                                                {
                                                                                    // Already declared function. Therefore drop the new table and connect current symbol table pointer to the previously created funciton symbol table
                                                                                    curr_ST = new_func->nest_tab;
                                                                                }
                                                                                else
                                                                                {
                                                                                    new_func = global_ST->lookup(curr_ST->symbol_tab[0]->name);
                                                                                    $$.loc = curr_ST->symbol_tab[0];
                                                                                    if(new_func->var_type == "")
                                                                                    {
                                                                                        /*Function is being declared here for the first time*/
                                                                                        new_func->tp_n = CopyType(curr_ST->symbol_tab[0]->tp_n);
                                                                                        new_func->var_type = "func";
                                                                                        new_func->isInitialized = false;
                                                                                        new_func->nest_tab = curr_ST;
                                                                                        /*Change the first element to retval and change the rest to param*/
                                                                                        curr_ST->name = curr_ST->symbol_tab[0]->name;
                                                                                        //curr_ST->symbol_tab[0]->name = "retVal";
                                                                                        curr_ST->symbol_tab[0]->var_type = "return";
                                                                                        curr_ST->symbol_tab[0]->size = curr_ST->symbol_tab[0]->tp_n->getSize();
                                                                                        curr_ST->symbol_tab[0]->offset = 0;
                                                                                        curr_ST->offset = curr_ST->symbol_tab[0]->size;
                                                                                    }
                                                                                }
                                                                                
                                                                                $$.loc = new_func;
                                                                                $$.type = new node_type(tp_func);
                                                                                symbol_count++;
                                                                            };



assignment_expression_opt:      assignment_expression {
                                                            $$ = $1;
                                                        }|
                                /*epsilon*/ {
                                                $$.loc = NULL;
                                            };

identifier_list_opt:            identifier_list                                         |
                                /*epsilon*/                                             ;

pointer:                        '*'  {
                                                                $$.type = new node_type(tp_ptr);
                                                            }|
                                '*'  pointer {
                                                                        $$.type = new node_type(tp_ptr,1,$2.type);
                                                                    };

parameter_type_list:            parameter_list {
                                                    /*-------*/
                                                }|
                                parameter_list ',' ELLIPSIS {};

parameter_list:                 parameter_declaration {
                                                            /*---------*/
                                                        }|
                                parameter_list ',' parameter_declaration {
                                                                            /*------------*/
                                                                        };

parameter_declaration:          declaration_specifiers declarator {
                                                                        /*The parameter is already added to the current Symbol Table*/
                                                                  }|
                                declaration_specifiers {};

identifier_list :               IDENTIFIER                                              |
                                identifier_list ',' IDENTIFIER                          ;


initializer:                    assignment_expression {
                                    $$ = $1;
                                    symbol_count++;
                                }|

                                '{' initializer_row_list '}' { 
                                	$$ = $2;
                                	sprintf($$.loc->i_val.mat_val,"{%s}",$2.loc->i_val.mat_val);
                                	 $$.type->basetp = tp_mat;
                                	};
                                
initializer_row_list:	initializer_list    { $$ = $1;}|
						initializer_row_list ';' initializer_list {$$ = $1;
							sprintf($$.loc->i_val.mat_val,"%s ;%s",$1.loc->i_val.mat_val,$3.loc->i_val.mat_val);
							 						
							 };

initializer_list:               designation_opt initializer                        {$$=$2;
								
										sprintf($$.loc->i_val.mat_val, "%lf",$2.loc->i_val.double_val);

								 }     |
                                initializer_list ',' designation_opt initializer 
                                {
                                	$$ = $1;
                                	char buf[10];
									sprintf($$.loc->i_val.mat_val, "%s,%lf",$1.loc->i_val.mat_val ,$4.loc->i_val.double_val);
									
                                }
                                       ;                                                                                                                           

designation_opt:                designation                                             |
                                /*Epslion*/                                             ;

designation:                    designator_list '='                                     ;

designator_list:                designator                                              |
                                designator_list designator                              ;

designator:                     '[' constant_expression ']'                             |
                                '.' IDENTIFIER {};

/*Statements*/
statement:                      labeled_statement {/*Switch Case*/}|
                                compound_statement {
                                                        $$ = $1;
                                                    }|
                                expression_statement {
                                                        $$ = NULL;
                                                    }|
                                selection_statement {
                                                        $$ = $1;
                                                    }|
                                iteration_statement {
                                                        $$ = $1;
                                                    }|
                                jump_statement {
                                                    $$ = $1;
                                                };

labeled_statement:              IDENTIFIER ':' statement {}|
                                CASE constant_expression ':' statement {}|
                                DEFAULT ':' statement {};

compound_statement:             '{' block_item_list_opt '}' {
                                                                $$ = $2;
                                                            };

block_item_list_opt:            block_item_list {
                                                    $$ = $1;
                                                }|  
                                /*Epslion*/ {
                                                $$ = NULL;
                                            };

block_item_list:                block_item {
                                                $$ = $1;
                                            }|
                                block_item_list M block_item {
                                                                    backpatch($1,$2);
                                                                    $$ = $3;
                                                             };

block_item:                     declaration {
                                                $$ = NULL;
                                            }|
                                statement {
                                                $$ = $1;
                                          };

expression_statement:           expression_opt ';'{
                                                        $$ = $1;
                                                  };

expression_opt:                 expression {
                                                $$ = $1;
                                           }|
                                /*Epslion*/ {
                                                /*Initialize Expression to NULL*/
                                                $$.loc = NULL;
                                            };

selection_statement:            IF '(' expression N ')' M statement N ELSE M statement {
                                                                                            /*N1 is used for falselist of expression, M1 is used for truelist of expression, N2 is used to prevent fall through, M2 is used for falselist of expression*/
                                                                                            $7 = merge($7,$8);
                                                                                            $11 = merge($11,makelist(nxt_instr));
                                                                                            symbol_count++;
                                                                                            global_quad.emit(quad(Q_GOTO,"-1"));
                                                                                            backpatch($4,nxt_instr);
                                                                                            conv2Bool(&$3);
                                                                                            if(symbol_count>0) symbol_count++;
                                                                                            backpatch($3.truelist,$6);
                                                                                            backpatch($3.falselist,$10);
                                                                                            $$ = merge($7,$11);
                                                                                        }|
                                IF '(' expression N ')' M statement {
                                                                        /*N is used for the falselist of expression to skip the block and M is used for truelist of expression*/
                                                                        $7 = merge($7,makelist(nxt_instr));

                                                                        global_quad.emit(quad(Q_GOTO,"-1"));
                                                                        backpatch($4,nxt_instr);
                                                                        conv2Bool(&$3);
                                                                        backpatch($3.truelist,$6);
                                                                        $$ = merge($7,$3.falselist);
                                                                        symbol_count++;
                                                                    }|
                                SWITCH '(' expression ')' statement {};

iteration_statement:            WHILE '(' M expression N ')' M statement {
                                                                            /*The first 'M' takes into consideration that the control will come again at the beginning of the condition checking.'N' here does the work of breaking condition i.e. it generate goto which will be useful when we are exiting from while loop. Finally, the last 'M' is here to note the starting of the statement that will be executed in every loop to populate the truelists of expression*/
                                                                            global_quad.emit(quad(Q_GOTO,$3));
                                                                            backpatch($8,$3);           /*S.nextlist to M1.instr*/
                                                                            backpatch($5,nxt_instr);    /*N1.nextlist to nxt_instr*/
                                                                            //backpatch($4.falselist,nxt_instr +1);
                                                                            conv2Bool(&$4);
                                                                            backpatch($4.truelist,$7);
                                                                            $$ = $4.falselist;
                                                                            symbol_count++;
                                                                        }|
                                DO M statement  WHILE '(' M expression N ')' ';' {  
                                                                                    /*M1 is used for coming back again to the statement as it stores the instruction which will be needed by the truelist of expression. M2 is neede as we have to again to check the condition which will be used to populate the nextlist of statements. Further N is used to prevent from fall through*/
                                                                                    backpatch($8,nxt_instr);
                                                                                    backpatch($3,$6);           /*S1.nextlist to M2.instr*/
                                                                                    conv2Bool(&$7);
                                                                                    backpatch($7.truelist,$2);  /*B.truelist to M1.instr*/
                                                                                    $$ = $7.falselist;
                                                                                    symbol_count++;
                                                                                }|
                                FOR '(' expression_opt ';' M expression_opt N ';' M expression_opt N ')' M statement {
                                                                                                                       /*M1 is used for coming back to check the epression at every iteration. N1 is used  for generating the goto which will be used for exit conditions. M2 is used for nextlist of statement and N2 is used for jump to check the expression and M3 is used for the truelist of expression*/
                                                                                                                        backpatch($11,$5);          /*N2.nextlist to M1.instr*/
                                                                                                                        backpatch($14,$9);          /*S.nextlist to M2.instr*/
                                                                                                                        global_quad.emit(quad(Q_GOTO,$9));
                                                                                                                        backpatch($7,nxt_instr);    /*N1.nextlist to nxt_instr*/
                                                                                                                        conv2Bool(&$6);
                                                                                                                        backpatch($6.truelist,$13);
                                                                                                                        $$ = $6.falselist;
                                                                                                                        symbol_count++;
                                                                                                                    }|
                                FOR '(' declaration expression_opt ';' expression_opt ')' statement {};

jump_statement:                 GOTO IDENTIFIER ';' {}|
                                CONTINUE ';' {}|
                                BREAK ';' {}|
                                RETURN expression_opt ';' {
                                                                if($2.loc != NULL){
                                                                 expr * dummy = new expr();
                                                                    dummy->loc = curr_ST->symbol_tab[0];
                                                                    dummy->type = dummy->loc->tp_n;
                                                                    typecheck(dummy,&$2,true);
                                                                    delete dummy;
                                                                    global_quad.emit(quad(Q_RETURN,$2.loc->name));
                                                                    symbol_count++;                                                             
                                                                }
                                                                else
                                                                {
                                                                   global_quad.emit(quad(Q_RETURN));
                                                                }
                                                          };

/*External Definitions*/
translation_unit:               external_declaration                                    |
                                translation_unit external_declaration                   ;

external_declaration:           function_definition                                     |
                                declaration                                             ;

function_definition:    declaration_specifiers declarator declaration_list_opt compound_statement {
                                                                                                    symdata * func = global_ST->lookup($2.loc->name);
                                                                                                    
                                                                                                    func->nest_tab->symbol_tab[0]->name = "retVal";

                                                                                                    func->nest_tab->symbol_tab[0]->tp_n = CopyType(func->tp_n);
                                                                                                    int diff;
                                                                                                    func->nest_tab->symbol_tab[0]->offset = 0;
                                                                                                    //If return type is pointer then change the offset
                                                                                                    if(!(func->nest_tab->symbol_tab[0]->tp_n->basetp != tp_ptr))
                                                                                                    {
                                                                                                        diff = size_pointer - func->nest_tab->symbol_tab[0]->size;
                                                                                                        func->nest_tab->symbol_tab[0]->size = size_pointer;
                                                                                                        int i=1;
                                                                                                        while(i<func->nest_tab->symbol_tab.size())
                                                                                                        {
                                                                                                            func->nest_tab->symbol_tab[i]->offset += diff;
                                                                                                        	i++;
                                                                                                        }
                                                                                                    }
                                                                                                    int offset_size = 0;
                                                                                                    int i=0;
                                                                                                    while(i<func->nest_tab->symbol_tab.size())
                                                                                                    {
                                                                                                        offset_size += func->nest_tab->symbol_tab[i]->size;
                                                                                                        i++;
                                                                                                    }
                                                                                                    //Create a new Current Symbol Table
                                                                                                    curr_ST = new symtab();
                                                                                                    symbol_count++;
                                                                                                };

declaration_list_opt:           declaration_list                                        |
                                /*epsilon*/                                             ;

declaration_list:               declaration                                             |
                                declaration_list declaration                            ;

%%
void yyerror(const char*s)
{
    printf("%s",s);
}
