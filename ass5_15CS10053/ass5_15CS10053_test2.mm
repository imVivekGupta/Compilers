int sum(int a,int b);
int mod(int a, int b);
int mod_2(int a,int b);
int divide(int a,int b);

int main()
{
	//testing the function declarations and generation of quads for it
	int x=2,y=5;
	int sm=sum(x,y);
	int md=mod(x,y);
	int md_2=mod_2(x,y);
	if(md==md_2)
	{
		y=0;
	}
	else{
		y=1;
	}
	mod_2(x,y);
}

int sum(int a,int b)
{
	int ans=a+b;
	return ans;
}

int mod(int a,int b)
{
	int ans=a%b;
	return ans;
}

int divide(int a,int b)
{
	int ans;
	if(b!=0)
		ans=a/b;
	else
		ans=-1;
	return ans;
}
int mod_2(int a,int b)
{
	int ans;
	if(a>b)
		ans=a-divide(a,b);
	else
		ans=b-divide(a,b);
	return ans;
}
