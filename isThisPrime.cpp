/*Luísa Souza Moura
* 	-Just a game to learn the prime numbers
*/

#include <stdlib.h>
#include <iostream>
#include <vector>
#include <ctime>

using namespace std;

/*Linear sieve - O(n):
*	Goes throw all the numbers from 2 to max. If the
*	number is not composite, it is added to a vector.
*	For all the prime numbers in the vector, their 
*	multiples are marked as composites.
*
* Paramethers:
*	- int max: the greatest number to consider
*	- bool* isComposite: an array to mark the composite numbers
*
* Return:
*	- vector <int>: a vector with the prime numbers
*/
vector<int> sieve(int max, int* isComposite) {
	vector <int> prime;

	fill(isComposite, isComposite + max, false);

	for(int i = 2; i < max; i++) {	
		if(!isComposite[i]) prime.push_back(i);
		
		int size = prime.size();
		for(int j = 0; j < size && i * prime[j] < max; j++) {
			
			isComposite[i * prime[j]] = prime[j];
			if(i % prime[j] == 0) break;
		}
	}

	return prime;
}

/*EndGame
* Just print the options when you loose
*/
void endGame(char* ans) {
	printf("\n\n\t----------\n");
	printf("To go back to the menu, type \"m\"\n");
	printf("To Play Again, type \"a\"\n");
	printf("To quit, type \"q\"\n");
	printf("\t----------\n");
	scanf(" %c", ans);
}

/*Menu
* Just print the menu options
*/
void menu(char* yes, char* no, int* level){
	printf("=============== Is this prime ==============\n");
	printf("You just got to tell us if a number is prime\n");
	printf("Remember: you have to get it right and to be\n");
	printf("         fast enough. Good luck \\o/        \n");

	printf("\nChoose a key to represent \"yes\":\n");
	scanf(" %c", yes);
	printf("Now Choose a key to represent \"no\"\n");
	scanf(" %c", no);
	printf("And choose a dificulty level (1-9)\n");
	scanf("%d", level);
}

int main(int argc, char* argv[]){
	system("clear");

	int total = 10005, level;
	int isComposite[total];

	bool playing = true;
	bool timeUp = false, wrongAns = false;
	
	time_t time1, time2;

	char ans, yes, no;

	vector<int> prime = sieve(total, isComposite);

	menu(&yes, &no, &level);

	do{
		printf("\nAll set... Ready to play?\n");
	} while(scanf(" %c", &ans) && ans != yes);

	// random numbers are generated, if it takes too long for the
	// player to type the answer or it's wrong, the game is over
	while(playing) {
		int num, rightAns = 0, min = 1, max = 50;
		timeUp = false;
		wrongAns = false;
		
		while(max < total) {
			num = (rand() % (max - min + 1)) + min;
			printf("\n%d\n", num);
			
			time(&time1);
			if(scanf(" %c", &ans)) time(&time2);
			fflush(stdin);
			
			if(time2 - time1 >= (11 - level)) timeUp = true; //the greatest levels have less time to answer
			
			if(ans == yes && isComposite[num]) wrongAns = true;
			else if(ans == no && !isComposite[num]) wrongAns = true;

			if(timeUp || wrongAns) break;			
			
			rightAns++;
			max += (50 * (rightAns % (12 - level) == 0)); //the greater the level, the faster the max increases
		}

		if(timeUp) printf("\nTime's up =(\n");
		else if(wrongAns) printf("\nWrong answer =(\n");
		else printf("You are a prime master!\n");
		
		if(!isComposite[num] && (timeUp || wrongAns)) printf("%d is prime\n", num);
		else if(isComposite[num] && (timeUp || wrongAns)) printf("%d is composite and can be written as %d*%d\n", num, isComposite[num], num/isComposite[num]);

		printf("Your score was: %d\n", rightAns);

		endGame(&ans);
		if(ans == 'm') menu(&yes, &no, &level);
		else if(ans == 'q') playing = false; 
	}
	
	if(timeUp || wrongAns) system("clear");
	return 0;
}