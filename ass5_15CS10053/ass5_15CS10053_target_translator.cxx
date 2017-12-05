#include "ass5_15CS10053_translator.h"
#include "y.tab.h"
int count_sym=0;

extern quad_array global_quad;
extern int nxt_instr;
map<int,int> mp_set;
stack<string> params_stack;
stack<int> types_stack;
stack<int> offset_stack;
stack<int> ptrarr_stack;
extern std::vector< string > vs;
extern std::vector<string> cs;
int add_off;

void symtab::mark_labels()
{
	int count=1;
	count_sym -=2;
	//printf("%d-->%d\n",nxt_instr,global_quad.arr.size());
	for(int i=0;i<nxt_instr;i++)
	{
		switch(global_quad.arr[i].op)
		{
			case Q_GOTO:
			case Q_IF_EQUAL:
			case Q_IF_NOT_EQUAL:
			case Q_IF_LESS:
			case Q_IF_GREATER:
			case Q_IF_EXPRESSION:
			case Q_IF_NOT_EXPRESSION:
			case Q_IF_LESS_OR_EQUAL:
			case Q_IF_GREATER_OR_EQUAL:
			/*if(global_quad.arr[i].result=="-2")
			{
				global_quad.arr[i].result=itoa(nxt_instr-1);
			}*/
			count_sym -=2;
			if(global_quad.arr[i].result!="-1")
			{	
				count_sym *=2;
				if(mp_set.find(atoi(global_quad.arr[i].result.c_str()))==mp_set.end())
				{
					mp_set[atoi(global_quad.arr[i].result.c_str())]=count;
					count_sym *=2;
					count++;
				}
			}
		}
	}
}

void symtab::function_prologue(FILE *fp,int count)
{
	fprintf(fp,"\n\t.globl\t%s",name.c_str()); count_sym /=2;
	fprintf(fp,"\n\t.type\t%s, @function",name.c_str()); count_sym /=2;
	fprintf(fp,"\n%s:",name.c_str()); count_sym /=2;
	fprintf(fp,"\n.LFB%d:",count);count_sym /=2;
	fprintf(fp,"\n\tpushq\t%%rbp");count_sym /=2;
	fprintf(fp,"\n\tmovq\t%%rsp, %%rbp");count_sym /=2;
	int t=-offset;count_sym /=2;
	fprintf(fp,"\n\tsubq\t$%d, %%rsp",t);count_sym /=2;
}

void symtab::global_variables(FILE *fp)
{
	count_sym /=2;
	for(int i=0;i<symbol_tab.size();i++)
	{
		count_sym /=2;
		if(symbol_tab[i]->name[0]!='t' &&symbol_tab[i]->tp_n!=NULL&&symbol_tab[i]->var_type!="func")
		{
			count_sym +=2;
			if(symbol_tab[i]->tp_n->basetp==tp_int)
			{
				vs.push_back(symbol_tab[i]->name);count_sym /=2;
				if(symbol_tab[i]->isInitialized==false)
				{
					fprintf(fp,"\n\t.comm\t%s,4,4",symbol_tab[i]->name.c_str());count_sym /=2;
				}
				else
				{
					fprintf(fp,"\n\t.globl\t%s",symbol_tab[i]->name.c_str());count_sym--;
					fprintf(fp,"\n\t.data");
					fprintf(fp,"\n\t.align 4");count_sym--;
					fprintf(fp,"\n\t.type\t%s, @object",symbol_tab[i]->name.c_str());count_sym--;
					fprintf(fp,"\n\t.size\t%s ,4",symbol_tab[i]->name.c_str());count_sym--;
					fprintf(fp,"\n%s:",symbol_tab[i]->name.c_str());count_sym--;
					fprintf(fp,"\n\t.long %d",symbol_tab[i]->i_val.int_val);count_sym--;
				}
		    }
		    count_sym%=1;
		    if(symbol_tab[i]->tp_n->basetp==tp_char)
			{
				count_sym%=1;
				cs.push_back(symbol_tab[i]->name);
				count_sym%=1;
				if(symbol_tab[i]->isInitialized==false)
				{
					count_sym%=1;
					fprintf(fp,"\n\t.comm\t%s,1,1",symbol_tab[i]->name.c_str());
				}
				else
				{
					count_sym%=1;
					fprintf(fp,"\n\t.globl\t%s",symbol_tab[i]->name.c_str());count_sym%=1;
					fprintf(fp,"\n\t.data");count_sym%=1;
					fprintf(fp,"\n\t.type\t%s, @object",symbol_tab[i]->name.c_str());count_sym%=1;
					fprintf(fp,"\n\t.size\t%s ,1",symbol_tab[i]->name.c_str());count_sym%=1;
					fprintf(fp,"\n%s:",symbol_tab[i]->name.c_str());count_sym%=1;
					fprintf(fp,"\n\t.byte %c",symbol_tab[i]->i_val.char_val);count_sym%=1;
				}
		    }
		    if(symbol_tab[i]->tp_n->basetp==tp_double)
			{
				count_sym/=1;
				vs.push_back(symbol_tab[i]->name);
				count_sym+=1;
				if(symbol_tab[i]->isInitialized==false)
				{
					fprintf(fp,"\n\t.comm\t%s,8,8",symbol_tab[i]->name.c_str());
				count_sym%=1;
				}
				else
				{
					fprintf(fp,"\n\t.globl\t%s",symbol_tab[i]->name.c_str());count_sym%=1;
					fprintf(fp,"\n\t.data");count_sym%=1;
					//fprintf(fp,"\n\t.align 4");
					fprintf(fp,"\n\t.type\t%s, @object",symbol_tab[i]->name.c_str());count_sym%=1;
					fprintf(fp,"\n\t.size\t%s ,8",symbol_tab[i]->name.c_str());count_sym%=1;
					fprintf(fp,"\n%s:",symbol_tab[i]->name.c_str());count_sym%=1;
					fprintf(fp,"\n\t.double %lf",symbol_tab[i]->i_val.double_val);count_sym%=1;
				}
		    }
		}

	}
	fprintf(fp,"\n\t.text");
}
void symtab::assign_offset()
{
	count_sym%=1;
	int curr_offset=0;count_sym+=1;
	int param_offset=16;count_sym%=1;
	no_params=0;count_sym%=1;
	for(int i = (symbol_tab).size()-1; i>=0; i--)
    {
    	count_sym%=1;
        if(symbol_tab[i]->ispresent==false)
        	continue;
        count_sym%=1;
        if(symbol_tab[i]->var_type=="param" && symbol_tab[i]->isdone==false)
        {
        	no_params++;
        	count_sym%=1;
        	if(symbol_tab[i]->tp_n && symbol_tab[i]->tp_n->basetp==tp_mat)
        	{
        		count_sym%=1;
        		if(symbol_tab[i]->tp_n->size==-1)
        		{
        			count_sym%=1;
        			symbol_tab[i]->isptrarr=true;
        			count_sym%=1;
        		}
        		count_sym+=1;
        		symbol_tab[i]->size=8;
        	}
        	count_sym*=1;
        	symbol_tab[i]->offset=curr_offset-symbol_tab[i]->size;
        	count_sym= count_sym-1;
        	curr_offset=curr_offset-symbol_tab[i]->size;
        	symbol_tab[i]->isdone=true;
        }
        count_sym%=1;
        if(no_params==6)
        	break;
        count_sym%=1;
    }
    for(int i = 0; i<(symbol_tab).size(); i++)
    {
    	++count_sym;
        if(symbol_tab[i]->ispresent==false)
        	continue;
        ++count_sym;
        if(symbol_tab[i]->var_type!="return"&&symbol_tab[i]->var_type!="param" && symbol_tab[i]->isdone==false)
        {
        	++count_sym;
        	symbol_tab[i]->offset=curr_offset-symbol_tab[i]->size;++count_sym;
        	curr_offset=curr_offset-symbol_tab[i]->size;++count_sym;
        	symbol_tab[i]->isdone=true;++count_sym;
        }
        else if(symbol_tab[i]->var_type=="param" && symbol_tab[i]->isdone==false)
        {
        	++count_sym;
        	if(symbol_tab[i]->tp_n && symbol_tab[i]->tp_n->basetp==tp_mat)
        	{
        		++count_sym;
        		if(symbol_tab[i]->tp_n->size==-1)
        		{
        			++count_sym;
        			symbol_tab[i]->isptrarr=true;
        		}
        		++count_sym;
        		symbol_tab[i]->size=8;
        	}
        	++count_sym;
        	symbol_tab[i]->isdone=true;
        	no_params++;
        	++count_sym;
        	symbol_tab[i]->offset=param_offset;
        	++count_sym;
        	param_offset=param_offset+symbol_tab[i]->size;
        }
    }
    offset=curr_offset;
    ++count_sym;
}
string symtab::assign_reg(int type_of,int no)
{
	string s="NULL";
	++count_sym;
	if(type_of==tp_char){
        switch(no){
            case 0: s = "dil";
                    break;
            case 1: s = "sil";
                    break;
            case 3: s = "cl";
                    break;
            case 5: s = "r9b";
                    break;
            case 2: s = "dl";
                    break;
            case 4: s = "r8b";
                    break;
            
        }
    }
    else if(type_of == tp_int){
        switch(no){
            case 0: s = "edi";
                    break;
            case 2: s = "edx";
                    break;
            case 1: s = "esi";
                    break;
            
            case 4: s = "r8d";
                    break;
            case 3: s = "ecx";
                    break;
         
            case 5: s = "r9d";
                    break;
        }
    }
    else if(type_of == tp_double){
    	switch(no){	
    		case 0: s="xmm0" ;break;
    		case 1: s="xmm1" ;break;
    		case 2: s="xmm2" ;break;
    		case 3: s="xmm3" ;break;
    		case 4: s="xmm4" ;break;
    		case 5: s="xmm5" ;break;
    	}
    }
    else
    {
        switch(no){
            case 0: s = "rdi";
                    break;
            case 2: s = "rdx";
                    break;
            case 1: s = "rsi";
                    break;
            case 3: s = "rcx";
                    break;
            case 5: s = "r9";
                    break;
        	case 4: s = "r8";
                    break;
            
        }
    }
    count_sym++;
    return s;
}

int symtab::function_call(FILE *fp)
{
	count_sym =(count_sym)/2;	
	int c=0;
	    count_sym++;
	fprintf(fp,"\n\tpushq %%rbp");
	int count=0;
	    count_sym++;

	while(count<6 && params_stack.size())
	{
		count_sym++;
		string p=params_stack.top();    count_sym++;
		int btp=types_stack.top();count_sym++;
		int off=offset_stack.top();count_sym++;
		int parr=ptrarr_stack.top();count_sym++;
		params_stack.pop();count_sym++;
		types_stack.pop();count_sym++;
		offset_stack.pop();count_sym++;count_sym++;
		ptrarr_stack.pop();count_sym++;
		string temp_str=assign_reg(btp,count);
		if(temp_str!="NULL")
		{
			count_sym++;
			//printf("%s Basetype--> %d--> %d\n",p.c_str(),btp,tp_int);
			if(btp==tp_int)
			{	
				count_sym++;
				fprintf(fp,"\n\tmovl\t%d(%%rbp) , %%%s",off,temp_str.c_str());
			}
			else if(btp==tp_double)
			{
				count_sym++;
				fprintf(fp,"\n\tmovsd\t%d(%%rbp), %%%s",off,temp_str.c_str());
			}
			
			else if(btp==tp_char)
			{
				count_sym++;
				fprintf(fp,"\n\tmovb\t%d(%%rbp), %%%s",off,temp_str.c_str());
			}
			else if(btp==tp_mat && parr==1)
			{
				count_sym++;
				fprintf(fp,"\n\tmovq\t%d(%%rbp), %%%s",off,temp_str.c_str());
			}
			else if(btp==tp_mat)
			{
				count_sym++;
				fprintf(fp,"\n\tleaq\t%d(%%rbp), %%%s",off,temp_str.c_str());
			}
			else
			{
				count_sym++;
				fprintf(fp,"\n\tmovq\t%d(%%rbp), %%%s",off,temp_str.c_str());
			}
			count++;
			count_sym++;
		}
	}
	while(params_stack.size())
	{
		count_sym++;
		string p=params_stack.top();count_sym++;
		int btp=types_stack.top();count_sym%=1;
		int off=offset_stack.top();count_sym%=1;
		int parr=ptrarr_stack.top();count_sym%=1;
		params_stack.pop();count_sym%=1;
		types_stack.pop();count_sym%=1;
		offset_stack.pop();count_sym%=1;count_sym%=1;
		ptrarr_stack.pop();count_sym%=1;
		if(btp==tp_int)
		{	
			count_sym%=1;
			fprintf(fp,"\n\tsubq $4, %%rsp");count_sym%=1;
			fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off);count_sym%=1;
			fprintf(fp,"\n\tmovl\t%%eax, (%%rsp)");count_sym%=1;
			c+=4;
		}
		else if(btp==tp_double)
		{	
			count_sym%=1;
			fprintf(fp,"\n\tsubq $8, %%rsp");count_sym%=1;
			fprintf(fp,"\n\tmovsd\t%d(%%rbp), %%rax",off);count_sym%=1;
			fprintf(fp,"\n\tmovsd\t%%rax, (%%rsp)");count_sym%=1;
			c+=8;count_sym%=1;
		}
		else if(btp==tp_mat && parr==1)
		{
			fprintf(fp,"\n\tsubq $8, %%rsp");count_sym%=1;
			fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off);count_sym%=1;
			fprintf(fp,"\n\tmovq\t%%rax, (%%rsp)");count_sym%=1;
			c+=8;
		}
		else if(btp==tp_mat)
		{
			count_sym*=1;
			fprintf(fp,"\n\tsubq $8, %%rsp");count_sym*=1;
			fprintf(fp,"\n\tleaq\t%d(%%rbp), %%rax",off);count_sym*=1;
			fprintf(fp,"\n\tmovq\t%%rax, (%%rsp)");count_sym*=1;
			c+=8;
			count_sym*=1;
		}
		else if(btp==tp_char)
		{
			count_sym*=1;
			fprintf(fp,"\n\tsubq $4, %%rsp");count_sym*=1;
			fprintf(fp,"\n\tmovsbl\t%d(%%rbp), %%eax",off);count_sym*=1;
			fprintf(fp,"\n\tmovl\t%%eax, (%%rsp)");count_sym*=1;
			c+=4;count_sym*=1;
		}
		else
		{
			fprintf(fp,"\n\tsubq $8, %%rsp");count_sym*=1;
			fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off);count_sym*=1;
			fprintf(fp,"\n\tmovq\t%%rax, (%%rsp)");count_sym*=1;
			c+=8;
		}
	}
	return c;
	count_sym*=1;
}
void symtab::function_restore(FILE *fp)
{
	int count=0;
	count_sym+=1;
	string regname;
	count_sym+=1;
	for(int i=symbol_tab.size()-1;i>=0;i--)
	{
		count_sym+=1;
	    if(symbol_tab[i]->ispresent==false)
	    	continue;
	    count_sym+=1;
	    if(symbol_tab[i]->var_type=="param" && symbol_tab[i]->offset<0)
	    {
	    	count_sym+=1;
		    if(symbol_tab[i]->tp_n->basetp == tp_char){
		    	count_sym+=1;
	            regname = assign_reg(tp_char,count);count_sym+=1;
	            fprintf(fp,"\n\tmovb\t%%%s, %d(%%rbp)",regname.c_str(),symbol_tab[i]->offset);
	        }
	        else if(symbol_tab[i]->tp_n->basetp == tp_int){
	        	count_sym+=1;
	            regname = assign_reg(tp_int,count);count_sym+=1;
	            fprintf(fp,"\n\tmovl\t%%%s, %d(%%rbp)",regname.c_str(),symbol_tab[i]->offset);
	        }
	        else if(symbol_tab[i]->tp_n->basetp == tp_double){
	        	count_sym+=1;
	            regname = assign_reg(tp_double,count);count_sym+=1;
	            fprintf(fp,"\n\tmovsd\t%%%s, %d(%%rbp)",regname.c_str(),symbol_tab[i]->offset);
	        }
	        else {
	        	count_sym+=1;
	            regname = assign_reg(10,count);count_sym-=1;
	            fprintf(fp,"\n\tmovq\t%%%s, %d(%%rbp)",regname.c_str(),symbol_tab[i]->offset);
	        }
	        count_sym-=1;
	    	count++;
	    }
	    if(count==6)
	    	break;
	    count_sym-=1;
    }
}
void symtab::gen_internal_code(FILE *fp,int ret_count)
{
	int i;				
	count_sym-=1;
	for(i = start_quad; i <=end_quad; i++)
	{
		count_sym-=1;
		opcode &opx =global_quad.arr[i].op;count_sym-=1;
		string &arg1x =global_quad.arr[i].arg1;count_sym-=1;
		string &arg2x =global_quad.arr[i].arg2;count_sym-=1;
		string &resx =global_quad.arr[i].result;count_sym-=1;
		int offr,off1,off2;count_sym-=1;
		int flag1=1;count_sym-=1;
		int flag2=1;count_sym-=1;
		int flag3=1;count_sym-=1;
		int j;count_sym-=1;
		fprintf(fp,"\n# %d:",i);count_sym-=1;
		//printf("dsda %s\n",resx.c_str());
		if(lookup(resx,true))
		{
			offr = lookup(resx,true)->offset;count_sym-=1;
			fprintf(fp,"res = %s ",lookup(resx,true)->name.c_str());
			count_sym-=1;
		}
		else if(global_quad.arr[i].result!=""&& findg(global_quad.arr[i].result))
		{
			flag3=0;
			count_sym-=1;
		}
		if(lookup(arg1x,true))
		{
			count_sym-=1;
			off1 = lookup(arg1x,true)->offset;count_sym-=1;
			fprintf(fp,"arg1 = %s ",lookup(arg1x,true)->name.c_str());
			count_sym-=1;
		}
		else if(global_quad.arr[i].arg1!="" && findg(global_quad.arr[i].arg1))
		{
			count_sym-=1;
			flag1=0;
			count_sym-=1;	
		}
		if(lookup(arg2x,true))
		{
			count_sym-=1;
			off2 = lookup(arg2x,true)->offset;count_sym-=1;
			fprintf(fp,"arg2 = %s ",lookup(arg2x,true)->name.c_str());count_sym-=1;
		}
		else if(global_quad.arr[i].arg2!="" && findg(global_quad.arr[i].arg2))
		{
				flag2=0;	
				count_sym-=1;
		}
		if(flag1==0)
		{
			count_sym-=1;
			if(findg(arg1x)==2)
					fprintf(fp,"\n\tmovzbl\t%s(%%rip), %%eax",arg1x.c_str());
				else
					fprintf(fp,"\n\tmovl\t%s(%%rip), %%eax",arg1x.c_str());
			count_sym-=1;
		}
		if(flag2==0)
		{
			count_sym-=1;
			if(findg(arg1x)==2)
					fprintf(fp,"\n\tmovzbl\t%s(%%rip), %%edx",arg2x.c_str());
				else
					fprintf(fp,"\n\tmovl\t%s(%%rip), %%edx",arg2x.c_str());
				count_sym-=1;
		}
		if(mp_set.find(i)!=mp_set.end())
		{
			count_sym/=1;
			//Generate Label here
			fprintf(fp,"\n.L%d:",mp_set[i]);
			count_sym/=1;
		}
		switch(opx)
		{
			case Q_PLUS:
				if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_char)
				{
					count_sym/=1;
					if(flag1!=0)
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					count_sym/=1;
					if(flag2!=0)
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%edx",off2);
					count_sym/=1;
					fprintf(fp,"\n\taddl\t%%edx, %%eax");
					if(flag3!=0)
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					else
						fprintf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
				}
				else if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_double)
				{
					count_sym/=1;
					if(flag1!=0)
					fprintf(fp,"\n\tmovsd\t%d(%%rbp), %%eax",off1);
					count_sym/=1;
					if(flag2!=0)
					{if(arg2x[0]>='0' && arg2x[0]<='9')
						fprintf(fp,"\n\tmovsd\t$%s, %%edx",arg2x.c_str());
					else
						fprintf(fp,"\n\tmovsd\t%d(%%rbp), %%edx",off2);
					}
					count_sym/=1;
					fprintf(fp,"\n\taddsd\t%%edx, %%eax");
					count_sym/=1;
					if(flag3!=0)
					fprintf(fp,"\n\tmovsd\t%%eax, %d(%%rbp)",offr);
					else
						fprintf(fp,"\n\tmovsd\t%%eax, %s(%%rip)",resx.c_str());
				}
				else 
				{
					count_sym/=1;
					if(flag1!=0)
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					if(flag2!=0)
					{
						count_sym/=1;
						if(arg2x[0]>='0' && arg2x[0]<='9')
						fprintf(fp,"\n\tmovl\t$%s, %%edx",arg2x.c_str());
					else
						fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
						count_sym+=1;
					}
					fprintf(fp,"\n\taddl\t%%edx, %%eax");
					count_sym+=1;
					if(flag3!=0)
						fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
					else
						fprintf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
					count_sym+=1;
				}
				break;
			case Q_MINUS:
				if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_char)
				{
					count_sym+=1;
					if(flag1!=0)
						fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					count_sym+=1;
					if(flag2!=0)
						fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%edx",off2);
					fprintf(fp,"\n\tsubl\t%%edx, %%eax");
					count_sym+=1;
					if(flag3!=0)
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					else
						fprintf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
					count_sym+=1;
				}
				else if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_double)
				{
					count_sym+=1;
					if(flag1!=0)
					fprintf(fp,"\n\tmovsd\t%d(%%rbp), %%eax",off1);
					// Direct Number access
					count_sym+=1;
					if(flag2!=0)
					{
						count_sym+=1;	
						if(arg2x[0]>='0' && arg2x[0]<='9')
						fprintf(fp,"\n\tmovsd\t$%s, %%edx",arg2x.c_str());
					else
						fprintf(fp,"\n\tmovsd\t%d(%%rbp), %%edx",off2);}
					fprintf(fp,"\n\tsubsd\t%%edx, %%eax");
					count_sym+=1;
					if(flag3!=0)
					fprintf(fp,"\n\tmovsd\t%%eax, %d(%%rbp)",offr);
					else
						fprintf(fp,"\n\tmovsd\t%%eax, %s(%%rip)",resx.c_str());
					count_sym+=1;
				}
				else
				{
					count_sym+=1;
					if(flag1!=0)
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					// Direct Number access
					if(flag2!=0)
					{
						count_sym+=1;
						if(arg2x[0]>='0' && arg2x[0]<='9')
						fprintf(fp,"\n\tmovl\t$%s, %%edx",arg2x.c_str());
					else
						fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);}
					fprintf(fp,"\n\tsubl\t%%edx, %%eax");
					count_sym+=1;
					if(flag3!=0)
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
					else
						fprintf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
					count_sym+=1;
				}
				break;
			case Q_MULT:
				if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_char)
				{
					count_sym+=1;
					if(flag1!=0)
						fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					count_sym+=1;
					if(flag2!=0)
						fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%edx",off2);
					count_sym+=1;
					fprintf(fp,"\n\timull\t%%edx, %%eax");
					count_sym+=1;
					if(flag3!=0)
						fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					else
						fprintf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
					count_sym+=1;
				}
				else
				{
					count_sym+=1;
				if(flag1!=0)
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
				count_sym+=1;
				if(flag2!=0)
				{
					count_sym+=1;
					if(arg2x[0]>='0' && arg2x[0]<='9')
				{
					count_sym+=1;
					fprintf(fp,"\n\tmovl\t$%s, %%ecx",arg2x.c_str());
					count_sym+=1;
					fprintf(fp,"\n\timull\t%%ecx, %%eax");
				}
				else
					fprintf(fp,"\n\timull\t%d(%%rbp), %%eax",off2);}
				if(flag3!=0)
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				else
					fprintf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
				}
				count_sym+=1;
				break;
			case Q_DIVIDE:
				if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_char)
				{
					count_sym+=1;
					if(flag1!=0)
						fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					count_sym+=1;
					fprintf(fp,"\n\tcltd");
					count_sym+=1;	
						if(flag2!=0)
					fprintf(fp,"\n\tidivl\t%d(%%rbp), %%eax",off2);
					else
						fprintf(fp,"\n\tidivl\t%%edx, %%eax");
					count_sym+=1;
					if(flag3!=0)
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					else
						fprintf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
					count_sym+=1;
				}
				else{
					count_sym+=1;
				if(flag1!=0)
				fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
				fprintf(fp,"\n\tcltd");
				count_sym+=1;
				if(flag2!=0)
				fprintf(fp,"\n\tidivl\t%d(%%rbp), %%eax",off2);
				else
					fprintf(fp,"\n\tidivl\t%%edx, %%eax");
				count_sym+=1;
				if(flag3!=0)
				fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				else
					fprintf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
				}	
				break;
			case Q_MODULO:
				if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_char)
				{
					count_sym+=1;
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);count_sym+=1;
					fprintf(fp,"\n\tcltd");count_sym+=1;
					fprintf(fp,"\n\tidivl\t%d(%%rbp), %%eax",off2);
					fprintf(fp,"\n\tmovl\t%%edx, %%eax");count_sym+=1;
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);count_sym+=1;
				}
				else{
				fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);count_sym+=1;
				fprintf(fp,"\n\tcltd");count_sym+=1;
				fprintf(fp,"\n\tidivl\t%d(%%rbp), %%eax",off2);count_sym++;
				fprintf(fp,"\n\tmovl\t%%edx, %d(%%rbp)",offr);count_sym++;
				}
				break;
			case Q_UNARY_MINUS:
				if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);count_sym++;
					fprintf(fp,"\n\tnegl\t%%eax");count_sym++;
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);count_sym++;
				}
				else{
				fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);count_sym++;
				fprintf(fp,"\n\tnegl\t%%eax");count_sym++;
				fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);count_sym++;
				}
				break;
			case Q_ASSIGN:
				//Check if the second argument is a constant
				if(arg1x[0]>='0' && arg1x[0]<='9')	//first character is number
				{
					count_sym++;
					if(flag1!=0)
					fprintf(fp,"\n\tmovl\t$%s, %d(%%rbp)",arg1x.c_str(),offr);
				}
				else if(arg1x[0] == '\'')
				{
					count_sym++;
					//Character
					fprintf(fp,"\n\tmovb\t$%d, %d(%%rbp)",(int)arg1x[1],offr);
				}
				else if(flag1 && lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_char)
				{
					count_sym++;
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					count_sym++;
				}
				else if(flag1&&lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_int)
				{
					count_sym++;
					if(flag1!=0)
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					count_sym++;
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				}
				else if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL)
				{
					fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off1);count_sym++;
					fprintf(fp,"\n\tmovq\t%%rax, %d(%%rbp)",offr);count_sym++;
				}
				else
				{
					if(flag3!=0)
					{fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);count_sym++;
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);

				}
					else
					{
						fprintf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
						count_sym++;
					}
				}
				break;
			case Q_PARAM:
				if(resx[0] == '_')
				{
					//string
					char* temp = (char*)resx.c_str();count_sym++;
					fprintf(fp,"\n\tmovq\t$.STR%d,\t%%rdi",atoi(temp+1));count_sym++;
				}
				else
				{
					params_stack.push(resx);count_sym++;
					//printf("resx--> %s\n",resx.c_str());
					types_stack.push(lookup(resx,true)->tp_n->basetp);count_sym++;
					offset_stack.push(offr);count_sym++;
					if(lookup(resx,true)->isptrarr==true)
					{
						count_sym++;
						ptrarr_stack.push(1);
					}
					else
					{
						count_sym++;
						ptrarr_stack.push(0);
					}
				}
				break;
			case Q_GOTO:
				if(resx!="-1"&& atoi(resx.c_str())<=end_quad)
					fprintf(fp,"\n\tjmp .L%d",mp_set[atoi(resx.c_str())]);
				else 
					fprintf(fp,"\n\tjmp\t.LRT%d",ret_count);
				break;
			case Q_CALL:
				add_off=function_call(fp);
				count_sym++;
				fprintf(fp,"\n\tcall\t%s",arg1x.c_str());
				if(resx=="")
				{
						count_sym++;
				}
				else if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_int)
				{
					count_sym++;
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				}
				else if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_char)
				{
					count_sym++;
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
				}
				else if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL)
				{
					count_sym++;
					fprintf(fp,"\n\tmovq\t%%rax, %d(%%rbp)",offr);	
				}
				else
				{	
					count_sym++;
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				}
				if(arg1x=="prints")
				{
					count_sym++;
					fprintf(fp,"\n\taddq $8 , %%rsp");
				}
				else 
				{
					count_sym++;
					fprintf(fp,"\n\taddq $%d , %%rsp",add_off);
				}
				break;
			case Q_IF_LESS:
				if(lookup(arg1x,true)!=NULL && lookup(arg1x,true)->tp_n!=NULL&&lookup(arg1x,true)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);count_sym++;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);count_sym++;
					fprintf(fp,"\n\tjl .L%d",mp_set[atoi(resx.c_str())]);count_sym++;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);count_sym++;
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);count_sym++;
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");count_sym++;
					fprintf(fp,"\n\tjl .L%d",mp_set[atoi(resx.c_str())]);count_sym++;
				}
				break;
			case Q_IF_LESS_OR_EQUAL:
				if(lookup(arg1x,true)!=NULL && lookup(arg1x,true)->tp_n!=NULL&&lookup(arg1x,true)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);count_sym++;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);count_sym++;
					fprintf(fp,"\n\tjle .L%d",mp_set[atoi(resx.c_str())]);count_sym++;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);--count_sym;
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);--count_sym;
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");--count_sym;
					fprintf(fp,"\n\tjle .L%d",mp_set[atoi(resx.c_str())]);
					--count_sym;
				}
				break;
			case Q_IF_GREATER:
				if(lookup(arg1x,true)!=NULL && lookup(arg1x,true)->tp_n!=NULL&&lookup(arg1x,true)->tp_n->basetp == tp_char)
				{
					--count_sym;
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					--count_sym;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					--count_sym;
					fprintf(fp,"\n\tjg .L%d",mp_set[atoi(resx.c_str())]);
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);--count_sym;
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);--count_sym;
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");--count_sym;
					fprintf(fp,"\n\tjg .L%d",mp_set[atoi(resx.c_str())]);--count_sym;
				}
				break;
			case Q_IF_GREATER_OR_EQUAL:
				if(lookup(arg1x,true)!=NULL && lookup(arg1x,true)->tp_n!=NULL&&lookup(arg1x,true)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);--count_sym;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);--count_sym;
					fprintf(fp,"\n\tjge .L%d",mp_set[atoi(resx.c_str())]);--count_sym;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);--count_sym;
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);--count_sym;
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");--count_sym;
					fprintf(fp,"\n\tjge .L%d",mp_set[atoi(resx.c_str())]);count_sym--;
				}
				break;
			case Q_IF_EQUAL:
				if(lookup(arg1x,true)!=NULL && lookup(arg1x,true)->tp_n!=NULL&&lookup(arg1x,true)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);--count_sym;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);--count_sym;
					fprintf(fp,"\n\tje .L%d",mp_set[atoi(resx.c_str())]);--count_sym;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);--count_sym;
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);--count_sym;
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");--count_sym;
					fprintf(fp,"\n\tje .L%d",mp_set[atoi(resx.c_str())]);--count_sym;
				}
				break;
			case Q_IF_NOT_EQUAL:
				if(lookup(arg1x,true)!=NULL && lookup(arg1x,true)->tp_n!=NULL&&lookup(arg1x,true)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);--count_sym;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);--count_sym;
					fprintf(fp,"\n\tjne .L%d",mp_set[atoi(resx.c_str())]);--count_sym;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);--count_sym;
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);--count_sym;
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");--count_sym;
					fprintf(fp,"\n\tjne .L%d",mp_set[atoi(resx.c_str())]);--count_sym;
				}
				break;
			case Q_ADDR:
				fprintf(fp,"\n\tleaq\t%d(%%rbp), %%rax",off1);--count_sym;
				fprintf(fp,"\n\tmovq\t%%rax, %d(%%rbp)",offr);--count_sym;
				break;
			case Q_LDEREF:
				fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",offr);--count_sym;
				fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off1);--count_sym;
				fprintf(fp,"\n\tmovl\t%%edx, (%%rax)");--count_sym;
				break;
			case Q_RDEREF:
				fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off1);--count_sym;
				fprintf(fp,"\n\tmovl\t(%%rax), %%eax");--count_sym;
				fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);--count_sym;
				break;
			case Q_RINDEX:
				// Get Address, subtract offset, get memory
				if(lookup(arg1x,true)&&lookup(arg1x,true)->isptrarr==true)
				{
					fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rdx",off1);count_sym+=2;
					fprintf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off2);count_sym+=2;
					fprintf(fp,"\n\taddq\t%%rax, %%rdx");count_sym+=2;
				}
				else
				{
					fprintf(fp,"\n\tleaq\t%d(%%rbp), %%rdx",off1);count_sym+=2;
					fprintf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off2);count_sym+=2;
					fprintf(fp,"\n\taddq\t%%rax, %%rdx");count_sym+=2;
				}
				if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->next&&lookup(resx,true)->tp_n->next->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t(%%rdx), %%eax");count_sym+=2;
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);count_sym+=2;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t(%%rdx), %%eax");count_sym+=2;
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);count_sym+=2;
				}
				break;
			case Q_LINDEX:
				// Get Address, subtract offset, get memory
				if(lookup(resx,true)&&lookup(resx,true)->isptrarr==true)
				{
					fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rdx",offr);count_sym+=2;
					fprintf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off1);count_sym+=2;
					fprintf(fp,"\n\taddq\t%%rax, %%rdx");count_sym+=2;
				}
				else
				{
					fprintf(fp,"\n\tleaq\t%d(%%rbp), %%rdx",offr);count_sym+=2;
					fprintf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off1);count_sym+=2;
					fprintf(fp,"\n\taddq\t%%rax, %%rdx");count_sym+=2;
				}
				if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->next && lookup(resx,true)->tp_n->next->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off2);count_sym+=2;
					fprintf(fp,"\n\tmovb\t%%al, (%%rdx)");count_sym+=2;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off2);count_sym+=2;
					fprintf(fp,"\n\tmovl\t%%eax, (%%rdx)");count_sym+=2;
				}
				break;
			case Q_RETURN:
				//printf("return %s\n",resx.c_str());
				if(resx!="")
				{if(lookup(resx,true)!=NULL && lookup(resx,true)->tp_n!=NULL&&lookup(resx,true)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",offr);count_sym+=2;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",offr);count_sym+=2;
				}}
				else
				{
					fprintf(fp,"\n\tmovl\t$0, %%eax");
					count_sym+=2;
				}
				//printf("Happy\n");
				fprintf(fp,"\n\tjmp\t.LRT%d",ret_count);
				break;
			default:count_sym+=2;
			break;
		}
	}
}

void symtab::function_epilogue(FILE *fp,int count,int ret_count)
{
	fprintf(fp,"\n.LRT%d:",ret_count);count_sym+=2;
	fprintf(fp,"\n\taddq\t$%d, %%rsp",offset);count_sym+=2;
	fprintf(fp,"\n\tmovq\t%%rbp, %%rsp");count_sym+=2;
	fprintf(fp,"\n\tpopq\t%%rbp");count_sym+=2;
	fprintf(fp,"\n\tret");count_sym+=2;
	fprintf(fp,"\n.LFE%d:",count);count_sym+=2;
	fprintf(fp,"\n\t.size\t%s, .-%s",name.c_str(),name.c_str());
}
