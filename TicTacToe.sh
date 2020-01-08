#!/bin/bash -x

ROWS=3;
COLUMNS=3;

declare -a ticTacToeArray;

assignInitialValuesToBoard () {
	for (( i=1; i<=$ROWS; i++ ))
	do
		for (( j=1; j<=$COLUMNS; j++ ))
		do
			(( ticTacToeArray[${i}, ${j}]=8 ));
		done;
	done;
}

displayBoard () {
	for (( i=1; i<=$ROWS; i++ ))
	do
		for (( j=1; j<=$COLUMNS; j++ ))
		do
			echo -ne "${ticTacToeArray[${i}, ${j}]}\t";
		done;
		echo "";
	done;
}

getRandomValue () {
	echo $((RANDOM%2));
}

getUserLetter () {
	userValue=$(getRandomValue);

	if [[ $userValue -eq 1 ]]
	then
		userLetter="X";
		computerLetter="O";
	else
		userLetter="O";
		computerLetter="X";
	fi;

	echo "USER LETTER : " $userLetter;
	echo "COMPUTER LETTER : " $computerLetter;
}

checkForFirstTurn () {
	randomValue=$(getRandomValue);

	if [[ $randomValue -eq 1 ]]
	then
		echo "YOU WILL PLAY FIRST";
	else
		echo "COMPUTER WILL PLAY FIRST";
	fi;
}

ticTacToeMain () {
	assignInitialValuesToBoard;
	displayBoard;

	getUserLetter;
	checkForFirstTurn;
}

ticTacToeMain;
