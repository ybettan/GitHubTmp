#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#define ACCURACY 0.000001 /* Very good!! */


double my_sin (double x)
{
	int sign = 1, a = 2 , b = 3;
	double sum = 0, numerator = x, term = x, denumerator = 1;
	while (fabs(term) > ACCURACY)
	{
		term = numerator/denumerator;
        /* FIXME: get used to sum += sign*term */
		sum = sum + sign*term;
		numerator = numerator * x * x;
        /* FIXME: get used to denumerator *= a*b */
		denumerator = denumerator * a * b;
		sign*=-1;
		a+=2;
		b+=2;
	}
	return sum;
	
}

int main()
{
	double x;
	printf("Please enter any real number between -25 to 25: \n");
	scanf("%lf", &x);
	printf("Your number is: %f.\nThe answer for sin(%f) with my calculation is: %f\n",x,x,
	my_sin(x));
	printf("The answer with the standard library is: sin(%f) = %f\n" , x, sin(x));
	
    /*FIXME: fix the indention. */
 return 0;
}

