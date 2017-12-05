int fib(int x){
	if(x<=1)
		return 1;
	else return fib(x-1)+fib(x-2);	
}	

int main()
{
	int n;
	readInt(&n);
	printInt(n);
	
	printStr("\nHeya!");
	
	n = fib(6);
	printInt(n);
	}
	

