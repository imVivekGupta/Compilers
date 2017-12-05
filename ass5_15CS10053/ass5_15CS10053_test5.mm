double mult(double a,int b);
char garb(int a,double b, char c);
int main()
{
	//declaration of all types
	char a='a',b='b',c='c';
	Matrix A[2][3] = {1.0,2.0,3.0;4.0,5.0,6.0},B[2][3]={6.0,5.9,3.9;3.0,2.0,1.0},C[2][3];
	Matrix A_[3][2];
	
	C = A+B;
	C = A-B;
	C = A*B;
	A_ = A.';
	
	char *d=&a;
	int k=9;
	int l=k+10;
	int  i = 50, *p = &i;
}

double mult(double a,int b)
{
	double ans;
	ans=a * b;
	return ans;
}

char garb(int a,double b, char c)
{
	double kt=b;
	char *p=&c;
	int i=a+b;
	return c;
}
