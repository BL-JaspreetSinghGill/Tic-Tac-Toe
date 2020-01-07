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
	else
		userLetter="O";
	fi;

	echo "USER LETTER : " $userLetter;
}

ticTacToeMain () {
	assignInitialValuesToBoard;
	displayBoard;

	getUserLetter;
}

ticTacToeMain;
