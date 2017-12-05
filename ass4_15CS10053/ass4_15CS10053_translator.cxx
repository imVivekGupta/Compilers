#include "ass4_15CS10053_translator.h"
#include "y.tab.h"

symtab *global_ST =new symtab();
symtab *curr_ST = new symtab();
node_type *global_type;
int global_width;
quad_array global_quad;
int temp_count=0;
int nxt_instr;

int size_bool=1;
int size_int=4;
int size_pointer=4;
int size_char=1;
int size_double=8;

int node_type::getSize2(){
	if(this==NULL)
		return 0;
	//return the size of the array by calling the recursive function 
	//here we are not checking for null as if it will reach the final type it will enter the below conditions
	switch(this->basetp){
		case tp_mat		: if(this->next==NULL)return size_double; else return ((this->size)*(this->next->getSize()));
		case tp_void	: return 0;
		case tp_int		: return size_int;
		case tp_double	: return size_double;
		case tp_bool	: return size_bool;
		case tp_char	: return size_char;
		case tp_ptr		: return size_pointer;
	}
}

int node_type::getSize(){
	int size = getSize2();
	if(this->basetp == tp_mat) //size += 4;
	return size;	
}

types node_type::getBasetp(){
	if(this==NULL)
		return tp_void;
	return this->basetp;
}

void node_type::printSize(){
	printf("%d\n",size);
}

node_type::node_type(types t,int sz,node_type *n){
	basetp=t;
	next=n;
	size=sz;
}

void node_type::print(){
	switch(basetp){

		case tp_int:
				printf("int");
				break;

		case tp_bool:
				printf("bool");
				break;
		case tp_char:
				printf("char");
				break;
		case tp_void:
				printf("void");
				break;
		case tp_double:
				printf("double");
				break;
		case tp_mat:
				//printf("Matrix(%d,%d,double)",(this->size),(this->next->size));
				if(this->next == NULL)
					printf("double");
				else {
					printf("%d,",this->size);
					this->next->print();
				}
				//printf(")");
				//printf("double)");
				break;
		case tp_func:
				printf("function");
				break;
		case tp_ptr:
				printf("ptr(");
				if(this->next!=NULL)
					this->next->print();
				printf(")");
				break;
		default:
			printf("TYPE NOT FOUND\n");
			exit(-1);
	}
}

quad :: quad(opcode op, string arg1, string arg2, string result){
	this->op = op;
	this->arg1 = arg1;
	this->arg2 = arg2;
	this->result = result;
	if(result.size()!=0){}
	else if(arg2.size()!=0){
		this->arg2 = "";
		this->result = arg2;
	}
	else if(arg1.size()!=0){
		this->arg1 = "";
		this->arg2 = "";
		this->result = arg1;
	}
	else{
		this->arg1 = "";
		this->arg2 = "";
		this->result = "";
	}
}

quad :: quad(opcode op, int val, string operand){
	char buf[10];
	sprintf(buf, "%d", val);
	this->op = op;
	this->arg1 = buf;
	this->arg2 = "";
	this->result = operand;
	
	if(operand.size()==0){
		this->arg1 = "";
		this->result = buf;
	}
	
}

quad :: quad(opcode op, double val, string operand){
	char buf[10];
	sprintf(buf, "%lf", val);
	this->op = op;
	this->arg1 = buf;
	this->arg2 = "";
	this->result = operand;
	
	if(operand.size()==0){
		this->arg1 = "";
		this->result = buf;
	}
}

quad :: quad(opcode op, char val, string operand){
	char buf[10];
	sprintf(buf, "%d", (int)val);
	this->op = op;
	this->arg1 = buf;
	this->arg2 = "";
	this->result = operand;
	if(operand.size()==0){
		this->arg1 = "";
		this->result = buf;
	}
}

void quad::print_arg(){
	printf("\t%s\t=\t%s\top\t%s\t",result.c_str(),arg1.c_str(),arg2.c_str());
}

quad_array :: quad_array(){
	nxt_instr =0;
}

void quad_array :: emit(quad q){
	arr.push_back(q);
	nxt_instr +=1;
}

void propagate(list *L){
	list *head = L;
	vector<int> v;
	while(head!=NULL){
		v.push_back(head->index);
		head = head->next;
	}	
	sort(v.begin(),v.end());
	head = L;
	for(int i = 0;i<v.size();i++){
		head->index = v[i];
		head = head->next;
	}
}

void quad_array::print(){
	opcode op;
	string arg1,arg2,result;
	int i=0;
	
	while(i<nxt_instr){
		op = arr[i].op;
		arg1 = arr[i].arg1;
		arg2 = arr[i].arg2;
		result = arr[i].result;
		printf("%3d. :",i);
		if(Q_UNARY_MINUS<=op && op<=Q_ASSIGN){
			printf("%s",result.c_str());
			if(result.size()>3)
				printf("\t=\t");
			else
				printf("\t\t=\t");	
			switch(op){
				case Q_UNARY_MINUS	: printf("-");break;
				case Q_UNARY_PLUS	: printf("+");break;
				case Q_COMPLEMENT	: printf("~");break;
				case Q_NOT			: printf("!");break;
				case Q_TRANS		: printf(",'");break;
				case Q_ASSIGN		: break;
			}
			printf("%s\n",arg1.c_str());
		}
		else if(Q_PLUS<=op && op<=Q_NOT_EQUAL){
			printf("%s",result.c_str());
			printf("\t=\t");
			printf("%s",arg1.c_str());
			printf(" ");
			switch(op){
				case Q_PLUS	: cout<<"+";break;
				case Q_MINUS	: cout<<"-";break;
				case Q_MULT	: cout<<"*";break;
				case Q_DIVIDE	: cout<<"/";break;
				case Q_MODULO	: cout<<"%%";break;
				case Q_LEFT_OP	: cout<<"<<";break;
				case Q_RIGHT_OP	: cout<<">>";break;
				case Q_XOR	: cout<<"^";break;
				case Q_AND	: cout<<"&";break;
				case Q_OR	: cout<<"|";break;
				case Q_LOG_AND	: cout<<"&&";break;
				case Q_LOG_OR	: cout<<"||";break;
				case Q_LESS	: cout<<"<";break;
				case Q_LESS_OR_EQUAL: cout<<"<=";break;
				case Q_GREATER_OR_EQUAL: printf(">=");break;
				case Q_GREATER	: printf(">");break;
				case Q_EQUAL	: printf("==");break;
				case Q_NOT_EQUAL: printf("!=");break;
				
			}/*
			if(op == Q_TRANS) 
				printf("\n;");
			else*/
				printf(" %s\n",arg2.c_str());
		}
		else if(op == Q_GOTO){printf("goto ");printf("%s\n",result.c_str());}
		else if(op == Q_LDEREF)
		 	printf("*%s\t=\t%s\n", result.c_str(), arg1.c_str());
		else if(Q_IF_EQUAL<=op && op<=Q_IF_GREATER_OR_EQUAL){
			printf("if  ");
			printf("%s ",arg1.c_str());
			switch(op){
						case Q_IF_LESS		: cout<<"<"; break;
	            		case Q_IF_GREATER 	: cout<<">"; break;
	            		case Q_IF_LESS_OR_EQUAL : cout<<"<="; break;
	            		case Q_IF_GREATER_OR_EQUAL : printf(">="); break;
	            		case Q_IF_EQUAL 	: cout<<"=="; break;
	            		case Q_IF_NOT_EQUAL 	: printf("!="); break;
	            		case Q_IF_EXPRESSION 	: cout<<"!= 0"; break;
	            		case Q_IF_NOT_EXPRESSION: cout<<"== 0"; break;
			}
			printf("%s",arg2.c_str());printf("\tgoto ");printf("%s\n",result.c_str());
		}
		else if(op == Q_LINDEX)
		 	printf("%s[%s]\t=\t%s\n",result.c_str(),arg1.c_str(),arg2.c_str());
		 else if(op == Q_RDEREF)
		 	printf("%s\t=\t* %s\n", result.c_str(), arg1.c_str());	

		 else if(op == Q_CALL){
		 	if(result.c_str())
		 		printf("%s\t=\tcall %s, %s\n",result.c_str(),arg1.c_str(),arg2.c_str());
		 	else
		 		printf("call %s, %s\n",arg1.c_str(),arg2.c_str());	
		 }

		 else if(Q_CHAR2INT<=op && op<=Q_DOUBLE2INT){
		 	printf("%s",result.c_str());
		 	printf("\t=\t");
			switch(op){
				case Q_DOUBLE2CHAR : cout<<"Double2Char(";printf("%s",arg1.c_str());printf(")\n"); break;
	            case Q_INT2DOUBLE : printf("Int2Double(");printf("%s",arg1.c_str());printf(")\n"); break;
	            case Q_DOUBLE2INT : cout<<"Double2Int(";printf("%s",arg1.c_str());printf(")\n"); break;
				case Q_CHAR2INT : printf("Char2Int(");printf("%s",arg1.c_str());printf(")\n"); break;
	            case Q_CHAR2DOUBLE : cout<<"Char2Double(";printf("%s",arg1.c_str());printf(")\n"); break;
	            case Q_INT2CHAR : printf("Int2Char(");printf("%s",arg1.c_str());printf(")\n"); break;
			}
		 }
		 else if(op == Q_PARAM)
		 	printf("param\t%s\n",result.c_str());
		 else if(op == Q_RETURN)
		 	printf("return\t%s\n",result.c_str());
		 else if(op == Q_RINDEX)
		 	printf("%s\t=\t%s[%s]\n",result.c_str(),arg1.c_str(),arg2.c_str());
		 else if(op == Q_ADDR)
		 	printf("%s\t=\t& %s\n", result.c_str(), arg1.c_str());
		 	
		i++;
	}
}

funct::funct(vector<types> tpls){
	typelist=tpls;
}

void funct::print(){
	int i,j;
	printf("Funct(");
	i=0;
	j = typelist.size();
	do	{
		if(i>=j)break;
		if(i!=0)
			printf(",");
		printf("%d ",typelist[i]);
		i++;
	}while(i<typelist.size());
	printf(")");
}

symdata::symdata(string n){
	name =n;
	size=0;
	tp_n=NULL;
	offset=0;
	var_type = "";
	isInitialized = false;
	isFunction = false;
	isMatrix = false;
	mat = NULL;
	fun = NULL;
	nest_tab=NULL;
}

node_type *CopyType(node_type *t){
	/*Duplicates the input type and returns the pointer to the newly created type*/
	if(t != NULL){
		node_type *ret = new node_type(t->basetp);
		ret->size = t->size;
		ret->basetp = t->basetp;
		ret->next = CopyType(t->next);
		return ret;
	}
	return t;
}

/*
void symdata::createMatrix(){
	mat=new matrix(this->name,this->size,tp_mat);
}*/

symtab::symtab(){
	name = "";
	offset = 0;
}

symtab::~symtab(){
	int i=0;
	node_type *p1,*p2;
	do{
		p1=symbol_tab[i]->tp_n;
		while(p1 != NULL)
		{
			p2=p1;
			p1=p1->next;
			delete p2;
		}
		i++;	
	}while(i<symbol_tab.size());
}

symdata* symtab::lookup(string n,bool search){
	int i = symbol_tab.size();
	
	for (int j = 0; j < i; ++j)
	{
		if(symbol_tab[j]->name == n)
			return symbol_tab[j];
	}
	if(search) return NULL;
	
	symdata *temp_o=new symdata(n);
	//temp_o->i_val.int_val=0;
	symbol_tab.push_back(temp_o);
	return temp_o;		
}

symdata* symtab::gentemp(node_type *type){
	char c[10];
	sprintf(c,"t%03d",temp_count);
	temp_count++;
	symdata *temp=lookup(c);

	if(type==NULL)
		temp->size=0;
	else if((type->basetp) == tp_void)
		temp->size=0;
	else if((type->basetp) == tp_int)
		temp->size=size_int;
	else if((type->basetp) == tp_double)
		temp->size=size_double;
	else if((type->basetp) == tp_bool)
		temp->size=size_bool;
	else if((type->basetp) == tp_char)
		temp->size=size_char;
	else if((type->basetp) == tp_ptr)
		temp->size=size_pointer;
	else
		temp->size= type->getSize();
	
	temp->var_type = "temp";
	temp->tp_n = type;
	temp->offset = this->offset ;
	this->offset = this->offset + (temp->size);
	return temp;
}

void symtab::update(symdata *sm,node_type *type,basic_val initval,symtab *next)
{
	sm->tp_n = CopyType(type);

	if(sm->tp_n==NULL)
		sm->size=0;
	else if(((sm->tp_n)->basetp) == tp_void)
		sm->size=0;
	else if(((sm->tp_n)->basetp) == tp_int)
		sm->size=size_int;
	else if(((sm->tp_n)->basetp) == tp_double)
		sm->size=size_double;
	else if(((sm->tp_n)->basetp) == tp_bool)
		sm->size=size_bool;
	else if(((sm->tp_n)->basetp) == tp_char)
		sm->size=size_char;
	else if(((sm->tp_n)->basetp) == tp_ptr)
		sm->size=size_pointer;
	else
		sm->size = sm->tp_n->getSize();
	sm->i_val= initval;
	sm->nest_tab=next;
	sm->offset=this->offset+(sm->size);
	sm->isInitialized=false;
}

void symtab::print(){
	printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
	printf("Symbol Table : %s\n",name.c_str());
	printf("Name\tType\tInitial Value\tSize\tOffset\tNested Table\n");
	int i=0;
	while(i<symbol_tab.size()){
		symdata * t = symbol_tab[i];
        	printf("%s\t",symbol_tab[i]->name.c_str()); 
        	
        	if(t->tp_n != NULL){
        		if(t->tp_n->basetp == tp_mat)
        			        	printf("Matrix(");
				(t->tp_n)->print();
				if(t->tp_n->basetp == tp_mat)	
					printf(")");
        	}
			else printf("\t");
			printf("\t");

        	if(t->isInitialized){
        		switch((t->tp_n)->basetp){
        			case tp_char: printf("%c\t",(t->i_val).char_val);break;
        			case tp_int : printf("%d\t",(t->i_val).int_val);break;
        			case tp_double: printf("%lf\t",(t->i_val).double_val);break;
        			case tp_mat: printf("%s\t",(t->i_val).mat_val);
        				/*
        						for(int x = 0;x<(t->i_val).mat_val.size();x++){
        							for(int y=0; y<(t->i_val).mat_val[x].size() ; y++)
        								printf("%lf");	
        						}*/
        						break;	
        			default	    : printf("----\t");
        		}
        	}else{printf("null\t");}
        	printf("\t%d\t%d\t",t->size,t->offset);
		if(t->var_type == "func")
			printf("ptr-to-ST( %s )",t->nest_tab->name.c_str());
		else printf("null");
		printf("\n");
		i++;
	}
	
	printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
}

void typecheck(expr *e1, expr *e2, bool isAssign){
	types T1 = e1->type->basetp;
	types T2 = e2->type->basetp;
	
	//printf("%d %d",T1,T2);

	if(T1==T2)return;
	if(isAssign){
		symdata *temp = curr_ST->gentemp(e1->type);
		if(T1==tp_int && T2==tp_double)
			global_quad.emit(quad(Q_DOUBLE2INT,e2->loc->name,"",temp->name));
		else if(T1==tp_double && T2==tp_int)
			global_quad.emit(quad(Q_INT2DOUBLE,e2->loc->name,"",temp->name));
		else if(T1==tp_char && T2==tp_int)
			global_quad.emit(quad(Q_INT2CHAR,e2->loc->name,"",temp->name));
		else if(T1==tp_int && T2==tp_char)
			global_quad.emit(quad(Q_CHAR2INT,e2->loc->name,"",temp->name));
		else{
			printf("TYPE INCOMPATIBLE: %s %s",e1->loc->name.c_str(),e2->loc->name.c_str());
			exit(-1);
		}
		e2->type = temp->tp_n;
		e2->loc = temp;		
	}
	else if(T1>T2){
		symdata *temp = curr_ST->gentemp(e1->type);
		if(T1==tp_int && T2==tp_char)
			global_quad.emit(quad(Q_CHAR2INT,e2->loc->name,"",temp->name));
		else if(T1==tp_double && T2==tp_int)
			global_quad.emit(quad(Q_INT2DOUBLE,e2->loc->name,"",temp->name));
		e2->loc = temp;
		e2->type = temp->tp_n;		
	}
	else{
		symdata *temp = curr_ST->gentemp(e2->type);
		if(T2==tp_int && T1==tp_char)
			global_quad.emit(quad(Q_CHAR2INT,e1->loc->name,"",temp->name));
		else if(T2==tp_double && T1==tp_int)
			global_quad.emit(quad(Q_INT2DOUBLE,e1->loc->name,"",temp->name));
		e1->loc = temp;
		e1->type = temp->tp_n;	
	}
}

list* makelist(int i){
	list *temp = (list*)malloc(sizeof(list));
	temp->index=i;
	temp->next=NULL;
	return temp;
}

list* merge(list* l1,list* l2){
	list *L1 = l1;
	list *L2 = l2;
	list* head =  (list*)malloc(sizeof(list));
	list* curr = head;
	bool flag=false;
	while(L1!=NULL){
		flag = true;
		curr->index = L1->index;
		L1 = L1->next;
		if(L1==NULL)break;
		curr->next = (list*)malloc(sizeof(list));
	}
	
	while(L2!=NULL){
		if(flag){
			curr->next = (list*)malloc(sizeof(list));
			flag = false;
			curr= curr->next;
		}
		curr->index = L2->index;
		L2 = L2->next;
		if(L2==NULL)break;
		curr->next = (list*)malloc(sizeof(list));
	}
	curr->next = NULL;
	return head;	
}

void backpatch(list* l ,int i){
	list *temp1 = l;
	list *temp2 = l;
	char str[10];
	sprintf(str,"%d",i);
	while(temp1!=NULL)
	{
		global_quad.arr[temp1->index].result = str;
		temp1=temp1->next;
	}
	
	temp1= temp2;
	while(temp1!=NULL)
	{
		temp2=temp1;
		free(temp2);
		temp1=temp1->next;
	}
}

void conv2Bool(expr* e){
	while((e->type)->basetp != tp_bool){
		(e->type) = new node_type(tp_bool);
		e->falselist = makelist(nxt_instr);
		global_quad.emit(quad(Q_IF_EQUAL,e->loc->name,"0","-1"));
		e->truelist = makelist(nxt_instr);
		global_quad.emit(quad(Q_GOTO,-1,""));
		break;
	}
}

void print_list(list *root){
	if(root==NULL){
		printf("Empty list\n");
		return;
	}
	while(root!=NULL){
		printf("%d ",root->index);
		root = root->next;
	}
	
	printf("\n");
}

int main(){
	yyparse();
	global_ST->name="Global";
	printf("==============================================================================");
	printf("\n\tGENERATED QUADS\t\n");
	global_quad.print();
	printf("==============================================================================");
	printf("Symbol table Maintained For the Given Program\n");
	global_ST->print();
	int i=0;
	do{
		if(i>=global_ST->symbol_tab.size()) break;
		((global_ST->symbol_tab[i])->nest_tab)->print();
		++i;
	}while(i<global_ST->symbol_tab.size());
	printf("=============================================================================");
	return 0;
}
