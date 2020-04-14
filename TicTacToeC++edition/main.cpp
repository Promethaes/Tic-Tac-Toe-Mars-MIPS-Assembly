#include <iostream>


int main() {
data:
	int grid[9] = { 0,0,0,0,0,0,0,0,0 };
	int turn = 0;
	int p1Symbol = 3;
	int p2Symbol = 4;

preGame:
	int tempInput = 0;
	std::cout << "welcome to hardcore tictactoe at the fastest speed possible on machine\n";
	std::cout << "player 1, pick 3 for x, or 4 for y\n";

	std::cin >> tempInput;
	if (tempInput != 3 && tempInput != 4)
		goto preGame;

	p1Symbol = tempInput;
	if (p1Symbol == 3)
		p2Symbol = 4;
	else
		p2Symbol = 3;

gameLoop:
	int xPos = 0, yPos = 0;
	int finalPos = 0;
	int whoWins = 2;

	//if turn is 9 then no spots are left
	if (turn == 9)
		goto exit;


	//draw the grid
	std::cout << grid[0] << "\t|" << grid[1] << "\t|" << grid[2] << "\n";
	std::cout << grid[3] << "\t|" << grid[4] << "\t|" << grid[5] << "\n";
	std::cout << grid[6] << "\t|" << grid[7] << "\t|" << grid[8] << "\n";
	//let them pick a spot by typing 0 (enter) 3 like a 2D array
	//don't use an actual 2D array, let evyn do his dimension math

input:
	std::cin >> xPos >> yPos;
	finalPos = xPos + yPos * 3;

	if (grid[finalPos] == 0)
		grid[finalPos] = turn % 2 == 0 ? p1Symbol : p2Symbol;
	else {
		std::cout << "spot not empty, try again\n";
		goto input;
	}

	//draw the grid
	std::cout << grid[0] << "\t|" << grid[1] << "\t|" << grid[2] << "\n";
	std::cout << grid[3] << "\t|" << grid[4] << "\t|" << grid[5] << "\n";
	std::cout << grid[6] << "\t|" << grid[7] << "\t|" << grid[8] << "\n";

	//determine if player1 or player2 has won

	//0 for player 1, 1 for player 2, 2 for no one
	//vertical
	if (grid[0] + grid[3] + grid[6] == 3 * p1Symbol
		|| grid[1] + grid[4] + grid[7] == 3 * p1Symbol
		|| grid[2] + grid[5] + grid[8] == 3 * p1Symbol)
		whoWins = 0;
	//horizontal
	if (grid[0] + grid[1] + grid[2] == 3 * p1Symbol
		|| grid[3] + grid[4] + grid[5] == 3 * p1Symbol
		|| grid[6] + grid[7] + grid[8] == 3 * p1Symbol)
		whoWins = 0;
	//diagonal
	if (grid[0] + grid[4] + grid[8] == 3 * p1Symbol
		|| grid[6] + grid[4] + grid[2] == 3 * p1Symbol)
		whoWins = 0;

	//vertical
	if (grid[0] + grid[3] + grid[6] == 3 * p2Symbol
		|| grid[1] + grid[4] + grid[7] == 3 * p2Symbol
		|| grid[2] + grid[5] + grid[8] == 3 * p2Symbol)
		whoWins = 1;
	//horizontal
	if (grid[0] + grid[1] + grid[2] == 3 * p2Symbol
		|| grid[3] + grid[4] + grid[5] == 3 * p2Symbol
		|| grid[6] + grid[7] + grid[8] == 3 * p2Symbol)
		whoWins = 1;
	//diagonal
	if (grid[0] + grid[4] + grid[8] == 3 * p2Symbol
		|| grid[6] + grid[4] + grid[2] == 3 * p2Symbol)
		whoWins = 1;

	if (whoWins == 0) {
		std::cout << "player 1 wins!\n";
		goto exit;
	}
	else if (whoWins == 1) {
		std::cout << "player 2 wins\n";
		goto exit;
	}

	turn++;

	std::cout << "Next player's turn!\n\n";
	system("pause");

	goto gameLoop;

exit:

	system("pause");

	return 0;
}