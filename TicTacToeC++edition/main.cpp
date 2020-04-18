#include <iostream>
#include <string>

int main() {
data:
	int grid[9]  = { 0,0,0,0,0,0,0,0,0 };
	char charGrid[9] = { ' ',' ',' ',' ',' ',' ',' ',' ',' ' };
	int turn = 0;
	

	std::string welcomeMessage = "Welcome to hardcore tictactoe at the fastest speed possible on machine\n";
	std::string selectMessage = "Player 1, pick 3 for X or 4 for O\n";

	std::string stalemateMessage = "stalemate!\n";
	std::string spotMessage = "Spot not empty, try again\n";
	std::string turnMessage = "Next player's turn!\n\n";

	int p1Symbol = 3;//$S1
	int p2Symbol = 4;//$S2

preGame:
	int tempInput = 0;
	std::cout << welcomeMessage;
	std::cout << selectMessage;

	std::cin >> tempInput;

	if (tempInput == 3)
		goto gameLoop;
	if (tempInput == 4)
		goto symbolSwap;

	goto preGame;

symbolSwap:
	p1Symbol++;
	p2Symbol--;


gameLoop:
	int xPos = 0, yPos = 0;
	int finalPos = 0;
	int whoWins = 2;

	//if turn is 9 then no spots are left
	if (turn == 9) {
		std::cout << stalemateMessage;
		goto exit;
	}


	//draw the grid
	std::cout << charGrid[0] << "|" << charGrid[1] << "|" << charGrid[2] << "\n";
	std::cout << charGrid[3] << "|" << charGrid[4] << "|" << charGrid[5] << "\n";
	std::cout << charGrid[6] << "|" << charGrid[7] << "|" << charGrid[8] << "\n";
	//let them pick a spot by typing 0 (enter) 3 like a 2D array
	//don't use an actual 2D array, let evyn do his dimension math

input:
	std::cin >> xPos >> yPos;
	finalPos = xPos + yPos * 3;

	if (grid[finalPos] == 0)
		grid[finalPos] = turn % 2 == 0 ? p1Symbol : p2Symbol;
	else {
		std::cout << spotMessage;
		goto input;
	}

	for (unsigned i = 0; i < 9; i++) {
		if (grid[i] == 0)
			charGrid[i] = ' ';
		else if (grid[i] == 3)
			charGrid[i] = 'x';
		else if (grid[i] == 4)
			charGrid[i] = 'o';
	}

	//draw the grid
	std::cout << charGrid[0] << "|" << charGrid[1] << "|" << charGrid[2] << "\n";
	std::cout << charGrid[3] << "|" << charGrid[4] << "|" << charGrid[5] << "\n";
	std::cout << charGrid[6] << "|" << charGrid[7] << "|" << charGrid[8] << "\n";

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

	std::cout << turnMessage;
	system("pause");

	goto gameLoop;

exit:

	system("pause");

	return 0;
}