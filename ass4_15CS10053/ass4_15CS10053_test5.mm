int main()
{
	//to check for all the loops
	int i,j=0,k=0;
	int sum=5;
	Matrix a[10][10];
	int x=2,y=5;
	for(i=0;i<sum;i++)
	{
		while(j<sum){
			a[i][j]=x+y;
			x++;
			y--;
			j++;
		}
		j=0;
	}
	sum=0;
	do{
		x=x+y;
		sum++;
	}while(sum>0&&sum<5);
	int whiley=1;
	while(whiley)
	{
		whiley--;
	}
}