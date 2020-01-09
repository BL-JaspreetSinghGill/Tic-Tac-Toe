#!/bin/bash -x

ROWS=3;
COLUMNS=3;

declare -A ticTacToeDictionary;

assignInitialValuesToBoard () {
	for (( i=1; i<=$ROWS; i++ ))
	do
		for (( j=1; j<=$COLUMNS; j++ ))
		do
			ticTacToeDictionary[$i$j]="$i$j";
		done;
	done;
}

displayBoard () {
	for (( i=1; i<=$ROWS; i++ ))
	do
		for (( j=1; j<=$COLUMNS; j++ ))
		do
			echo -ne "${ticTacToeDictionary[$i$j]}\t";
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
		firstTurn="user";
	else
		echo "COMPUTER WILL PLAY FIRST";
		firstTurn="computer";
	fi;
}

checkForValidUserCells () {
	userChoice=$1;

	if [[ $userChoice -ne 1 && $userChoice -ne 2 && $userChoice -ne 3 ]]
	then
		echo "false";
	else
		echo "true";
	fi;
}

getValidationMessage () {
	message=$1;

	echo "$message";
}

checkValidCells () {
	if [ "${ticTacToeDictionary[$userChoice]}" = "X" -o "${ticTacToeDictionary[$userChoice]}" = "O" ]
	then
		getValidationMessage "CELL ALREADY OCCUPIED PLEASE CHOOSE ANOTHER CELL!!!!!!";
		getUserCells;
	fi;
}

getUserCells () {
	read -p "ENTER THE ROW : " userRow;
	userChoiceRowFlag=$(checkForValidUserCells $userRow);
	if [ "$userChoiceRowFlag" = "true" ]
	then
		read -p "ENTER THE COLUMN : " userColumn;
   	userChoiceColumnFlag=$(checkForValidUserCells $userColumn);
		if [ "$userChoiceColumnFlag" = "false" ]
		then
			getValidationMessage "PLEASE ENTER VALID COLUMN!!!!";
			getUserCells;
		fi;
	else
		getValidationMessage "PLEASE ENTER VALID ROW!!!!";
		getUserCells;
	fi;

	userChoice="$userRow""$userColumn";
	checkValidCells;
}

getComputerCellRandomValue () {
	echo $((RANDOM%3+1));
}

getComputerCells () {
	computerChoice="";

	for (( i=0; i<2; i++ ))
	do
		computerChoice="$computerChoice""$(getComputerCellRandomValue)";
	done;
}

storeInDictionary () {
	position=$1;
	value=$2;

	ticTacToeDictionary[$position]="$value";
}

playGame () {
	getComputerCells;
	storeInDictionary $computerChoice $computerLetter;
	displayBoard;
	getUserCells;
	storeInDictionary $userChoice $userLetter;
   displayBoard;
}

ticTacToeMain () {
	assignInitialValuesToBoard;
	displayBoard;

	getUserLetter;
	checkForFirstTurn;
	playGame;
}

ticTacToeMain;
