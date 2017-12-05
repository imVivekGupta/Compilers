int main()
{
	//to test the if else conditions and LIBRARY FUNCTIONS
	int a=2,b;
	b=3;
	printInt(b);
	readInt(&a);
	char c='i';
	char d='k';
	char sum='0';
	if(b>a)
	{
		if(c>d)
		{
			sum=sum+c;
			sum=sum+b;
		}
		else
		{
			sum=sum+d;
			sum=sum+b;
		}
	}
	else
	{
		if(c>d)
		{
			sum=sum+c;
			sum=sum+a;
		}
		else
		{
			sum=sum+d;
			sum=sum+a;
		}
	}
}
